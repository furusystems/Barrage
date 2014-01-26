package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.DieEventDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class DieEvent implements ITriggerableEvent
{
	public var def:DieEventDef;
	public var hasRun:Bool;
	public function new(def:EventDef) 
	{
		this.def = cast def;
	}
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		#if debug
		trace("Die");
		#end
		runningBarrage.emitter.kill(runningAction.triggeringBullet);
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}