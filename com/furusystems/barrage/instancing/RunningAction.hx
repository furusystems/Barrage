package com.furusystems.barrage.instancing;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.EventDef.EventType;
import com.furusystems.barrage.instancing.events.EventFactory;
import com.furusystems.barrage.instancing.events.ITriggerableEvent;
import com.furusystems.barrage.instancing.RunningBarrage;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RunningAction
{
	public var def:ActionDef;
	public var events:Vector<ITriggerableEvent>;
	public var sleepTime:Float;
	public var currentBullet:IBullet;
	public var triggeringBullet:IBullet;
	
	public var prevAngle:Float;
	public var prevSpeed:Float;
	public var prevAccel:Float;
	
	var runner:RunningBarrage;
	public var callingAction:RunningAction;
	public function new(runningBarrage:RunningBarrage, def:ActionDef) 
	{
		this.def = def;
		
		prevAngle = prevSpeed = prevAccel = sleepTime = 0;
		
		//#if debug
		//var repeatCount = def.events.length;
		//#else
		var repeatCount:Int = cast def.repeatCount.get(runningBarrage, this);
		repeatCount *= def.events.length;
		//#end
		events = new Vector<ITriggerableEvent>(repeatCount);
		var idx:Int = 0;
		for (i in 0...repeatCount) {
			events[i] = EventFactory.create(def.events[idx]);
			idx++;
			if (idx == def.events.length) idx = 0;
		}
	}
	
	public inline function reset():Void {
		for (i in 0...events.length) {
			events[i].hasRun = false;
		}
		currentBullet = null;
	}
	public inline function update(runningBarrage:RunningBarrage, delta:Float) {
		//trace("Update: " + delta);
		sleepTime -= delta;
		if (sleepTime <= 0) {
			var runEvents:Int = 0;
			for (i in 0...events.length) {
				var e = events[i];
				if (e.hasRun) {
					runEvents++;
					continue;
				}
				//trace(e.def.type);
				runEvent(runningBarrage, e);
				runEvents++;
				if (e.getType() == EventType.WAIT) {
					//trace("Breaking for wait");
					break;
				}
			}
			if (runEvents == events.length) {
				//trace("Ending action");
				runningBarrage.stopAction(this);
			}
		}
	}
	
	inline function runEvent(runningBarrage:RunningBarrage, e:ITriggerableEvent) 
	{
		e.hasRun = true;
		e.trigger(this, runningBarrage);
	}
	
	public inline function enter(callingAction:RunningAction, runner:RunningBarrage) 
	{
		reset();
		this.callingAction = callingAction;
		this.runner = runner;
	}
	public inline function exit(runner:RunningBarrage) {
		currentBullet = null;
	}
	
}