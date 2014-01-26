package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.WaitDef;
import com.furusystems.barrage.data.properties.DurationType;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.instancing.RunningAction;
import hscript.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class Wait implements ITriggerableEvent
{
	public var hasRun:Bool;
	public var def:WaitDef;
	public function new(def:EventDef ) 
	{
		this.def = cast def;
	}
	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		var sleepTimeNum:Float;
		if (def.scripted) {
			sleepTimeNum = runningBarrage.owner.executor.execute(def.waitTimeScript);
		}else {
			sleepTimeNum = def.waitTime;
		}
		switch(def.durationType) {
			case SECONDS:
				runningAction.sleepTime = sleepTimeNum;
			case FRAMES:
				runningAction.sleepTime = (sleepTimeNum * 1 / runningBarrage.owner.frameRate);
		}
		#if debug
		trace("Wait " + sleepTimeNum + " " + def.durationType + " = " + runningAction.sleepTime + " seconds");
		#end
	}
	public inline function getType():EventType {
		return def.type;
	}
	
}