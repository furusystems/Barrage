package com.furusystems.barrage.data.events;
import com.furusystems.barrage.instancing.RunningBarrage;
import com.furusystems.barrage.data.events.EventDef.EventType;
import com.furusystems.barrage.instancing.RunningAction;
import hscript.Expr;
import motion.Actuate;
import motion.easing.Linear;

/**
 * ...
 * @author Andreas Rønning
 */
class PropertyTween extends PropertySet
{
	public var tweenTime:Float;
	public var tweenTimeScript:Expr;
	public var scripted:Bool = false;
	public var durationType:DurationType;
	public function new() 
	{
		super();
		type = EventType.PROPERTY_TWEEN;
	}
	override public function trigger(runningAction:RunningAction, runningBarrage:RunningBarrage):Void 
	{
		#if debug
		trace("Property tween");
		#end
		
		var tweenTimeNum:Float;
		if (scripted) {
			tweenTimeNum = runningBarrage.owner.executor.execute(tweenTimeScript);
		}else {
			tweenTimeNum = tweenTime;
		}
		if (durationType == FRAMES) {
			tweenTimeNum = (tweenTimeNum * 1 / runningBarrage.owner.frameRate);
		}
		var props:Dynamic = { };
		if (speed != null) {
			props.speed = speed.get(runningBarrage, runningAction);
		}
		if (direction != null) {
			if (direction.isAimed) {
				var ang = runningBarrage.emitter.getAngleToPlayer(runningAction.currentBullet.pos);
				while (ang > 180) ang -= 360;
				while (ang < -180) ang += 360;
				
				props.angle = ang;
			}else {
				props.angle = direction.get(runningBarrage, runningAction);
			}
		}
		if (acceleration != null) {
			props.acceleration = acceleration.get(runningBarrage, runningAction);
		}
		Actuate.tween(runningAction.currentBullet, tweenTimeNum, props).ease(Linear.easeNone);
	}
	
}