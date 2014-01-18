package com.furusystems.barrage.data;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.Speed;
/**
 * ...
 * @author Andreas Rønning
 */
class BulletDef extends BarrageItemDef
{
	public var speed:Speed;
	public var direction:Direction;
	public var acceleration:Acceleration;
	public var action:Int = -1; //pointers to predefined actions
	public function new(name:String) 
	{
		super(name);
		speed = new Speed();
		direction = new Direction();
		acceleration = new Acceleration();
	}
	
}