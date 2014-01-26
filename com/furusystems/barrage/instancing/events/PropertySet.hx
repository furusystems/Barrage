package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.PropertySetDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.instancing.RunningAction;
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
			props.speed = def.speed.get(runningBarrage, runningAction);
		}
		if (def.direction != null) {
			if (def.direction.isAimed) {
				props.angle = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
			}else {
				props.angle = def.direction.get(runningBarrage, runningAction);
			}
		}
		if (def.acceleration != null) {
			props.acceleration = def.acceleration.get(runningBarrage, runningAction);
		}
		Actuate.tween(runningAction.currentBullet, 0, props);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}