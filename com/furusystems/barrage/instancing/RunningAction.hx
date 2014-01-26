package com.furusystems.barrage.instancing;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.instancing.Event;
import com.furusystems.barrage.instancing.RunningBarrage;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RunningAction
{
	public var def:ActionDef;
	public var events:Vector<Event>;
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
		
		prevAngle = prevSpeed = prevAccel = 0;
		
		//#if debug
		//var repeatCount = def.events.length;
		//#else
		var repeatCount:Int = cast def.repeatCount.get(runningBarrage, this);
		repeatCount *= def.events.length;
		//#end
		events = new Vector<Event>(repeatCount);
		var idx:Int = 0;
		for (i in 0...repeatCount) {
			events[i] = new Event(def.events[idx]);
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
	public function update(runningBarrage:RunningBarrage, delta:Float) {
		//trace("Update: " + delta);
		sleepTime -= delta;
		if (sleepTime > 0) {
			return;
		}
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
			if (e.def.type == EventType.WAIT) {
				//trace("Breaking for wait");
				return;
			}
		}
		if (runEvents == events.length) {
			//trace("Ending action");
			runningBarrage.stopAction(this);
		}
	}
	
	inline function runEvent(runningBarrage:RunningBarrage, e:Event) 
	{
		e.hasRun = true;
		e.def.trigger(this, runningBarrage);
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