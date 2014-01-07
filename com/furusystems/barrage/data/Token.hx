package com.furusystems.barrage.data;

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
			case TokenType.float_token:
				this.data = Std.parseFloat(data);
			case TokenType.const_math_token, TokenType.const_math_token:
				this.data = data;
			default:
				this.data = data;
		}
	}
	public function toString():String {
		return '$type = $data';
	}
	
}