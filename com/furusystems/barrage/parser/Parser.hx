package com.furusystems.barrage.parser;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.ActionDef;
import com.furusystems.barrage.data.BarrageItemDef;
import com.furusystems.barrage.data.BulletDef;
import com.furusystems.barrage.data.events.ActionEventDef;
import com.furusystems.barrage.data.events.DieEventDef;
import com.furusystems.barrage.data.events.FireEventDef;
import com.furusystems.barrage.data.events.PropertySetDef;
import com.furusystems.barrage.data.events.PropertyTweenDef;
import com.furusystems.barrage.data.events.WaitDef;
import com.furusystems.barrage.data.properties.Acceleration;
import com.furusystems.barrage.data.properties.Direction;
import com.furusystems.barrage.data.properties.DurationType;
import com.furusystems.barrage.data.properties.Property;
import com.furusystems.barrage.data.properties.Speed;
import com.furusystems.barrage.parser.Parser.Block;
import com.furusystems.barrage.parser.Token;
import hscript.Expr;
import hscript.Interp;

/**
 * ...
 * @author Andreas Rønning
 */
@:allow(com.furusystems.barrage.parser.Line)
@:allow(com.furusystems.barrage.parser.Block)
class Parser
{
	static var number:EReg = ~/[0-9]+[.,-]*[0-9]*/;
	static var math:EReg = ~/\([.\d *\-\+\/]*\)/;
	static var script:EReg = ~/\(.*\)/;
	
	static var stack:Array<BarrageItemDef>;
	
	static var bulletIdMap:Map<String,Int>;
	static var actionIdMap:Map<String,Int>;
	static var bulletDefMap:Map<String,BulletDef>;
	static var actionDefMap:Map<String,ActionDef>;
	static var actionIDs:Int;
	static var bulletIDs:Int;
	static var uidPool:Int;
	static var timeOffset:Float;
	static var output:Barrage;

	public static function parse(data:String):Barrage {
		log("Starting parse");
		return buildBarrage(getBlocks(getLines(data)));
	}
	
	static inline function log(msg:String):Void {
		#if debug
		trace(msg);
		#end
	}
	
	static function buildBarrage(blocks:Array<Block>):Barrage {
		stack = [];
		output = new Barrage();
		var root = blocks[0]; //Barrage has exactly one root block
		output.name = root.values[1];
		
		
		bulletIdMap = new Map<String,Int>();
		actionIdMap = new Map<String,Int>();
		bulletDefMap = new Map<String,BulletDef>();
		actionDefMap = new Map<String,ActionDef>();
		actionIDs = 0;
		bulletIDs = 0;
		uidPool = 0;
		
		//find every first level definition
		for (b in root.children) {
			switch(b.tokens) {
				case [TAction, TIdentifier]|[TAction, TStart]:
					buildActionDef(b);
				case [TBullet, TIdentifier]:
					buildBulletDef(b);
				default:
			}
		}
		
		
		for (k in actionDefMap.keys()) {
			var ad = actionDefMap.get(k);
			output.actions[actionIdMap.get(ad.name)] = ad;
		}
		for (k in bulletDefMap.keys()) {
			var bd = bulletDefMap.get(k);
			output.bullets[bulletIdMap.get(bd.name)] = bd;
		}
		
		
		bulletIdMap = null;
		actionIdMap = null;
		bulletDefMap = null;
		actionDefMap = null;
		if (output.start == null) throw new ParseError(0, "No action called start");
		var out = output;
		output = null;
		return out;
	}
	
	static inline function pushStack(item:BarrageItemDef):Void {
		stack.push(item);
		timeOffset = 0;
		//trace("Stack depth: " + stack.length);
	}
	static inline function popStack():Void {
		stack.pop();
		//trace("Stack depth: " + stack.length);
	}
	static inline function currentElement():BarrageItemDef {
		if (stack.length == 0) return null;
		else return stack[stack.length - 1];
	}
	
	static private function buildActionDef(b:Block,anon:Bool = false):ActionDef
	{
		var parent:Dynamic = currentElement();
		var ad:ActionDef;
		if (anon) ad = new ActionDef(uniqueName());
		else ad = new ActionDef(b.values[1]);
		
		if (b.tokens[1] == TStart) {
			output.start = ad;
		}
		
		pushStack(ad);
		if (actionIdMap.exists(ad.name)) {
			ad.id = actionIdMap.get(ad.name);
		}else {
			ad.id = actionIDs++;
			actionIdMap.set(ad.name, ad.id);
			actionDefMap.set(ad.name, ad);
		}
		
		if(parent!=null){
			if (Std.is(parent, ActionDef)) {
				//parent is action
				var event = new ActionEventDef();
				event.actionID = ad.id;
				parent.events.push(event);
			}else {
				//parent is bullet
				parent.action = ad.id;
			}
		}
		
		for (c in b.children) {
			switch(c.tokens) {
				case [TDo, TAction]:
					buildActionDef(c, true);
				case [TFire, TBullet]:
					buildBulletDef(c, true);
				default:
					readStatement(c);
			}
		}
		popStack();
		return ad;
	}
	
