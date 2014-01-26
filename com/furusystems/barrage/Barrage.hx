package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.instancing.IBulletEmitter;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.parser.Parser;
import hscript.Interp;

/**
 * ...
 * @author Andreas Rønning
 */

@:allow(com.furusystems.barrage.parser.Parser)
class Barrage
{
	public var name:String;
	public var difficulty(get,set):Int;
	public var actions:Array<ActionDef>;
	public var start:ActionDef;
	public var bullets:Array<BulletDef>;
	public var defaultBullet:BulletDef;
	public var executor:Interp;
	public var frameRate:Int;
	public function new() {
		defaultBullet = new BulletDef("Default");
		defaultBullet.acceleration.set(0);
		defaultBullet.speed.set(50);
		frameRate = 60; //default
		executor = new Interp();
		executor.variables.set("math", Math);
		difficulty = 1;
		actions = [];
		bullets = [];
	}
	inline function set_difficulty(i:Int):Int {
		executor.variables.set("difficulty", i);
		return i;
	}
	inline function get_difficulty():Int {
		return executor.variables.get("difficulty");
	}
	public function toString():String {
		return 'Barrage($name)';
	}
	
	public inline function run(emitter:IBulletEmitter):RunningBarrage {
		return new RunningBarrage(emitter, this);
	}
	
	public static inline function fromString(str:String):Barrage {
		#if debug
		trace("Parsing " + str);
		#end
		return Parser.parse(str);
	}
	
}