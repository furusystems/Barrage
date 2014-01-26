package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.PropertySetDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import motion.Actuate;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySet implements ITriggerableEvent
{
	public var hasRun:Bool;
	public var def:PropertySetDef;
	public function new(def:EventDef) 
	{
		this.def = cast def;
	}
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		#if debug
		trace("Property set");
		#end
		
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
				ang = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
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
		Actuate.tween(runningAction.currentBullet, 0, props);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}