	static inline function uniqueName():String
	{
		return "" + uidPool++;
	}
	
	static function buildBulletDef(b:Block, anon:Bool = false):BulletDef
	{
		var bd:BulletDef;
		if (anon) bd = new BulletDef(uniqueName());
		else bd = new BulletDef(b.values[1]);
		
		pushStack(bd);
		if (bulletIdMap.exists(bd.name)) {
			bd.id = bulletIdMap.get(bd.name);
		}else {
			bulletIdMap.set(bd.name, bulletIDs++);
			bulletDefMap.set(bd.name, bd);
		}
		
		for (c in b.children) {
			switch(c.tokens) {
				case [TDo, TAction]:
					buildActionDef(c, true);
				case [TFire, TBullet]:
					buildBulletDef(c,true);
				default:
					readStatement(c);
			}
		}
		popStack();
		return bd;
	}
	
	static inline function clean(data:String):String {
		return data.toLowerCase().split("\r").join("\n").split("\n\n").join("\n");
	}
	static inline function getLines(data:String):Array<Line> {
		return toLines(trimComments(clean(data).split("\n")));
	}
	
	static inline function trimComments(lines:Array<String>):Array<String> 	{
		var i = lines.length;
		while (i-- > 0) {
			if (lines[i] == "" || lines[i].indexOf("#") >= 0) {
				lines.splice(i, 1);
			}
		}
		return lines;
	}
	
	static inline function toLines(stringLines:Array<String>):Array<Line> {
		var out = new Array<Line>();
		for (i in 0...stringLines.length) {
			out[i] = toLine(i, stringLines[i]);
		}
		log("Generated lines: "+out.length);
		return out;
	}
	
	static inline function toLine(index:Int, line:String):Line {
		var out:Line = new Line();
		out.index = index;
		var buffer:Array<String> = line.split("");
		var index:Int = 0;
		while (buffer[index++] == "\t") out.level++;
		out.data = line.substring(index-1);
		return out;
	}
	
	static function getBlocks(lines:Array<Line>):Array<Block> 
	{
		var out:Array<Block> = [];
		getBlock(0, lines, out);
		
		return out;
	}
	
	static function processBlock(b:Block):Void {
		parseString(b);
		readStatement(b);
		for (c in b.children) {
			processBlock(c);
		}
	}
	
	static function getToken(bank:Array<String>, tokens:Array<Token>, values:Array<Dynamic>):Void {
		var buffer:Array<String> = [];
		var char:String = bank.pop();
		var level:Int = 0;
		while (true) {
			if (char == ")") {
				level++;
			}
			else if (char == "(") {
				level--;
			}
			if (char == " " && level == 0) break;
			buffer.push(char);
			if (bank.length == 0) break;
			char = bank.pop();
		}
		buffer.reverse();
		var data = StringTools.trim(buffer.join(""));
		var type = getTokenType(data);
		if (type == TIgnored) return;
		
		tokens.push(type);
		values.push(buildValue(data, type));
	}
	
