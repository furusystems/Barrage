package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.RunningAction;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

@:allow(com.furusystems.barrage.parser.Parser)
class Barrage
{
	var actions:Vector<ActionDef>;
	var bullets:Vector<BulletDef>;
	public var name:String;
	public function new() {
	}
	public function toString():String {
		return 'Barrage($name)';
	}
	public inline function getAction(def:ActionDef):RunningAction {
		return new RunningAction(def);
	}
	public inline function getBulletDef(id:Int):BulletDef {
		return bullets[id];
	}
	public inline function getActionDef(id:Int):ActionDef {
		return actions[id];
	}
	
}