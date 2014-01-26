package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.PropertyTweenDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import motion.Actuate;
import motion.easing.Linear;

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
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		#if debug
		trace("Property tween");
		#end
		
		var tweenTimeNum:Float;
		if (def.scripted) {
			tweenTimeNum = runningBarrage.owner.executor.execute(def.tweenTimeScript);
		}else {
			tweenTimeNum = def.tweenTime;
		}
		if (def.durationType == FRAMES) {
			tweenTimeNum = (tweenTimeNum * 1 / runningBarrage.owner.frameRate);
		}
		var props:Dynamic = { };
		if (def.speed != null) {
			if (def.relative) {
				props.speed = runningAction.currentBullet.speed + def.speed.get(runningBarrage, runningAction);
			}else {
				props.speed = def.speed.get(runningBarrage, runningAction);
			}
		}
		if (def.direction != null) {
			var ang:Float = 0;
			if (def.direction.isAimed) {
				var currentAngle:Float = runningAction.currentBullet.angle;
				ang = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
				while (ang - currentAngle > 180) ang -= 360;
				while (ang - currentAngle < -180) ang += 360;
			}else {
				ang = def.direction.get(runningBarrage, runningAction);
			}
			if (def.relative) {
				props.angle = runningAction.currentBullet.angle + ang;
			}else {
				props.angle = ang;
			}
			
		}
		if (def.acceleration != null) {
			var accel = def.acceleration.get(runningBarrage, runningAction);
			if (def.relative) {
				props.acceleration = runningAction.currentBullet.acceleration + accel;
			}else {
				props.acceleration = accel;
			}
		}
		Actuate.tween(runningAction.currentBullet, tweenTimeNum, props,false).ease(Linear.easeNone);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}