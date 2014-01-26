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
			props.speed = def.speed.get(runningBarrage, runningAction);
		}
		if (def.direction != null) {
			if (def.direction.isAimed) {
				var ang = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
				while (ang > 180) ang -= 360;
				while (ang < -180) ang += 360;
				
				props.angle = ang;
			}else {
				props.angle = def.direction.get(runningBarrage, runningAction);
			}
		}
		if (def.acceleration != null) {
			props.acceleration = def.acceleration.get(runningBarrage, runningAction);
		}
		Actuate.tween(runningAction.currentBullet, tweenTimeNum, props).ease(Linear.easeNone);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}