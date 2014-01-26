package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.EventDef.EventType;
/**
 * ...
 * @author Andreas Rønning
 */
interface ITriggerableEvent
{
	public var hasRun:Bool;
	public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void;
	public function getType():EventType;
}