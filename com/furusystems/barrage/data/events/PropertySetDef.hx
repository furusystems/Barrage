package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySetDef extends EventDef
{
	public var speed:Speed;
	public var direction:Direction;
	public var acceleration:Acceleration;
	public var relative:Bool;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_SET;
	}
	
}