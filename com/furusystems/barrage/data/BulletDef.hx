package com.furusystems.barrage.data;

import com.furusystems.barrage.data.properties.Property;

/**
 * ...
 * @author Andreas Rønning
 */
class BulletDef extends BarrageItemDef {
	public var speed:Property;
	public var direction:Property;
	public var acceleration:Property;
	public var action:Int = -1; // pointers to predefined actions

	public function new(name:String) {
		super(name);
		speed = new Property("Speed");
		direction = new Property("Direction");
		acceleration = new Property("Acceleration");
	}
}
