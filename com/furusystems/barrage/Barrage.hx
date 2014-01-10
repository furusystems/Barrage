package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.Orientation;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

class Barrage
{
	public var name:String;
	public var orientation:Orientation;
	public function new() {
		
	}
	public function toString():String {
		return 'Barrage($name, $orientation)';
	}
	
}