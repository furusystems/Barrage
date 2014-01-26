package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Property;

/**
 * ...
 * @author Andreas Rønning
 */
class FireEventDef extends EventDef
{
	public var bulletID:Int = -1;
	public var speed:Property;
	public var acceleration:Property;
	public var direction:Property;
	public function new() 
	{
		super();
		type = EventType.FIRE;
	}
	
}