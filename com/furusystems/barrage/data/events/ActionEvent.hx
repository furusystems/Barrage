package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class ActionEvent extends EventDef
{
	public var actionID:Int = -1;
	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.ACTION;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		runningBarrage.runActionByID(actionID);
	}
	
}