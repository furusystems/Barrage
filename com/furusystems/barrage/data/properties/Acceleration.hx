package com.furusystems.barrage.data.properties;

/**
 * ...
 * @author Andreas Rønning
 */
enum AccelerationType {
	ABSOLUTE;
	INCREMENTAL;
}
class Acceleration extends Property
{
	public var type:AccelerationType;
	public function new() 
	{
		type = ABSOLUTE;
		super();
	}
	public function toString():String {
		return "Acceleration";
	}
	
}