package com.furusystems.barrage.data.events;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;

/**
 * ...
 * @author Andreas Rønning
 */
enum EventType {
	PROPERTY_SET;
	PROPERTY_TWEEN;
	FIRE;
	ACTION;
	DIE;
	WAIT;
}
class EventDef
{
	public var triggerTime:Float = 0;
	public var type:EventType;
	public function new(triggerTime:Float) 
	{
		this.triggerTime = triggerTime;
	}
	public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void {
		throw "Not implemented";
	}
	
}