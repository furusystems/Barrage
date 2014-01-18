package com.furusystems.barrage.data;
import com.furusystems.barrage.data.events.EventDef;
import com.furusystems.barrage.data.properties.Property;
/**
 * ...
 * @author Andreas Rønning
 */
class ActionDef extends BarrageItemDef
{
	public var events:Array<EventDef>;
	public var repeatCount:Property;
	public function new(name:String = "") 
	{
		repeatCount = new Property();
		repeatCount.constValue = 1;
		events = [];
		super(name);
	}
	
}