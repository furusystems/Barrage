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
	TFrom;
	TPosition;
	TSet;
	TBeam;
	TBullet;
	TAction;
	TFire;
	TDo;
	TAt;
	TIn;
	TWith;
	TWait;
	TRepeat;
	TIncrement;
	TVector;
	
	TWidth;
	TLength;
	TDamage;
	TSpeed;
	TDirection;
	TAcceleration;
	
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