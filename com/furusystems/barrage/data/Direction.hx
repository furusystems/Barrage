package com.furusystems.barrage.parser;

/**
 * ...
 * @author Andreas Rønning
 */
enum DirectionType {
	ABSOLUTE;
	SEQUENTIAL;
	RELATIVE;
	AIMED;
}
class Direction
{
	public var type:DirectionType
	public var constValue:Float = 0;
	public var script:Null<hscript.Expr>;
	public function new() 
	{
		
	}
	
}