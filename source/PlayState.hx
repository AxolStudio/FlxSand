package;

import axolstudio.FlxSand.Sand;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
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
				pattern.push(new SandDef(x, y, y >= 14 || x >= 14 ? FlxG.random.float(0.2,
					0.3) : y < 1 || x < 1 ? FlxG.random.float(0.6, 0.7) : FlxG.random.float(0.4, 0.5)));
			}
		}
	}

	override public function create()
	{
		createPattern();

		// FlxG.log.add(pattern);

		sand = new axolstudio.FlxSand(0, 0, FlxG.width, FlxG.height);
		add(sand);

		addStructures();

		var timer:FlxTimer = new FlxTimer();
		timer.start(.02, (_) ->
		{
			var x:Int = FlxG.random.int(0, Std.int(FlxG.width));
			sand.addSand(FlxPoint.weak(x, 0), FlxColor.fromHSL(FlxMath.lerp(0, 359, x / FlxG.width), 1, FlxG.random.float(0.25, 0.75)));
		}, 0);

		super.create();
	}

	private function addStructures():Void
	{
		// add a cirle of locked sand to the center of sand
		var radius:Int = 10;
		var center:FlxPoint = new FlxPoint(Std.int(sand.width / 2), Std.int(sand.height / 2));
		for (x in -radius...radius)
		{
			for (y in -radius...radius)
			{
				if (FlxPoint.weak(x, y).distanceTo(FlxPoint.weak()) < radius)
				{
					FlxG.log.add("Adding sand at " + (center.x + x) + ", " + (center.y + y));
					// sand.addSand(FlxPoint.weak(center.x + x, center.y + y), FlxColor.fromHSL(0, 0, FlxG.random.float(0.5, 0.8)), true);
					sand.addSand(FlxPoint.weak(center.x + x, center.y + y), FlxColor.fromHSL(0, 0, FlxG.random.float(0.5, 0.8)), true);
				}
			}
		}
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

		for (s in pattern)
		{
			sand.addSand(FlxPoint.weak(x + s.x, y + s.y), FlxColor.fromHSL(hue, 1, s.lightness));
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
