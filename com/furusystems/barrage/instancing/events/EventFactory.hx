package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;

/**
 * ...
 * @author Andreas Rønning
 */
class EventFactory
{
	public static inline function create(def:EventDef):ITriggerableEvent {
		var out:ITriggerableEvent;
		switch(def.type) {
			case EventType.WAIT:
				out = new Wait(def);
			case EventType.DIE:
				out = new DieEvent(def);
			case EventType.FIRE:
				out = new FireEvent(def);
			case EventType.PROPERTY_SET:
				out = new PropertySet(def);
			case EventType.PROPERTY_TWEEN:
				out = new PropertyTween(def);
			case EventType.ACTION:
				out = new ActionEvent(def);
			case EventType.ACTION_REF:
				out = new ActionReferenceEvent(def);
		}
		return out;
	}
}