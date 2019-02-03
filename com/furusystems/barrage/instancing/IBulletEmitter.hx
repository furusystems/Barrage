package com.furusystems.barrage.instancing;

import glm.Vec2;

/**
 * ...
 * @author Andreas Rønning
 */
interface IBulletEmitter extends IOrigin {
	function emit(x:Float, y:Float, angleRad:Float, speed:Float, acceleration:Float, delta:Float):IBarrageBullet;
	function getAngleToEmitter(posX:Float, posY:Float):Float;
	function getAngleToPlayer(posX:Float, posY:Float):Float;
	function kill(bullet:IBarrageBullet):Void;
}
