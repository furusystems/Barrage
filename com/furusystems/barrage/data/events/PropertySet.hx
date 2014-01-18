package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySet extends EventDef
{
	public var speed:Speed;
	public var direction:Direction;
	public var acceleration:Acceleration;
	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.PROPERTY_SET;
		speed = new Speed();
		direction = new Direction();
		acceleration = new Acceleration();
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		trace("Property set");
	}
	
}