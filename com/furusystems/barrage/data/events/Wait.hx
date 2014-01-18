package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.instancing.RunningAction;
import hscript.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class Wait extends EventDef
{
	public var waitTime:Float;
	public var waitTimeScript:Expr;
	public var scripted:Bool = false;
	public var durationType:DurationType;
	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.WAIT;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		trace("Wait");
	}
	
}