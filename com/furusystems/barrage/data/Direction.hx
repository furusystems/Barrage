package com.furusystems.barrage.data;
import com.furusystems.barrage.data.Direction.DirectionType;

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