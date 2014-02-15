package com.furusystems.barrage.instancing.events;
import com.furusystems.barrage.data.EventDef;
import com.furusystems.barrage.data.events.FireBeamEventDef;
import com.furusystems.barrage.instancing.events.FireBulletEvent;

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
			case EventType.FIRE_BULLET:
				out = new FireBulletEvent(def);
			case EventType.FIRE_BEAM:
				out = new FireBeamEvent(def);
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