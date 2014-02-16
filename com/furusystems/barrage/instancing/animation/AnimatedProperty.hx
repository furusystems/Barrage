package com.furusystems.barrage.instancing.animation;
import com.furusystems.barrage.data.properties.Property.PropertyType;
class AnimatedProperty {
	public var start:Float;
	public var value:Float;
	public var target:Float;
	public var duration:Float;
	public var time:Float;
	var diff:Float;
	var dR:Float;
	public var type:PropertyType;
	inline public function new(type:PropertyType) {
		this.type = type;
		time = 0;
	}
	inline public function update(delta:Float):Float {
		time += delta;
		if (time >= duration) {
			return finish();
		}else {
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
		if (initDelta != 0) update(initDelta);
	}
}