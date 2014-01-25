package com.furusystems.barrage.parser;

/**
 * ...
 * @author Andreas Rønning
 */
class ParseError
{
	public var lineNo:Int = -1;
	public var info:String;
	public function new(lineNo:Int, info:String) 
	{
		this.lineNo = lineNo;
		this.info = info;
	}
	public function toString():String {
		return info;
	}
	
}