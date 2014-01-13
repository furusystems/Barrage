package com.furusystems.barrage.parser;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.Orientation;
import com.furusystems.barrage.parser.Parser.Block;
import com.furusystems.barrage.parser.Token;
import haxe.ds.Vector;
import hscript.Interp;

/**
 * ...
 * @author Andreas Rønning
 */
class Parser
{
	static var number:EReg = ~/[0-9]+[.,]*[0-9]*/;
	static var math:EReg = ~/\([.\d *\-\+\/]*\)/;
	static var script:EReg = ~/\(.*\)/;

	public static function parse(data:String):Barrage {
		return buildBarrage(getBlocks(getLines(data)));
	}
	
	static function buildBarrage(blocks:Array<Block>):Barrage {
		var out:Barrage = new Barrage();
		var root = blocks[0]; //Barrage has exactly one root block
		out.name = root.values[1];
		trace("Parsing complete\n\n");
		printBlock(root);
		
		return out;
	}
	
	
	
	static inline function getLines(data:String):Array<Line> {
		return toLines(trimComments(data.toLowerCase().split("\r").join("").split("\n")));
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
		for (b in out) {
			processBlock(b);
		}
		
		return out;
	}
	
	static function processBlock(b:Block) 
	{
		parseString(b);
		readStatement(b);
		for (c in b.children) {
			processBlock(c);
		}
	}
	
	static function getToken(bank:Array<String>, tokens:Array<Token>, values:Array<Dynamic>):Void 
	{
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
	
	static private function buildValue(data:String, type:Token):Dynamic 
	{
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
		if (math.match(data)) {
			return TConst_math;
		}
		if (script.match(data)) {
			return TScript;
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
			case "sequential":
				return TSequential;
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
	
	
	static function parseString(block:Block):Void
	{
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
	
	
	
	static function readStatement(b:Block):Void 
	{
		//trace(b.raw);
		switch(b.tokens) {
			case [TBarrage, TIdentifier]:
				runDeclaration(b);
			case [TBullet, TIdentifier]:
				runBulletDef(b);
			case [TAction, TStart]:
				runActionDef(b, true);
			case [TAction, TIdentifier]:
				runActionDef(b, false);
			case [TSpeed | TDirection | TAcceleration, TNumber | TConst_math | TScript]:
				runPropertyInit(b);
			case [TSet, TSpeed | TDirection | TAcceleration, TNumber | TConst_math | TScript]:
				runPropertySet(b);
			case [TSet, TSpeed | TDirection | TAcceleration, TNumber|TConst_math|TScript, TOver, TNumber|TConst_math|TScript, TSeconds | TFrames]:
				runPropertySet(b,true);
			case [TWait, TNumber|TConst_math|TScript, TFrames | TSeconds]:
				runWait(b);
			case [TDo, TAction]:
				runAction(b, true);
			case [TDo, TIdentifier]:
				runAction(b, false);
			case [TFire, TBullet] | [TFire, TIdentifier]:
				runFire(b);
			case [TFire, TIdentifier | TBullet, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[3], b.values[5]);
			case [TFire, TIdentifier | TBullet, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript]:
				runFire(b,null,null,b.tokens[3], b.values[5]);
			case [TFire, TIdentifier | TBullet, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[3], b.values[5], b.tokens[7], b.values[9]);
			case [TFire, TIdentifier | TBullet, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript]:
				runFire(b, b.tokens[7], b.values[9], b.tokens[3], b.values[5]);
			case [TRepeat, TNumber | TConst_math | TScript]:
				runRepeat(b);
			case [TVanish]:
				runVanish(b);
			default:
				throw "Unrecognized line " + b.lineNo+' "'+b.tokens+'"';
		}
		
	}
	
	//Statement handlers
	
	static inline function runVanish(b:Block) 
	{
		trace("Vanish");
	}
	
	static inline function runRepeat(b:Block) 
	{
		trace("Repeat " + b.values[1]);
	}
	
	static inline function runFire(b:Block, ?speedType:Token, ?speed:Dynamic, ?directionType:Token, ?direction:Dynamic) 
	{
		var anon:Bool = false;
		switch(b.tokens[1]) {
			case TIdentifier:
				anon = false;
			case TBullet:
				anon = true;
			default:
				throw("Invalid fire statement");
		}
		if (anon) {
			trace("Fire anonymous bullet");
		}else {
			trace("Fire bullet " + b.values[1]);
		}
		if (speed != null) {
			trace("\t\t" + speedType + " speed " + speed);
		}
		if (direction != null) {
			trace("\t\t" + directionType + " direction " + direction);
		}
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
		switch(b.tokens[1]) {
			case TNumber:
			case TConst_math:
			case TScript:
			default:
				
		}
		switch(b.tokens[2]) {
			case TFrames:
			case TSeconds:
			default:
				
		}
		trace("Wait for " + b.values[1] + " " + b.tokens[2]);
	}
	
	static inline function runPropertySet(b:Block,overTime:Bool = false) 
	{
		var target:String = "";
		var value:Null<Dynamic>;
		switch(b.tokens[1]) {
			case TSpeed:
			case TDirection:
			case TAcceleration:
			default:
		}
		switch(b.tokens[2]) {
			case TNumber:
			case TConst_math:
			case TScript:
			default:
		}
		if (overTime) {
			switch(b.tokens[4]) {
				case TNumber:
				case TConst_math:
				case TScript:
				default:
			}
			switch(b.tokens[5]) {
				case TSeconds:
				case TFrames:
				default:
			}
		}
		trace("Set property " + b.tokens[1] + " to " + b.values[2] + (overTime?(" over "+b.values[4] + " " + b.tokens[5]):""));
	}
	
	static inline function runPropertyInit(b:Block) 
	{
		var target:String = "";
		var value:Null<Dynamic>;
		switch(b.tokens[0]) {
			case TSpeed:
			case TDirection:
			case TAcceleration:
			default:
		}
		switch(b.tokens[1]) {
			case TNumber:
			case TConst_math:
			case TScript:
			default:
		}
		trace("Property init: " + b.tokens[0] + " = " + b.values[1]);
	}
	
	static inline function runActionDef(b:Block, isStart:Bool = false) 
	{
		if (isStart) trace("Init action def");
		else trace("Action def " + b.values[1]);
	}
	
	static inline function runBulletDef(b:Block) 
	{
		trace("Bullet def: "+b.values[1]);
	}
	static inline function runDeclaration(b:Block) 
	{
		trace("Declaration: " + b.values[1]);
	}
	
	public function new() 
	{
		
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