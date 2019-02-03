package com.furusystems.barrage.parser;

/**
 * ...
 * @author Andreas Rønning
 */
enum Token {
	TBarrage;
	TVanish;
	TOver;
	TFrom;
	TPosition;
	TSet;
	TBullet;
	TAction;
	TFire;
	TDo;
	TAt;
	TIn;
	TWith;
	TSpeed;
	TDirection;
	TAcceleration;
	TWait;
	TForever;
	TRepeat;
	TIncrement;
	TVector;
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
	// ignored tokens
	TIgnored;
	// called;
	// then;
	// is;
	// to;
	// times;
}
