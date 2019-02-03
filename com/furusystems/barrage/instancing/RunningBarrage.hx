package com.furusystems.barrage.instancing;

import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.properties.Property;
import com.furusystems.barrage.instancing.animation.Animator;
import com.furusystems.barrage.instancing.events.FireEvent;
import com.furusystems.barrage.instancing.IOrigin;
import glm.Vec2;
import fsignal.Signal1;
import haxe.ds.GenericStack;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RunningBarrage {
	public var owner:Barrage;
	public var initAction:RunningAction;
	// public var allActions:Vector<RunningAction>;
	public var activeActions:Array<RunningAction>;
	public var time:Float = 0;
	public var onComplete:Signal1<RunningBarrage>;
	public var lastBulletFired:IBarrageBullet;
	public var animators:GenericStack<Animator>; // TODO: Replace with vector pool?
	public var bullets:GenericStack<IBarrageBullet>;
	public var speedScale:Float;
	public var accelScale:Float;

	static var basePositionVec = new Vec2();

	var started:Bool;
	var lastDelta:Float = 0;

	public var emitter:IBulletEmitter;

	public function new(emitter:IBulletEmitter, owner:Barrage, speedScale:Float = 1.0, accelScale:Float = 1.0) {
		this.speedScale = speedScale;
		this.accelScale = accelScale;
		onComplete = new Signal1<RunningBarrage>();
		this.emitter = emitter;
		this.owner = owner;
		activeActions = [];
		bullets = new GenericStack<IBarrageBullet>();
		animators = new GenericStack<Animator>();
	}

	public function start():Void {
		time = lastDelta = 0;
		owner.executor.variables.set("barragetime", time);
		runAction(null, new RunningAction(this, owner.start));
		started = true;
	}

	public function stop():Void {
		while (activeActions.length > 0) {
			stopAction(activeActions[0]);
		}
		started = false;
	}

	public inline function update(delta:Float) {
		if (!started)
			return;
		time += delta;
		lastDelta = delta;

		cleanBullets();
		updateAnimators(delta);

		owner.executor.variables.set("barragetime", time);

		if (activeActions.length == 0 || bullets.isEmpty()) {
			stop();
			onComplete.dispatch(this);
		} else {
			var i = activeActions.length;
			while (i-- > 0) {
				activeActions[i].update(this, delta);
			}
		}
	}

	inline function cleanBullets():Void {
		for (b in bullets) {
			if (!b.active)
				bullets.remove(b);
		}
	}

	inline function updateAnimators(delta:Float) {
		for (a in animators) {
			if (a.update(delta) == false) {
				animators.remove(a);
			}
		}
	}

	public function getAnimator(target:IBarrageBullet):Animator {
		for (a in animators) {
			if (a.target == target)
				return a;
		}
		var a = new Animator(target);
		animators.add(a);
		return a;
	}

	public inline function runActionByID(triggerAction:RunningAction, id:Int, ?triggerBullet:IBarrageBullet, ?overrides:Array<Property>,
			delta:Float = 0):RunningAction {
		return runAction(triggerAction, new RunningAction(this, owner.actions[id]), triggerBullet, overrides, delta);
	}

	public inline function runAction(triggerAction:RunningAction, action:RunningAction, ?triggerBullet:IBarrageBullet, ?overrides:Array<Property>,
			delta:Float = 0):RunningAction {
		activeActions.push(action);
		if (triggerAction != null) {
			action.prevAccel = triggerAction.prevAccel;
			action.prevSpeed = triggerAction.prevSpeed;
			action.prevAngle = triggerAction.prevAngle;
			action.prevPositionX = triggerAction.prevPositionX;
			action.prevPositionY = triggerAction.prevPositionY;
		}
		action.enter(triggerAction, this, overrides);
		if (triggerBullet != null) {
			action.currentBullet = action.triggeringBullet = triggerBullet;
		}
		action.update(this, delta);
		return action;
	}

	public inline function stopAction(action:RunningAction) {
		action.exit(this);
		activeActions.remove(action);
		// trace("Stop action: "+action.def.name);
	}

	public function dispose() {
		while (activeActions.length > 0) {
			stopAction(activeActions[0]);
		}
		emitter = null;
	}

	static var tempVec:Vec2 = new Vec2();

	function applyProperty(origin:Vec2, base:Float, prev:Float, prop:Property, runningBarrage:RunningBarrage,
			runningAction:RunningAction):Float {
		var other = prop.get(runningBarrage, runningAction);
		if (prop.modifier.has(INCREMENTAL)) {
			return prev + other;
		} else if (prop.modifier.has(RELATIVE)) {
			return base + other;
		} else if (prop.modifier.has(AIMED)) {
			return emitter.getAngleToPlayer(origin.x, origin.y) + other;
		} else if (prop.modifier.has(RANDOM)) {
			return runningBarrage.randomAngle() + other;
		} else {
			return other;
		}
	}

	public function randomAngle():Float {
		return Math.random() * 360;
	}

	inline function getOrigin(action:RunningAction):IOrigin {
		if (action.triggeringBullet == null) {
			if (action.callingAction != null)
				return getOrigin(action.callingAction);
			return emitter;
		} else
			return action.triggeringBullet;
	}

	public function fire(action:RunningAction, event:FireEvent, bulletID:Int, delta:Float):IBarrageBullet {
		var bd:BulletDef = bulletID == -1 ? owner.defaultBullet : owner.bullets[bulletID];

		var origin = getOrigin(action);

		var baseSpeed:Float = bd.speed.get(this, action);
		var baseAccel:Float = bd.acceleration.get(this, action);
		var baseDirection:Float = 0;
		var basePosition = basePositionVec;

		var lastSpeed = action.prevSpeed;
		var lastDirection = action.prevAngle;
		var lastAcceleration = action.prevAccel;
		var lastPositionX = action.prevPositionX;
		var lastPositionY = action.prevPositionY;

		basePosition.x = origin.posX;
		basePosition.y = origin.posY;
		if (event.def.position != null) {
			var vec = event.def.position.getVector(this, action);
			if (event.def.position.modifier.has(RELATIVE)) {
				basePosition.x = origin.posX + vec[0];
				basePosition.y = origin.posY + vec[1];
			} else if (event.def.position.modifier.has(INCREMENTAL)) {
				basePosition.x = lastPositionX + vec[0];
				basePosition.y = lastPositionY + vec[1];
			}
		}

		if (bd == owner.defaultBullet) {
			baseDirection = emitter.getAngleToPlayer(basePosition.x, basePosition.y);
		} else {
			baseDirection = bd.direction.get(this, action);
		}

		if (event.def.speed != null) {
			baseSpeed = applyProperty(basePosition, baseSpeed, lastSpeed, event.def.speed, this, action);
		}
		if (event.def.acceleration != null) {
			baseAccel = applyProperty(basePosition, baseAccel, lastAcceleration, event.def.acceleration, this, action);
		}
		if (event.def.direction != null) {
			baseDirection = applyProperty(basePosition, baseDirection, lastDirection, event.def.direction, this, action);
			if (event.def.direction.modifier.has(RELATIVE)) {
				baseDirection = action.triggeringBullet.angle + baseDirection;
			}
		}

		action.prevSpeed = baseSpeed;
		action.prevAngle = baseDirection;
		action.prevAccel = baseAccel;
		action.prevPositionX = basePosition.x;
		action.prevPositionY = basePosition.y;

		var spd = baseSpeed * speedScale;
		lastBulletFired = emitter.emit(action.prevPositionX, action.prevPositionY, baseDirection, spd, baseAccel * accelScale, delta);
		lastBulletFired.speed = spd;
		lastBulletFired.angle = baseDirection;
		bullets.add(lastBulletFired);
		return lastBulletFired;
	}
}
