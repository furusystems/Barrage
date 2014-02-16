package com.furusystems.barrage.instancing;
import com.furusystems.flywheel.geom.Vector2D;
/**
 * ...
 * @author Andreas Rønning
 */
interface IBullet extends IOrigin
{
	var acceleration:Float;
	var velocity:Vector2D;
	var angle:Float;
	var speed:Float;
	var active:Bool;
	var id:Int;	
}