package com.furusystems.barrage.instancing;
import com.furusystems.flywheel.geom.Vector2D;
/**
 * ...
 * @author Andreas Rønning
 */
interface IBeam extends IOrigin
{
	var length:Float;
	var width:Float;
	var damage:Float;
	var angle:Float;
	var active:Bool;
	var id:Int;	
}