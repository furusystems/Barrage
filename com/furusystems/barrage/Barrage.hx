package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.instancing.RunningBarrage;
import haxe.ds.Vector;
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
	public var executor:Interp;
	public function new() {
		executor = new Interp();
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
	
	public inline function run():RunningBarrage {
		return new RunningBarrage(this);
	}
	
}