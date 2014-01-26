package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.ActionEventDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class ActionEvent implements ITriggerableEvent
{
	public var def:ActionEventDef;
	public var hasRun:Bool;
	public function new(def:EventDef) 
	{
		this.def = cast def;
	}
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		runningBarrage.runActionByID(runningAction, def.actionID);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}