package;

import axolstudio.FlxSand.Sand;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var sand:axolstudio.FlxSand;

	public var pattern:Array<SandDef> = [];

	public function createPattern():Void
	{
		for (x in 0...16)
		{
			for (y in 0...16)
			{
				pattern.push(new SandDef(x, y, y > 14 ? FlxG.random.float(0.2, 0.4) : FlxG.random.float(0.6, 0.8)));
			}
		}
	}

	override public function create()
	{
		createPattern();

		FlxG.log.add(pattern);

		sand = new axolstudio.FlxSand(0, 0, FlxG.width, FlxG.height);
		add(sand);

		// var timer:FlxTimer = new FlxTimer();
		// timer.start(.02, (_) ->
		// {
		// 	var x:Int = FlxG.random.int(0, Std.int(FlxG.width));
		// 	sand.addSand(FlxPoint.weak(x, 0), FlxMath.lerp(0, 359, x / FlxG.width), FlxG.random.float(0.25, 0.75));
		// }, 0);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justReleased)
		{
			spawnBlock();
		}
	}

	public function spawnBlock():Void
	{
		var x:Int = FlxG.mouse.x;
		var y:Int = FlxG.mouse.y;
		var hue:Int = FlxG.random.int(0, 359);

		FlxG.log.add(x + " " + y);
		for (s in pattern)
		{
			sand.addSand(FlxPoint.weak(x + s.x, y + s.y), hue, s.lightness);
		}
	}
}

class SandDef
{
	public var x:Int;
	public var y:Int;
	public var lightness:Float;

	public function new(x:Int, y:Int, lightness:Float)
	{
		this.x = x;
		this.y = y;
		this.lightness = lightness;
	}
}
