package com.furusystems.barrage;
import com.furusystems.barrage.Barrage;
import com.furusystems.barrage.data.Token;
import com.furusystems.barrage.data.TokenType;
import com.furusystems.flywheel.geom.Vector2D;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

class Barrage
{
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
	
	public static function parse(data:String):Barrage {
		var lines:Array<Line> = getLines(data);
		
		var out:Barrage = new Barrage();
		
		getBlocks(lines);
		
		return out;
	}
	
	static private function getBlocks(lines:Array<Line>):Array<Block> 
	{
		var out:Array<Block> = [];
		getBlock(0, lines, out);
		for (b in out) {
			processBlock(b);
		}
		trace("Created "+out.length+" blocks");
		
		return out;
	}
	
	static private function processBlock(b:Block) 
	{
		b.statement = parseString(b.raw);
		for (c in b.children) {
			processBlock(c);
		}
	}
	
	static private function getToken(bank:Array<String>, tokens:Array<Token>):Void 
	{
		var buffer:Array<String> = [];
		var char:String = bank.pop();
		while (char != " ") {
			buffer.push(char);
			if (bank.length == 0) break;
			char = bank.pop();
		}
		buffer.reverse();
		var data = buffer.join("");
		var type:TokenType = getTokenType(data);
		if (type == ignored) return;
		
		tokens.push(new Token(type, data));
	}
	static private function getTokenType(data:String):TokenType {
		switch(data) {
			case "called", "at", "in", "then", "is","to":
				return ignored;
			case "horizontal":
				return horizontal_token;
			case "vertical":
				return vertical_token;
			case "barrage":
				return barrage_token;
			case "speed":
				return speed_token;
			case "times":
				return times_token;
			case "fire":
				return fire_token;
			case "do":
				return do_token;
			case "script":
				return script_token;
			case "direction":
				return direction_token;
			case "sequential":
				return sequential_token;
			case "absolute":
				return absolute_token;
			case "aimed":
				return aimed_token;
			case "relative":
				return relative_token;
			case "frames":
				return frames_token;
			case "seconds":
				return seconds_token;
			case "vanish":
				return vanish_token;
			case "over":
				return over_token;
			case "set":
				return set_token;
			case "bullet":
				return bullet_token;
			case "action":
				return action_token;
			default:
				return identifier_token;
				
		}
	}
	
	static private function parseString(raw:String):Vector<Token> 
	{
		var bank:Array<String> = raw.split("");
		var tokens:Array<Token> = [];
		while (bank.length > 0) {
			getToken(bank, tokens);
		}
		tokens.reverse();
		trace(tokens);
		var numTokens:Int = 0;
		var out = new Vector<Token>(numTokens);
		return out;
	}
	static private function getBlock(start:Int, lines:Array<Line>, out:Array<Block>):Int {
		var root:Line = lines[start];
		var b:Block = new Block();
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
	
	public function new() {
		
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
	public var statement:Vector<Token>;
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