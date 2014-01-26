package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import motion.Actuate;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySetDef extends EventDef
{
	public var speed:Speed;
	public var direction:Direction;
	public var acceleration:Acceleration;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_SET;
	}
	
}