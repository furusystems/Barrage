package com.furusystems.barrage.data.properties;
import com.furusystems.barrage.data.properties.Property.PropertyModifier;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.flywheel.math.MathUtils;
import hscript.Interp;

/**
 * ...
 * @author Andreas Rønning
 */
enum PropertyModifier {
	ABSOLUTE;
	INCREMENTAL;
	RELATIVE;
	AIMED;
	RANDOM;
}
class Property
{
	public var modifier:PropertyModifier;
	public var isAimed:Bool;
	public var isRandom:Bool;
	public var constValue:Float = 0;
	public var script:Null<hscript.Expr>;
	public var scripted:Bool = false;
	public function new() 
	{
		modifier = ABSOLUTE;
	}
	
	public inline function get(runningBarrage:RunningBarrage, action:RunningAction):Float 
	{
		var value:Float = 0;
		if (scripted) value = runningBarrage.owner.executor.execute(script);
		else value = constValue;
		return value;
	}
	
	public inline function set(f:Float):Float
	{
		scripted = false;
		return constValue = f;
	}
	
}