package com.furusystems.barrage.parser;
import com.furusystems.barrage.parser.Direction.DirectionType;

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
	public var type:DirectionType;
	public function new() 
	{
		
	}
	
}