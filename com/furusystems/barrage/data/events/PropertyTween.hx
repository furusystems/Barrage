package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.instancing.RunningAction;
import haxe.macro.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertyTween extends PropertySet
{
	public var tweenTime:Float;
	public var tweenTimeScript:Expr;
	public var scripted:Bool = false;
	public var durationType:DurationType;
	public function new(triggerTime:Float) 
	{
		super(triggerTime);
		type = EventType.PROPERTY_TWEEN;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		trace("Property tween");
	}
	
}