	static private function buildValue(data:String, type:Token):Dynamic {
		switch(type) {
			case TScript:
				return new hscript.Parser().parseString(data);
			case TConst_math:
				var expr = new hscript.Parser().parseString(data);
				return new hscript.Interp().execute(expr);
			case TNumber:
				return Std.parseFloat(data);
			default:
				return data;
		}
	}
	static function getTokenType(data:String):Token {
		if (script.match(data)) {
			return TScript;
		}
		if (math.match(data)) {
			return TConst_math;
		}
		if (number.match(data)) {
			return TNumber;
		}
		switch(data) {
			case "called", "then", "is","to","times":
				return TIgnored;
			case "horizontal":
				return THorizontal;
			case "vertical":
				return TVertical;
			case "barrage":
				return TBarrage;
			case "speed":
				return TSpeed;
			case "fire":
				return TFire;
			case "do":
				return TDo;
			case "acceleration":
				return TAcceleration;
			case "script":
				return TScript;
			case "incremental"|"sequential":
				return TIncremental;
			case "direction":
				return TDirection;
			case "absolute":
				return TAbsolute;
			case "aimed":
				return TAimed;
			case "relative":
				return TRelative;
			case "frames":
				return TFrames;
			case "seconds":
				return TSeconds;
			case "vanish"|"die":
				return TVanish;
			case "over":
				return TOver;
			case "set":
				return TSet;
			case "bullet":
				return TBullet;
			case "at":
				return TAt;
			case "in":
				return TIn;
			case "action":
				return TAction;
			case "wait":
				return TWait;
			case "repeat":
				return TRepeat;
			case "start":
				return TStart;
			default:
				return TIdentifier;
		}
	}
	
	
	static function parseString(block:Block):Void {
		var bank:Array<String> = block.raw.split("");
		while (bank[bank.length - 1] == " ") bank.pop();
		while (bank[0] == " ") bank.shift();
		var tokens:Array<Token> = [];
		var values:Array<Dynamic> = [];
		while (bank.length > 0) {
			getToken(bank, tokens, values);
		}
		tokens.reverse();
		values.reverse();
		block.tokens = tokens;
		block.values = values;
	}
	static function getBlock(start:Int, lines:Array<Line>, out:Array<Block>):Int {
		var root = lines[start];
		var b = new Block();
		b.lineNo = start;
		out.push(b);
		b.raw = root.data;
		parseString(b);
		var count = start+1;
		while (true) {
			if (count > lines.length - 1) break;
			if (lines[count] == root) {
				count++;
				continue;
			}
			if (lines[count].level <= root.level) break;
			count += getBlock(count, lines, b.children);
		}
		return count-start;
	}
	static function parseStatement(block:Block):String {
		var out:String = "";
		for (i in 0...block.tokens.length) {
			//out += t.type + ":"+t.data + " ";
			out += block.tokens[i]+ ":"+block.values[i] + " ";
		}
		return out;
	}
	static function printBlock(b:Block):Void {
		trace(b.lineNo+" - "+parseStatement(b));
		for (bl in b.children) {
			printBlock(bl);
		}
	}
	
	
	
	static function readStatement(b:Block):Void {
		switch(b.tokens) {
			case [TSpeed | TDirection | TAcceleration, TNumber | TConst_math | TScript]:
				runPropertyInit(b);
			case [TSet, TSpeed | TDirection | TAcceleration, TNumber | TConst_math | TScript | TAimed]:
				runPropertySet(b);
			case [TSet, TSpeed | TDirection | TAcceleration, TNumber|TConst_math|TScript|TAimed, TOver, TNumber|TConst_math|TScript, TSeconds | TFrames]:
				runPropertySet(b,true);
			case [TWait, TNumber|TConst_math|TScript, TFrames | TSeconds]:
				runWait(b);
			case [TDo, TIdentifier]:
				runAction(b, false);
			case [TFire, TIdentifier]:
				runFire(b);
			case [TFire, TIdentifier | TBullet, TAt, TIncremental | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[3], b.values[5]);
			case [TFire, TIdentifier | TBullet, TIn, TIncremental | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript]:
				runFire(b,null,null,b.tokens[3], b.values[5]);
			case [TFire, TIdentifier | TBullet, TAt, TIncremental | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript, TIn, TIncremental | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[3], b.values[5], b.tokens[7], b.values[9]);
			case [TFire, TIdentifier | TBullet, TIn, TIncremental | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript, TAt, TIncremental | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[7], b.values[9], b.tokens[3], b.values[5]);
			case [TRepeat, TNumber | TConst_math | TScript]:
				runRepeat(b);
			case [TVanish]:
				runVanish(b);
			default:
				throw new ParseError(b.lineNo, "Unrecognized line " + b.lineNo + ' "' + b.tokens + '"');
		}
		
	}
	
	//Statement handlers
	
	static inline function runVanish(b:Block) 
	{
		var ad:ActionDef = cast currentElement();
		ad.events.push(new DieEventDef());
	}
	
	static inline function runRepeat(b:Block) 
	{
		var ad:ActionDef = cast currentElement();
		switch(b.tokens[1]) {
			case TNumber | TConst_math:
				ad.repeatCount.constValue = b.values[1];
			case TScript:
				ad.repeatCount.script = b.values[1];
				ad.repeatCount.scripted = true;
			default:
		}
	}
	
