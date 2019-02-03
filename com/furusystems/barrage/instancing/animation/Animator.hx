package com.furusystems.barrage.instancing.animation;

import com.furusystems.barrage.instancing.IBarrageBullet;

/**
 * ...
 * @author Andreas Rønning
 */
class Animator {
	public var target:IBarrageBullet;

	var angle:AnimatedProperty;
	var speed:AnimatedProperty;
	var acceleration:AnimatedProperty;

	public function new(target:IBarrageBullet) {
		this.target = target;
		angle = speed = acceleration = null;
	}

	inline public function update(delta:Float):Bool {
		if (target.active == false) {
			return false;
		} else {
			var persist = false;
			if (angle != null) {
				persist = true;
				target.angle = angle.update(delta);
			}
			if (speed != null) {
				persist = true;
				target.speed = speed.update(delta);
			}
			if (acceleration != null) {
				persist = true;
				target.acceleration = acceleration.update(delta);
			}
			return persist;
		}
	}

	inline public function getAngle():AnimatedProperty {
		if (angle == null)
			angle = new AnimatedProperty();
		return angle;
	}

	inline public function getSpeed():AnimatedProperty {
		if (speed == null)
			speed = new AnimatedProperty();
		return speed;
	}

	inline public function getAcceleration():AnimatedProperty {
		if (acceleration == null)
			acceleration = new AnimatedProperty();
		return acceleration;
	}
}

private class AnimatedProperty {
	public var start:Float;
	public var value:Float;
	public var target:Float;
	public var duration:Float;
	public var time:Float;

	var diff:Float;
	var dR:Float;

	inline public function new() {
		time = 0;
	}

	inline public function update(delta:Float):Float {
		time += delta;
		if (time >= duration) {
			return finish();
		} else {
			return value = diff * (time * dR) + start;
		}
	}

	inline public function finish():Float {
		time = duration;
		value = target;
		return target;
	}

	inline public function retarget(start:Float, target:Float, duration:Float, initDelta:Float = 0) {
		time = 0;
		this.start = value = start;
		this.target = target;
		this.duration = duration;
		dR = 1 / duration;
		diff = target - start;
		if (initDelta != 0)
			update(initDelta);
	}
}
