package com.furusystems.barrage.instancing;
import com.furusystems.barrage.data.ActionDef;
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
	public var actionTime:Float;
	public function new(runningBarrage:RunningBarrage, def:ActionDef) 
	{
		this.def = def;
		var repeatCount:Int = def.repeatCount.get(runningBarrage.owner.executor);
		repeatCount *= def.events.length;
		events = new Vector<Event>(repeatCount);
		var idx:Int = 0;
		for (i in 0...repeatCount) {
			events[i] = new Event(def.events[idx]);
			idx++;
			if (idx == def.events.length) idx = 0;
		}
	}
	public inline function reset():Void {
		actionTime = 0;
		for (i in 0...events.length) {
			events[i].hasRun = false;
		}
	}
	public inline function update(runningBarrage:RunningBarrage, delta:Float) {
		actionTime += delta;
		var runEvents:Int = 0;
		for (i in 0...events.length) {
			var e = events[i];
			if (e.hasRun) {
				runEvents++;
				continue;
			}
			if (e.def.triggerTime <= actionTime) {
				runEvent(runningBarrage, e);
				runEvents++;
			}
		}
		if (runEvents == events.length) {
			runningBarrage.stopAction(this);
		}
	}
	
	inline function runEvent(runningBarrage:RunningBarrage, e:Event) 
	{
		e.hasRun = true;
		e.def.trigger(this, runningBarrage);
	}
	
	public inline function enter(runner:RunningBarrage) 
	{
		reset();
	}
	public inline function exit(runner:RunningBarrage) {
		
	}
	
}