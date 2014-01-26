package com.furusystems.barrage.instancing;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.properties.Property;
import com.furusystems.barrage.instancing.events.FireEvent;
import com.furusystems.barrage.instancing.IOrigin;
import com.furusystems.flywheel.events.Signal1.Signal1;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.math.MathUtils;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RunningBarrage
{
	public var owner:Barrage;
	public var initAction:RunningAction;
	//public var allActions:Vector<RunningAction>;
	public var activeActions:Array<RunningAction>;
	public var time:Float = 0;
	
	public var lastBulletFired:IBullet;
	
	var bullets:Array<IBullet>;
	var started:Bool;
	var lastDelta:Float = 0;
	public var emitter:IBulletEmitter;
	
	public function new(emitter:IBulletEmitter, owner:Barrage) 
	{
		this.emitter = emitter;
		this.owner = owner;
		bullets = [];
		activeActions = [];
		initAction = new RunningAction(this, owner.start);
	}
	public function start():Void {
		time = 0;
		runAction(null, initAction);
		started = true;
	}
	public function stop():Void {
		while (activeActions.length > 0) {
			stopAction(activeActions[0]);
		}
		started = false;
	}
	public function update(delta:Float) {
		if (!started) return;
		time += delta;
		lastDelta = delta;
		for (a in activeActions) {
			a.update(this, delta);
		}
	}
	public inline function runActionByID(triggerAction:RunningAction, id:Int, ?triggerBullet:IBullet):RunningAction {
		return runAction(triggerAction, new RunningAction(this, owner.actions[id]), triggerBullet);
	}
	
	public inline function runAction(triggerAction:RunningAction, action:RunningAction, ?triggerBullet:IBullet):RunningAction 
	{
		//trace("Start action: "+action.def.name);
		activeActions.push(action);
		if(triggerAction!=null){
			action.prevAccel = triggerAction.prevAccel;
			action.prevSpeed = triggerAction.prevSpeed;
			action.prevAngle = triggerAction.prevAngle;
		}
		action.enter(triggerAction, this);
		if (triggerBullet != null) {
			action.currentBullet = action.triggeringBullet = triggerBullet;
		}
		action.update(this, lastDelta);
		return action;
	}
	public inline function stopAction(action:RunningAction) {
		action.exit(this);
		activeActions.remove(action);
		//trace("Stop action: "+action.def.name);
	}
	
	public function dispose() 
	{
		while(activeActions.length>0){
			stopAction(activeActions[0]);
		}
		emitter = null;
	}
	
	static var tempVec:Vector2D = new Vector2D();
	
	function applyProperty(isAngle:Bool, base:Float, prev:Float, prop:Property, runningBarrage:RunningBarrage, runningAction:RunningAction):Float {
		var other = prop.get(runningBarrage, runningAction);
		switch(prop.modifier) {
			case ABSOLUTE:
				return other;
			case INCREMENTAL:
				return prev + other; 
			case RELATIVE:
				return base + other;
			case AIMED:
				return emitter.getAngleToPlayer(getOrigin(runningAction).pos) + other;
			case RANDOM:
				return runningBarrage.randomAngle() + other;
		}
		
	}
	
	public function randomAngle():Float 
	{
		return Math.random() * 360;
	}
	
	inline function getOrigin(action:RunningAction):IOrigin {
		if (action.triggeringBullet == null) {
			if (action.callingAction != null) return getOrigin(action.callingAction);
			return emitter;
		}
		else return action.triggeringBullet;
	}
	
	public function fire(action:RunningAction, event:FireEvent, bulletID:Int):IBullet 
	{
		var bd:BulletDef = bulletID == -1?owner.defaultBullet:owner.bullets[bulletID];
		
		var origin = getOrigin(action);
		
		var baseSpeed:Float = bd.speed.get(this, action);
		var baseAccel:Float = bd.acceleration.get(this, action);
		var baseDirection:Float;
		if (bd == owner.defaultBullet) {
			baseDirection = emitter.getAngleToPlayer(origin.pos);
		}else {
			baseDirection = bd.direction.get(this, action);
		}
		
		var lastSpeed = action.prevSpeed;
		var lastDirection = action.prevAngle;
		var lastAcceleration = action.prevAccel;
		
		if (event.def.speed != null) {
			baseSpeed = applyProperty(false, baseSpeed, lastSpeed, event.def.speed, this, action);
		}
		if (event.def.acceleration != null) {
			baseAccel = applyProperty(false, baseAccel, lastAcceleration, event.def.acceleration, this, action);
		}
		if (event.def.direction != null) {
			baseDirection = applyProperty(true, baseDirection, lastDirection, event.def.direction, this, action);
		}
		
		
		action.prevSpeed = baseSpeed;
		action.prevAngle = baseDirection;
		action.prevAccel = baseAccel;
		
		
		lastBulletFired = emitter.emit(origin.pos, baseDirection, baseSpeed, baseAccel);
		lastBulletFired.speed = baseSpeed;
		lastBulletFired.angle = baseDirection;
		return lastBulletFired;
	}
	
}