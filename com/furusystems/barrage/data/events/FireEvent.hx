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
	public function new() 
	{
		super();
		type = EventType.FIRE;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		runningAction.currentBullet = runningBarrage.fire(runningAction, this, bulletID);
		if (bulletID != -1) {
			var bd = runningBarrage.owner.bullets[bulletID];
			if (bd.action != -1) {
				var action = runningBarrage.runActionByID(runningAction, bd.action, runningAction.currentBullet);
			}
		}
	}
	
}