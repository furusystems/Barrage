package com.furusystems.barrage.data;
import com.furusystems.barrage.data.ActionDef;
/**
 * ...
 * @author Andreas Rønning
 */
class RunningAction
{
	public var def:ActionDef;
	public function new(def:ActionDef) 
	{
		init(def);
	}
	
	public inline function init(def:ActionDef) 
	{
		this.def = def;
	}
	
}