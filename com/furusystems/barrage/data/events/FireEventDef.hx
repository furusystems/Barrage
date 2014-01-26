package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;

/**
 * ...
 * @author Andreas Rønning
 */
class FireEventDef extends EventDef
{
	public var bulletID:Int = -1;
	public var speed:Speed;
	public var acceleration:Acceleration;
	public var direction:Direction;
	public function new() 
	{
		super();
		type = EventType.FIRE;
	}
	
}