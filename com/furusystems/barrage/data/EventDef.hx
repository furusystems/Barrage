package com.furusystems.barrage.data;

/**
 * ...
 * @author Andreas Rønning
 */
enum EventType {
	PROPERTY_SET;
	PROPERTY_TWEEN;
	FIRE;
	ACTION;
	ACTION_REF;
	DIE;
	WAIT;
}

class EventDef {
	public var type:EventType;

	public function new() {}
}
