package com.furusystems.barrage.instancing.animation;
import com.furusystems.barrage.data.properties.Property.PropertyType;
import com.furusystems.barrage.instancing.animation.Animator;
import com.furusystems.barrage.instancing.IBullet;

/**
 * ...
 * @author Andreas Rønning
 */
class Animator
{
	public var target:IBullet;
	public var properties:Array<AnimatedProperty>;
	public function new(target:IBullet) 
	{
		this.target = target;
		properties = [];
	}
	inline public function update(delta:Float):Bool {
		if (target.active == false) {
			return false;
		}else{
			var persist = false;
			for (p in properties) {
				persist = true;
				updateProperty(p);
			}
			return persist;
		}
	}
	
	inline function updateProperty(prop:AnimatedProperty) 
	{
		switch(prop.
	}
	inline public function getProp(prop:PropertyType):AnimatedProperty {
		var idx:Int = prop.getIndex();
		if (properties.length >= idx) {
			return properties[idx];
		}else {
			return properties[idx] = new AnimatedProperty(prop);
		}
	}
	
}