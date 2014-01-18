package com.furusystems.barrage.data.properties;
import hscript.Interp;

/**
 * ...
 * @author Andreas Rønning
 */
class Property
{
	public var constValue:Float = 0;
	public var script:Null<hscript.Expr>;
	public var scripted:Bool = false;
	public function new() 
	{
		
	}
	
	public function get(interp:Interp):Dynamic 
	{
		if (scripted) {
			return interp.execute(script);
		}else return constValue;
	}
	
}