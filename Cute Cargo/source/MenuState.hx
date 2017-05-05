package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
	private var buttonPlay:FlxButton;
	
	override public function create():Void
	{
		buttonPlay = new FlxButton(0, 0, "Play", clickedPlay);
		buttonPlay.screenCenter();
		add(buttonPlay);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickedPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}
