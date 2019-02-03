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
class RunningAction {
	public var def:ActionDef;
	public var events:Array<ITriggerableEvent>;
	public var sleepTime:Float;
	public var currentBullet:IBarrageBullet;
	public var triggeringBullet:IBarrageBullet;
	public var prevAngle:Float;
	public var prevSpeed:Float;
	public var prevAccel:Float;
	public var prevPositionX:Float;
	public var prevPositionY:Float;
	public var actionTime:Float;
	public var prevDelta:Float;

	var barrage:RunningBarrage;
	var repeatCount:Int;
	var endless:Bool;
	var repeatNo:Int;
	var cycleCount:Int;
	var eventsPerCycle:Int;
	var runEvents:Int;
	var currentEventIndex:Int;

	public var callingAction:RunningAction;
	public var properties:Array<Property>;

	public function new(runningBarrage:RunningBarrage, def:ActionDef) {
		this.def = def;

		prevAngle = prevSpeed = prevAccel = sleepTime = prevDelta = prevPositionX = prevPositionY = 0;

		properties = [];
		for (p in def.properties) {
			properties.push(p.clone());
		}

		// #if debug
		// var repeatCount = def.events.length;
		// #else
		repeatCount = cast def.repeatCount.get(runningBarrage, this);
		endless = def.endless;
		// #end
		events = new Array<ITriggerableEvent>();
		var idx:Int = 0;
		for (i in 0...def.events.length) {
			events.push(EventFactory.create(def.events[i]));
		}
		eventsPerCycle = events.length;
		runEvents = 0;
		cycleCount = 1;
	}

	function repeat(runningBarrage:RunningBarrage){
		if(!endless && cycleCount > repeatCount){
			runningBarrage.stopAction(this);
			return;
		}
		runEvents = 0;
		cycleCount++;
	}

	public function update(runningBarrage:RunningBarrage, delta:Float) {
		if (events.length == 0) {
			runningBarrage.stopAction(this);
		} else {
			actionTime += delta;
			sleepTime -= delta;
			if (sleepTime <= 0) {
				// delta += Math.abs(sleepTime);
				runningBarrage.owner.executor.variables.set("actiontime", actionTime);
				while (runEvents < eventsPerCycle) {
					var e = events[runEvents++];
					runEvent(runningBarrage, e, delta);
					if (e.getType() == EventType.WAIT) {
						break;
					}
				}
				if(runEvents == eventsPerCycle){
					repeat(runningBarrage);
				}
			}
		}
	}

	inline function runEvent(runningBarrage:RunningBarrage, e:ITriggerableEvent, delta:Float) {
		e.hasRun = true;
		runningBarrage.owner.executor.variables.set("repeatcount", repeatNo);
		e.trigger(this, runningBarrage, delta);
	}

	public function getProperty(name:String):Property {
		for (p in properties) {
			if (p.name == name)
				return p;
		}
		if (callingAction != null) {
			return callingAction.getProperty(name);
		}
		return null;
	}

	function pollProp(name:String):Float {
		return getProperty(name).get(barrage, this);
	}

	public inline function enter(callingAction:RunningAction, barrage:RunningBarrage, ?overrides:Array<Property>) {
		actionTime = 0;
		if (overrides != null) {
			for (o in overrides) {
				for (p in properties) {
					if (p.name == o.name) {
						p.copyFrom(o);
						// trace("Override: " + p.get(barrage,this));
					}
				}
			}
		}
		for (p in properties) {
			barrage.owner.executor.variables.set(p.name, p.get(barrage, callingAction));
		}
		this.callingAction = callingAction;
		this.barrage = barrage;
	}

	public inline function exit(barrage:RunningBarrage) {
		currentBullet = null;
	}
}
