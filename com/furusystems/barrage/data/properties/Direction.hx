package com.furusystems.barrage.data.properties;

/**
 * ...
 * @author Andreas Rønning
 */
enum DirectionType {
	ABSOLUTE;
	INCREMENTAL;
	RELATIVE;
	AIMED;
}
class Direction extends Property
{
	public var type:DirectionType;
	public function new() 
	{
		type = ABSOLUTE;
		super();
	}
	
	public function toString():String {
		return "Direction";
	}
	
}