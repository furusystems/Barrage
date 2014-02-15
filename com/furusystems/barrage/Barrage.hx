package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BeamDef;
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
	public var beams:Array<BeamDef>;
	public var defaultBullet:BulletDef;
	public var defaultBeam:BeamDef;
	public var executor:Interp;
	public var frameRate:Int;
	public function new() {
		defaultBullet = new BulletDef("Default");
		defaultBullet.acceleration.set(0);
		defaultBullet.speed.set(50);
		defaultBeam = new BeamDef("Default");
		frameRate = 60; //default
		executor = new Interp();
		executor.variables.set("math", Math);
		executor.variables.set("triangle", tri);
		executor.variables.set("square", sqr);
		difficulty = 1;
		actions = [];
		bullets = [];
		beams = [];
	}
	
	function tri(x:Float, a:Float = 0.5):Float
	{
		x = x / (2.0*Math.PI);
		x = x % 1.0;
		if( x<0.0 ) x = 1.0+x;
		if(x<a) x=x/a; else x=1.0-(x-a)/(1.0-a);
		return -1.0+2.0*x;
	}
	function sqr(x:Float, a:Float = 0.5):Float
	{
		if( Math.sin(x)>a ) x=1.0; else x=-1.0;
		return x;
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