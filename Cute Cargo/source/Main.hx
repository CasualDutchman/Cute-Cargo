package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		//FlxG.fullscreen = true;
		
		var scaler:Float = 2; // this scales handles the camera zoom. (1 = normal, 2 = zoomed in)
		
		#if mobile
		addChild(new FlxGame(Std.int(540 * scaler), Std.int(960 * scaler), MenuState));
		#end
		
		#if flash
		addChild(new FlxGame(Std.int(960 * scaler), Std.int(540 * scaler), MenuState));
		#end
	}
}
