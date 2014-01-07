package com.furusystems.barrage.data;

/**
 * ...
 * @author Andreas Rønning
 */
class Action extends BarrageEvent
{

	public var id:String;
	public var events:Array<BarrageEvent>;
	public function new() 
	{
		events = [];
		super();
	}
	
}