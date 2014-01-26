package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;

/**
 * ...
 * @author Andreas Rønning
 */
class ActionEventDef extends EventDef
{
	public var actionID:Int = -1;
	public function new() 
	{
		super();
		type = EventType.ACTION;
	}
	
}