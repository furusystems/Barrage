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
	public function new() 
	{
		super();
		type = EventType.WAIT;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		var sleepTimeNum:Float;
		if (scripted) {
			sleepTimeNum = runningBarrage.owner.executor.execute(waitTimeScript);
		}else {
			sleepTimeNum = waitTime;
		}
		switch(durationType) {
			case SECONDS:
				runningAction.sleepTime = sleepTimeNum;
			case FRAMES:
				runningAction.sleepTime = (sleepTimeNum * 1 / runningBarrage.owner.frameRate);
		}
		#if debug
		trace("Wait " + sleepTimeNum + " " + durationType + " = " + runningAction.sleepTime + " seconds");
		#end
	}
	
}