package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;

class MenuState extends FlxState
{
	private var buttonPlay:Button;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 2;
		
		//creating a simple button to go to the game
		buttonPlay = new Button(0, 0, "Play", clickedPlay);
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
		FlxG.sound.play(AssetPaths.NFF_bump__wav);	
		
		FlxG.switchState(new SelectionState());
	}
}
