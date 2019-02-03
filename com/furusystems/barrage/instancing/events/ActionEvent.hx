package com.furusystems.barrage.instancing.events;

import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.ActionEventDef;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;

/**
 * ...
 * @author Andreas Rønning
 */
class ActionEvent implements ITriggerableEvent {
	public var def:ActionEventDef;
	public var hasRun:Bool;

	public function new(def:EventDef) {
		this.def = cast def;
	}

	public inline function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage, delta:Float):Void {
		runningBarrage.runActionByID(runningAction, def.actionID, runningAction.triggeringBullet, null, delta);
	}

	public inline function getType():EventType {
		return def.type;
	}
}
