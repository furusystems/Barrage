package com.furusystems.barrage.parser;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.Orientation;
import com.furusystems.barrage.parser.Token;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class Parser
{
	static var number:EReg = ~/[0-9]+[.,]*[0-9]*/;
	static var math:EReg = ~/\(.*\)/;

	public static function parse(data:String):Barrage {
		return buildBarrage(getBlocks(getLines(data)));
	}
	
	static function buildBarrage(blocks:Array<Block>):Barrage {
		var out:Barrage = new Barrage();
		var root = blocks[0]; //Barrage has exactly one root block
		for (i in 0...root.tokens.length) {
			var t = root.tokens[i];
			switch(t) {
				case TVertical:
					out.orientation = Orientation.VERTICAL;
				case THorizontal:
					out.orientation = Orientation.HORIZONTAL;
				case TIdentifier:
					out.name = root.values[i];
				default:
					continue;
			}
		}
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
	
	static private function getBlocks(lines:Array<Line>):Array<Block> 
	{
		var out:Array<Block> = [];
		getBlock(0, lines, out);
		for (b in out) {
			processBlock(b);
		}
		
		return out;
	}
	
	static private function processBlock(b:Block) 
	{
		parseString(b);
		readStatement(b);
		for (c in b.children) {
			processBlock(c);
		}
	}
	
	static private function readStatement(b:Block):Void 
	{
		//trace(b.raw);
		switch(b.tokens) {
			case [THorizontal | TVertical, TBarrage, TIdentifier]:
				trace("Declaration");
			case [TBullet, TIdentifier]:
				trace("Bullet def");
			case [TAction, TStart]:
				trace("Init action def");
			case [TAction, TIdentifier]:
				trace("Action def");
			case [TSpeed|TDirection|TAcceleration, TNumber|TConst_math|TScript]:
				trace("Property init");
			case [TSet, TSpeed | TDirection | TAcceleration, TNumber|TConst_math|TScript] | [TSet, TSpeed | TDirection | TAcceleration, TNumber|TConst_math|TScript, TOver, TNumber|TConst_math|TScript, TSeconds | TFrames]:
				trace("Property set");
			case [TWait, TNumber|TConst_math|TScript, TFrames | TSeconds]:
				trace("Wait");
			case [TDo, TAction | TIdentifier]:
				trace("Action trigger");
			case [TFire, TIdentifier | TBullet] | 
				[TFire, TIdentifier | TBullet, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript] | 
				[TFire, TIdentifier | TBullet, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript] | 
				[TFire, TIdentifier | TBullet, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript] | 
				[TFire, TIdentifier | TBullet, TIn, TSequential | TAbsolute | TRelative | TAimed, TDirection, TNumber | TConst_math | TScript, TAt, TSequential | TAbsolute | TRelative, TSpeed, TNumber | TConst_math | TScript]:
				trace("Fire bullet");
			case [TRepeat, TNumber | TConst_math | TScript]:
				trace("Repeat");
			case [TVanish]:
				trace("Vanish");
			default:
				throw "Unrecognized line " + b.lineNo+' "'+b.tokens+'"';
		}
		
	}
	
	static private function getToken(bank:Array<String>, tokens:Array<Token>, values:Array<Dynamic>):Void 
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
		var type:Token = getTokenType(data);
		if (type == TIgnored) return;
		
		tokens.push(type);
		values.push(data);
	}
	static private function getTokenType(data:String):Token {
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
			case "vanish":
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
			default:
				return TIdentifier;
		}
	}
	
	
	static private function parseString(block:Block):Void
	{
		var bank:Array<String> = block.raw.split("");
		while (bank[bank.length - 1] == " ") bank.pop();
		while (bank[0] == " ") bank.shift();
		var tokens:Array<Token> = [];
		var values:Array<Dynamic> = [];
		while (bank.length > 0) {
			getToken(bank, tokens,values);
		}
		tokens.reverse();
		values.reverse();
		block.tokens = tokens;
		block.values = values;
	}
	static private function getBlock(start:Int, lines:Array<Line>, out:Array<Block>):Int {
		var root:Line = lines[start];
		var b:Block = new Block();
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
	public function new() 
	{
		
	}
	
}
private class Line {
	public var index:Int = 0;
	public var level:Int = 0;
	public var data:String;
	public function new() {
		
	}
	public function toString():String {
		return 'Line [ $index, $level, $data ]';
	}
}
private class Block {
	public var lineNo:Int;
	public var tokens:Array<Token>;
	public var values:Array<Dynamic>;
	public var raw:String;
	public var children:Array<Block>;
	public function new() {
		children = [];
	}
	public function toString():String {
		//var out:String = "Block "+children.length+"\n";
		var out:String = raw+"{";
		for (i in 0...children.length) {
			out += "\n\t"+children[i];
		}
		out += "}";
		return out;
	}
}