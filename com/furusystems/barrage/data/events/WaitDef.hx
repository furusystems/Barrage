package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.properties.DurationType;
import hscript.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class WaitDef extends EventDef
{
	public var waitTime:Float;
	public var waitTimeScript:Expr;
	public var scripted:Bool = false;
	public var durationType:DurationType;
	public function new() 
	{
		super();
		type = EventType.WAIT;
	}
	
}