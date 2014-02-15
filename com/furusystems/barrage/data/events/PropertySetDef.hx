package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Property;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertySetDef extends EventDef
{
	public var speed:Property;
	public var direction:Property;
	public var acceleration:Property;
	public var position:Property;
	public var length:Property;
	public var width:Property;
	public var damage:Property;
	
	public var relative:Bool;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_SET;
	}
	
}