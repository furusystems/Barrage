package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.Action;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.Orientation;
import com.furusystems.barrage.data.Token;
import com.furusystems.barrage.data.TokenType;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

class Barrage
{
	public var name:String;
	public var orientation:Orientation;
	public var actions:Vector<Action>;
	public var bullets:Vector<BulletDef>;
	public function new() {
		
	}
	public function toString():String {
		return 'Barrage($name,$orientation)';
	}
	
}