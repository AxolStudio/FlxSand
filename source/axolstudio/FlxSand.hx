package axolstudio;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

class FlxSand extends FlxSprite
{
	#if debug
	private var sandCount:Int = 0;
	private var sandDrawn:Int = 0;
	#end

	public var bgColor:FlxColor = FlxColor.TRANSPARENT;

	public var sand:Map<String, Sand>;

	public var newSand:Array<Sand>;

	public function getSand(X:Float, Y:Float):Sand
	{
		if (sand.exists(FlxPoint.weak(Std.int(X), Std.int(Y)).toString()))
			return sand.get(FlxPoint.weak(Std.int(X), Std.int(Y)).toString());
		return null;
	}

	public function checkSand(X:Float, Y:Float):Bool
	{
		return sand.exists(FlxPoint.weak(Std.int(X), Std.int(Y)).toString());
	}

	public function new(X:Float, Y:Float, Width:Float, Height:Float, BGColor:FlxColor = FlxColor.TRANSPARENT):Void
	{
		super(X, Y);

		bgColor = BGColor;
		makeGraphic(Std.int(Width), Std.int(Height), bgColor, true, FlxG.bitmap.getUniqueKey("sand"));

		sand = [];
		newSand = [];

		#if debug
		FlxG.watch.add(this, "sandCount");
		FlxG.watch.add(this, "sandDrawn");
		#end
	}

	public function addSand(Position:FlxPoint, Color:FlxColor, Locked:Bool = false, Weight:Float = 1):Void
	{
		if (Position.x < 0 || Position.x >= width || Position.y < 0 || Position.y >= height)
			return;
		if (checkSand(Position.x, Position.y))
		{
			return;
		}
		newSand.push(new Sand(Position, Color, Locked, Weight));
	}

	public function removeSand(Position:FlxPoint):Void
	{
		sand.remove(Position.toString());
	}

	public function updateSandPosition():Void
	{
		// sort sand by position y: desc, x: asc

		// for each sand, check if it can fall down

		// if it can, move it down

		// if it can't, check if it can move left or right

		// if it can, move it left or right

		for (s in newSand)
		{
			sand.set(s.position.toString(), s);
		}
		newSand = [];

		var moved:Bool = false;

		for (y in 0...Std.int(height + 1))
		{
			var posY:Int = Std.int(height) - y;

			for (x in 0...Std.int(width))
			{
				var pos:FlxPoint = FlxPoint.weak(x, posY);
				var s:Sand = sand.get(pos.toString());

				if (s == null)
				{
					continue;
				}

				if (s.position.y >= height - 1)
				{
					continue;
				}

				if (s.locked)
				{
					continue;
				}

				var canFall:Bool = !checkSand(s.position.x, s.position.y + 1);

				if (canFall)
				{
					s.position.y += 1;
					moved = true;
				}
				else
				{
					var canMoveLeft:Bool = false;
					var canMoveRight:Bool = false;

					var sLD:Bool = checkSand(s.position.x - 1, s.position.y + 1);
					var sRD:Bool = checkSand(s.position.x + 1, s.position.y + 1);
					var sL:Bool = checkSand(s.position.x - 1, s.position.y);
					var sR:Bool = checkSand(s.position.x + 1, s.position.y);
					var sU:Bool = checkSand(s.position.x, s.position.y - 1);
					var sLU:Bool = checkSand(s.position.x - 1, s.position.y - 1);
					var sRU:Bool = checkSand(s.position.x + 1, s.position.y - 1);

					canMoveRight = ((sLU || sU) && !sR && !sRD);
					canMoveLeft = ((sRU || sU) && !sL && !sLD);
					if (s.position.x == 0)
					{
						canMoveLeft = false;
					}
					if (s.position.x == width - 1)
					{
						canMoveRight = false;
					}

					if (canMoveLeft || canMoveRight)
					{
						moved = true;
						s.position.y += 1;
						if (canMoveLeft && canMoveRight)
						{
							if (Math.random() < 0.5)
							{
								s.position.x -= 1;
							}
							else
							{
								s.position.x += 1;
							}
						}
						else if (canMoveLeft)
						{
							s.position.x -= 1;
						}
						else if (canMoveRight)
						{
							s.position.x += 1;
						}
					}
				}
				if (moved)
				{
					sand.remove(pos.toString());
					sand.set(s.position.toString(), s);
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		updateSandPosition();
	}

	public function drawSand():Void
	{
		// slow!!! how do I replace this with shader?
		var newBMP:BitmapData = pixels;
		// new BitmapData(Std.int(width), Std.int(height), true, bgColor);
		newBMP.lock();
		newBMP.fillRect(newBMP.rect, bgColor);
		#if debug
		sandDrawn = 0;
		#end
		for (s in sand)
		{
			var x:Int = Std.int(s.position.x);
			var y:Int = Std.int(s.position.y);

			var color:Int = s.color;

			if (x >= 0 && x < width && y >= 0 && y < height)
			{
				newBMP.setPixel32(x, y, color);
				#if debug
				sandDrawn++;
				#end
			}
		}
		newBMP.unlock();
		// pixels = newBMP;
		// dirty = true;
	}

	override function draw()
	{
		drawSand();
		super.draw();
	}
}

class Sand
{
	public var position:FlxPoint;

	public var color:FlxColor;
	public var weight:Float = 1; // not yet used

	public var locked:Bool = false;

	public function new(Position:FlxPoint, Color:FlxColor, Locked:Bool = false, Weight:Float = 1):Void
	{
		position = Position;
		color = Color;
		weight = Weight;

		locked = Locked;
	}
}
