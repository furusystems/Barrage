package com.furusystems.barrage.data;
import com.furusystems.barrage.data.properties.Property;
/**
 * ...
 * @author Andreas Rønning
 */
class BeamDef extends BarrageItemDef
{
	public var width:Property;
	public var length:Property;
	public var direction:Property;
	public var damage:Property;
	public var action:Int = -1; //pointers to predefined actions
	public function new(name:String) 
	{
		super(name);
		width = new Property("Width");
		length = new Property("Length");
		direction = new Property("Direction");
		damage = new Property("Damage");
	}
	
}