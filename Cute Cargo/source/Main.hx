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
		
		addChild(new FlxGame(Std.int(400 * scaler), Std.int(640 * scaler), MenuState, 1, 60, 60, true));
	}
}
