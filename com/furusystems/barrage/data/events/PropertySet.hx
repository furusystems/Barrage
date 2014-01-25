package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.instancing.RunningAction;
import motion.Actuate;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySet extends EventDef
{
	public var speed:Speed;
	public var direction:Direction;
	public var acceleration:Acceleration;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_SET;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		#if debug
		trace("Property set");
		#end
		
		var props:Dynamic = { };
		if (speed != null) {
			props.speed = speed.get(runningBarrage, runningAction);
		}
		if (direction != null) {
			if (direction.isAimed) {
				props.angle = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
			}else {
				props.angle = direction.get(runningBarrage, runningAction);
			}
		}
		if (acceleration != null) {
			props.acceleration = acceleration.get(runningBarrage, runningAction);
		}
		Actuate.tween(runningAction.currentBullet, 0, props);
	}
	
}