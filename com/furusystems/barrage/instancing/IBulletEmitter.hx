package com.furusystems.barrage.instancing;
import com.furusystems.flywheel.geom.Vector2D;
/**
 * ...
 * @author Andreas Rønning
 */
interface IBulletEmitter extends IOrigin
{
	function emit(origin:Vector2D, angleRad:Float, speed:Float, acceleration:Float):IBullet;
	function getAngleToEmitter(pos:Vector2D):Float;
	function getAngleToPlayer(pos:Vector2D):Float;
	function kill(bullet:IBullet):Void;
}