package com.furusystems.barrage.data;
import hscript.Parser;

/**
 * ...
 * @author Andreas Rønning
 */
class Token
{
	public var type:TokenType;
	public var data:Dynamic;
	public function new(type:TokenType, data:String) 
	{
		this.type = type;
		switch(type) {
			case TokenType.number_token:
				this.data = Std.parseFloat(data);
			case TokenType.const_math_token, TokenType.script_token:
				var parser:Parser = new Parser();
				this.data = parser.parseString(data);
			default:
				this.data = data;
		}
	}
	public function toString():String {
		return '$type = $data';
	}
	
}