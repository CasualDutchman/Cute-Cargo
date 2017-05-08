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
		
		var scaler:Float = 1; // this scales handles the camera zoom. (1 = normal, 2 = zoomed in)
		
		addChild(new FlxGame(Std.int(960 * scaler), Std.int(540 * scaler), MenuState));
	}
}
