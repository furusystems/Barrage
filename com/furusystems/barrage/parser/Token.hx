package com.furusystems.barrage.parser;
import hscript.Parser;

/**
 * ...
 * @author Andreas Rønning
 */
enum Token
{
	
	TBarrage;
	TVanish;
	TOver;
	TSet;
	TBullet;
	TAction;
	TFire;
	TDo;
	TAt;
	TIn;
	TSpeed;
	TDirection;
	TAcceleration;
	TWait;
	TRepeat;
	
	TSequential;
	TAbsolute;
	TAimed;
	TRelative;
	
	THorizontal;
	TVertical;
	
	TFrames;
	TSeconds;
	TStart;
	
	TIdentifier;
	TScript;
	TConst_math;
	TNumber;
	
	//ignored tokens
	TIgnored;
	//called;
	//then;
	//is;
	//to;
	//times;
	
}
//class Token
//{
	//public var type:TokenType;
	//public var data:Dynamic;
	//public function new(type:TokenType, data:String) 
	//{
		//this.type = type;
		//switch(type) {
			//case TokenType.TNumber:
				//this.data = Std.parseFloat(data);
			//case TokenType.TConst_math, TokenType.TScript:
				//var parser:Parser = new Parser();
				//this.data = parser.parseString(data);
			//default:
				//this.data = data;
		//}
	//}
	//public function toString():String {
		//return '$type = $data';
	//}
	//
//}