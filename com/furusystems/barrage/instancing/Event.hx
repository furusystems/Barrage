package com.furusystems.barrage.instancing;
import com.furusystems.barrage.data.events.EventDef;

/**
 * ...
 * @author Andreas Rønning
 */
class Event
{
	public var def:EventDef;
	public var hasRun:Bool;
	public function new(def:EventDef) 
	{
		this.def = def;
		
	}
	
}