package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.PropertyTweenDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertyTween implements ITriggerableEvent
{
	public var hasRun:Bool;
	public var def:PropertyTweenDef;
	public function new(def:EventDef) 
	{
		this.def = cast def;
	}
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage, delta:Float):Void 
	{
		
		var tweenTimeNum:Float;
		if (def.scripted) {
			tweenTimeNum = runningBarrage.owner.executor.execute(def.tweenTimeScript);
		}else {
			tweenTimeNum = def.tweenTime;
		}
		if (def.durationType == FRAMES) {
			tweenTimeNum = (tweenTimeNum * 1 / runningBarrage.owner.frameRate);
		}
		var bullet = runningAction.triggeringBullet;
		var animator = runningBarrage.getAnimator(bullet);
		if (def.speed != null) {
			var speedAnimator = animator.getSpeed();
			var speedValue = 0.0;
			if (def.relative) {
				speedValue = bullet.speed + def.speed.get(runningBarrage, runningAction);
			}else {
				speedValue = def.speed.get(runningBarrage, runningAction);
			}
			speedAnimator.retarget(bullet.speed, speedValue, tweenTimeNum, delta);
		}
		if (def.direction != null) {
			var angleAnimator = animator.getAngle();
			var ang:Float = 0;
			if (def.direction.modifier.has(AIMED)) {
				var currentAngle:Float = bullet.angle;
				ang = runningBarrage.emitter.getAngleToPlayer(bullet.pos);
				while (ang - currentAngle > 180) ang -= 360;
				while (ang - currentAngle < -180) ang += 360;
			}else {
				ang = def.direction.get(runningBarrage, runningAction);
			}
			if (def.relative) {
				ang = bullet.angle + ang;
			}
			angleAnimator.retarget(bullet.angle, ang, tweenTimeNum, delta);
			
		}
		if (def.acceleration != null) {
			var accelAnimator = animator.getAcceleration();
			var accel = def.acceleration.get(runningBarrage, runningAction);
			if (def.relative) {
				accel = bullet.acceleration + accel;
			}
			accelAnimator.retarget(bullet.acceleration, accel, tweenTimeNum, delta);
		}
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}