package com.furusystems.barrage.instancing.events;

import com.furusystems.barrage.data.EventDef;

/**
 * ...
 * @author Andreas Rønning
 */
class EventFactory {
	public static inline function create(def:EventDef):ITriggerableEvent {
		return switch (def.type) {
			case EventType.WAIT:
				new Wait(def);
			case EventType.DIE:
				new DieEvent(def);
			case EventType.FIRE:
				new FireEvent(def);
			case EventType.PROPERTY_SET:
				new PropertySet(def);
			case EventType.PROPERTY_TWEEN:
				new PropertyTween(def);
			case EventType.ACTION:
				new ActionEvent(def);
			case EventType.ACTION_REF:
				new ActionReferenceEvent(def);
		}
	}
}
