package com.furusystems.barrage.data.properties;

/**
 * ...
 * @author Andreas Rønning
 */
enum SpeedType {
	ABSOLUTE;
	INCREMENTAL;
	RELATIVE;
}
class Speed extends Property
{
	public var type:SpeedType;
	public function new() 
	{
		type = ABSOLUTE;
		super();
	}
	
	public function toString():String {
		return "Speed";
	}
	
}