package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Property;

/**
 * ...
 * @author Andreas Rønning
 */
class FireBeamEventDef extends EventDef
{
	public var bulletID:Int = -1;
	public var direction:Property;
	public var position:Property;
	public var length:Property;
	public var width:Property;
	public var damage:Property;
	public function new() 
	{
		super();
		type = EventType.FIRE_BEAM;
	}
	
}