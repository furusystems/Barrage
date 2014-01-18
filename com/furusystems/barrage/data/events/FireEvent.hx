package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.instancing.RunningAction;

/**
 * ...
 * @author Andreas Rønning
 */
class FireEvent extends EventDef
{
	public var bulletID:Int = -1;
	public var speed:Speed;
	public var acceleration:Acceleration;
	public var direction:Direction;
	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.FIRE;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		if (bulletID != -1) {
			var bd = runningBarrage.owner.bullets[bulletID];
			trace("Fire " + bd.name);
			if (bd.action != -1) {
				runningBarrage.runActionByID(bd.action);
			}
		}else {
			trace("Fire anonymous bullet");
		}
	}
	
}