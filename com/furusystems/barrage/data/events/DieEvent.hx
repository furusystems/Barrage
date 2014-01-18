package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class DieEvent extends EventDef
{

	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.DIE;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		trace("Die");
	}
	
}