	static inline function runFire(b:Block, ?speedType:Token, ?speed:Dynamic, ?directionType:Token, ?direction:Dynamic) 
	{
		//trace("Run fire: " + direction);
		var anon:Bool = false;
		switch(b.tokens[1]) {
			case TIdentifier:
				anon = false;
			case TBullet:
				anon = true;
			default:
				throw new ParseError(b.lineNo, "Invalid fire statement");
		}
		
		var event = new FireEventDef();
		
		if (!anon) {
			event.bulletID = bulletIdMap.get(b.values[1]);
		}
		
		
		
		if (speed != null) {
			event.speed = new Speed();
			switch(speedType) {
				case TRelative:
					event.speed.modifier = RELATIVE;
				case TIncremental:
					event.speed.modifier = INCREMENTAL;
				default:
					event.speed.modifier = ABSOLUTE;
			}
			if (Std.is(speed, Expr)) {
				event.speed.script = speed;
				event.speed.scripted = true;
			}else {
				event.speed.constValue = speed;
			}
			
		}
		if (direction != null) {
			event.direction = new Direction();
			switch(directionType) {
				case TAbsolute:
					event.direction.modifier = ABSOLUTE;
				case TRelative:
					event.direction.modifier = RELATIVE;
				case TIncremental:
					event.direction.modifier = INCREMENTAL;
				default:
					event.direction.modifier = AIMED;
			}
			if (Std.is(direction, Expr)) {
				event.direction.script = direction;
				event.direction.scripted = true;
			}else {
				event.direction.constValue = direction;
			}
		}
		var ad:ActionDef = cast currentElement();
		ad.events.push(event);
	}
	
	static inline function runAction(b:Block, anon:Bool) 
	{
		if (anon) {
			trace("Run anonymous action");
		}else {
			trace("Run action " + b.values[1]);
		}
	}
	
	static inline function runWait(b:Block) 
	{
		var event = new WaitDef();
		switch(b.tokens[1]) {
			case TNumber | TConst_math:
				event.waitTime = b.values[1];
			case TScript:
				event.waitTimeScript = b.values[1];
				event.scripted = true;
			default:
				
		}
		switch(b.tokens[2]) {
			case TFrames:
				event.durationType = DurationType.FRAMES;
			case TSeconds:
				event.durationType = DurationType.SECONDS;
			default:
				
		}
		var parent:Dynamic = currentElement();
		parent.events.push(event);
		//trace("Wait for " + b.values[1] + " " + b.tokens[2]);
	}
	
	static inline function runPropertySet(b:Block,overTime:Bool = false) {
		var target:String = "";
		var value:Null<Dynamic>;
		var event:Dynamic = null;
		if (overTime) event = new PropertyTweenDef();
		else event = new PropertySetDef();
		
		var p:Property = null;
		switch(b.tokens[1]) {
			case TSpeed:
				p = event.speed = new Speed();
			case TDirection:
				p = event.direction = new Direction();
			case TAcceleration:
				p = event.acceleration = new Acceleration();
			default:
				throw new ParseError(b.lineNo, "Invalid property");
		}
		
		switch(b.tokens[2]) {
			case TNumber | TConst_math:
				p.constValue = b.values[2];
			case TScript:
				p.script = b.values[2];
				p.scripted = true;
			case TAimed:
				p.isAimed = true;
			default:
		}
		if (overTime) {
			switch(b.tokens[4]) {
				case TNumber | TConst_math:
					event.tweenTime = b.values[4];
				case TScript:
					event.tweenTimeScript = b.values[4];
					event.scripted = true;
				default:
			}
			switch(b.tokens[5]) {
				case TSeconds:
					event.durationType = DurationType.SECONDS;
				case TFrames:
					event.durationType = DurationType.FRAMES;
				default:
			}
		}
		var ad:ActionDef = cast currentElement();
		ad.events.push(event);
	}
	
	static inline function runPropertyInit(b:Block) {
		var target:String = "";
		var value:Null<Dynamic>;
		var p:Property = null;
		var object:Dynamic = currentElement();
		switch(b.tokens[0]) {
			case TSpeed:
				p = object.speed;
			case TDirection:
				p = object.direction;
			case TAcceleration:
				p = object.acceleration;
			default:
		}
		switch(b.tokens[1]) {
			case TNumber|TConst_math:
				p.constValue = b.values[1];
			case TScript:
				p.script = b.values[1];
				p.scripted = true;
			default:
		}
	}
	
}
class Line {
	public var index:Int = 0;
	public var level:Int = 0;
	public var data:String;
	public function new() {
		
	}
	public function toString():String {
		return 'Line [ $index, $level, $data ]';
	}
}
class Block {
	public var lineNo:Int;
	public var tokens:Array<Token>;
	public var values:Array<Dynamic>;
	public var raw:String;
	public var children:Array<Block>;
	public function new() {
		children = [];
	}
	public function toString():String {
		var out:String = raw+"{";
		for (i in 0...children.length) {
			out += "\n\t"+children[i];
		}
		out += "}";
		return out;
	}
}