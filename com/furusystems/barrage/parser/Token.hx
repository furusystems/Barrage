package com.furusystems.barrage.parser;
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
	
	TIncremental;
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