package com.furusystems.barrage.instancing;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.events.EventDef;
import com.furusystems.barrage.data.events.EventDef.EventType;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RunningBarrage
{
	public var owner:Barrage;
	public var initAction:RunningAction;
	public var allActions:Vector<RunningAction>;
	public var activeActions:Array<RunningAction>;
	public var time:Float = 0;
	var started:Bool;
	var lastDelta:Float = 0;
	public function new(owner:Barrage) 
	{
		this.owner = owner;
		activeActions = [];
		allActions = new Vector<RunningAction>(owner.actions.length);
		for (i in 0...owner.actions.length) {
			allActions[i] = new RunningAction(this, owner.actions[i]);
			if (owner.actions[i] == owner.start) {
				initAction = allActions[i];
			}
		}
	}
	public function start():Void {
		runAction(initAction);
		started = true;
	}
	public function stop():Void {
		while (activeActions.length > 0) {
			stopAction(activeActions[0]);
		}
		started = false;
	}
	public function update(delta:Float) {
		if (!started) return;
		time += delta;
		lastDelta = delta;
		for (a in activeActions) {
			a.update(this, time);
		}
	}
	public inline function runActionByID(id:Int) {
		runAction(allActions[id]);
	}
	
	public inline function runAction(action:RunningAction) 
	{
		//trace("Start action: "+action.def.name);
		activeActions.push(action);
		action.enter(this);
		action.update(this, lastDelta);
	}
	public inline function stopAction(action:RunningAction) {
		action.exit(this);
		activeActions.remove(action);
		//trace("Stop action: "+action.def.name);
	}
	
}