package com.furusystems.barrage.data.events;
import com.furusystems.barrage.data.EventDef.EventType;
import com.furusystems.barrage.data.properties.DurationType;
import hscript.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertyTweenDef extends PropertySetDef
{
	public var tweenTime:Float;
	public var tweenTimeScript:Expr;
	public var scripted:Bool = false;
	public var durationType:DurationType;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_TWEEN;
	}
	
}