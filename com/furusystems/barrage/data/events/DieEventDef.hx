package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;

/**
 * ...
 * @author Andreas Rønning
 */
class DieEventDef extends EventDef
{

	public function new() 
	{
		super();
		type = EventType.DIE;
	}
	
}