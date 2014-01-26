package com.furusystems.barrage.instancing;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.EventDef.EventType;
import com.furusystems.barrage.data.properties.Property;
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
	
	public var actionTime:Float;
	
	var barrage:RunningBarrage;
	var repeatCount:Int;
	var repeatNo:Int;
	var eventsPerCycle:Int;
	public var callingAction:RunningAction;
	
	public var props:Map<String,Property>;
	
	public function new(runningBarrage:RunningBarrage, def:ActionDef) 
	{
		this.def = def;
		
		prevAngle = prevSpeed = prevAccel = sleepTime = 0;
		
		//#if debug
		//var repeatCount = def.events.length;
		//#else
		repeatCount = cast def.repeatCount.get(runningBarrage, this);
		eventsPerCycle = def.events.length;
		var numEvents = repeatCount * def.events.length;
		//#end
		events = new Vector<ITriggerableEvent>(numEvents);
		var idx:Int = 0;
		for (i in 0...numEvents) {
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
		actionTime += delta;
		if (sleepTime <= 0) {
			runningBarrage.owner.executor.variables.set("actiontime", actionTime);
			var runEvents:Int = 0;
			repeatNo = 0;
			for (i in 0...events.length) {
				var e = events[i];
				if (e.hasRun) {
					runEvents++;
					continue;
				}
				repeatNo = Math.floor(runEvents / eventsPerCycle);
				runEvent(runningBarrage, e);
				runEvents++;
				if (e.getType() == EventType.WAIT) {
					break;
				}
			}
			if (runEvents == events.length) {
				runningBarrage.stopAction(this);
			}
		}
	}
	
	inline function runEvent(runningBarrage:RunningBarrage, e:ITriggerableEvent) 
	{
		e.hasRun = true;
		runningBarrage.owner.executor.variables.set("repeatcount", repeatNo);
		e.trigger(this, runningBarrage);
	}
	
	public inline function getProperty(name:String):Property {
		var prop = props.get(name);
		if (prop == null) {
			prop = new Property();
			props.set(name, prop);
		}
		return prop;
	}
	
	
	public inline function enter(callingAction:RunningAction, barrage:RunningBarrage) 
	{
		reset();
		actionTime = 0;
		this.callingAction = callingAction;
		if (callingAction != null) {
			props = callingAction.props;
		}else {
			props = new Map<String,Property>();
		}
		this.barrage = barrage;
	}
	public inline function exit(barrage:RunningBarrage) {
		currentBullet = null;
		props = null;
	}
	
}