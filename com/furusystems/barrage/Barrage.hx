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
	static var cache = new Map<String,Barrage>();
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
		executor.variables.set("triangle", tri);
		executor.variables.set("square", sqr);
		difficulty = 1;
		actions = [];
		bullets = [];
	}
	
	inline function tri(x:Float, a:Float = 0.5):Float
	{
		x = x / (2.0*Math.PI);
		x = x % 1.0;
		if( x<0.0 ) x = 1.0+x;
		if(x<a) x=x/a; else x=1.0-(x-a)/(1.0-a);
		return -1.0+2.0*x;
	}
	inline function sqr(x:Float, a:Float = 0.5):Float
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
	
	public inline function run(emitter:IBulletEmitter, speedScale:Float = 1.0, accelScale:Float = 1.0):RunningBarrage {
		trace("Creating barrage runner");
		return new RunningBarrage(emitter, this, speedScale,accelScale);
	}
	
	public static function clearCache():Void {
		cache = new Map<String, Barrage>();
	}
	
	public static inline function fromString(str:String, useCache:Bool = true):Barrage {
		trace("Creating barrage from string");
		if (useCache) {
			if (cache.exists(str)) return cache.get(str);
			else {
				var b = Parser.parse(str);
				cache[str] = b;
				return b;
			}
		}else {
			return Parser.parse(str);
		}
	}
	
}