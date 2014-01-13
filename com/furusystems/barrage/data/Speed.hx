package com.furusystems.barrage.parser;

/**
 * ...
 * @author Andreas Rønning
 */
enum SpeedType {
	ABSOLUTE;
	SEQUENTIAL;
	RELATIVE;
}
class Speed
{
	public var type:SpeedType;
	public var constValue:Float = 0;
	public var script:Null<hscript.Expr>;
	public function new() 
	{
		
	}
	
}