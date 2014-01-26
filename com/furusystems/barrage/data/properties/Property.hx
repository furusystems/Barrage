package com.furusystems.barrage.data.properties;
import com.furusystems.barrage.data.properties.Property.PropertyModifier;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;

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
	public var name:String;
	public function new(name:String = "Property") 
	{
		this.name = name;
		modifier = ABSOLUTE;
	}
	
	public inline function copyFrom(other:Property):Void {
		this.isAimed = other.isAimed;
		this.isRandom = other.isRandom;
		this.constValue = other.constValue;
		this.script = other.script;
		this.scripted = other.scripted;
		this.name = other.name;
		this.modifier = other.modifier;
	}
	public inline function clone():Property {
		var n = new Property(name);
		n.copyFrom(this);
		return n;
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
	
	public function toString():String {
		return '[$name]';
	}
	
}