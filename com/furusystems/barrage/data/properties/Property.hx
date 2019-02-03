package com.furusystems.barrage.data.properties;

import com.furusystems.barrage.data.properties.Property.PropertyModifier;
import com.furusystems.barrage.instancing.RunningAction;
import com.furusystems.barrage.instancing.RunningBarrage;
import haxe.ds.Vector;
import haxe.EnumFlags;

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

class Property {
	public var modifier:EnumFlags<PropertyModifier>;
	public var isRandom:Bool;
	public var constValue:Float = 0;
	public var constValueVec:Vector<Float>;
	public var script:Null<hscript.Expr>;
	public var scripted:Bool = false;
	public var name:String;

	public function new(name:String = "Property") {
		this.name = name;
		modifier = new EnumFlags<PropertyModifier>();
		modifier.set(ABSOLUTE);
		constValueVec = new Vector<Float>(2);
		constValueVec[0] = constValueVec[1] = 0;
	}

	public inline function copyFrom(other:Property):Void {
		this.isRandom = other.isRandom;
		this.constValue = other.constValue;
		Vector.blit(other.constValueVec, 0, constValueVec, 0, constValueVec.length);
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

	public inline function get(runningBarrage:RunningBarrage, action:RunningAction):Float {
		if (scripted) {
			return runningBarrage.owner.executor.execute(script);
		} else {
			// trace("Value: " + constValue);
			return constValue;
		}
	}

	public inline function getVector(runningBarrage:RunningBarrage, action:RunningAction):Vector<Float> {
		if (scripted) {
			return runningBarrage.owner.executor.execute(script);
		} else {
			return constValueVec;
		}
	}

	public inline function set(f:Float):Float {
		scripted = false;
		return constValue = f;
	}

	public inline function setVec(x:Float, y:Float):Vector<Float> {
		scripted = false;
		constValueVec.set(0, x);
		constValueVec.set(1, y);
		return constValueVec;
	}

	public function toString():String {
		return '[$name]';
	}
}
