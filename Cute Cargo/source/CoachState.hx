package;

import flixel.FlxState;
import flixel.FlxG;

class CoachState extends FlxState
{
	private var buttonPlay:Button;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 1;
		
		//===================================================
		//FlxG.sound.playMusic(AssetPaths.POL_candy_valley_short__wav, 0.1); // Lynn
		
		var box = new DialogueBox((FlxG.width - 500) / 2, 550, "Coach", "Hi I am the coach", clickedPlay);
		add(box);
		
		//creating a simple button to go to the game
		buttonPlay = new Button(0, 0, "Play", clickedPlay);
		buttonPlay.screenCenter();
		buttonPlay.y += 100;
		
		add(buttonPlay);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickedPlay():Void
	{
		//===================================================
		FlxG.sound.play(AssetPaths.NFF_bump__wav, 1, false, FlxG.sound.defaultSoundGroup, true, GoToSelect); //Lynn
		
		//FlxG.switchState(new SelectionState());
	}
	
	function GoToSelect()
	{
		var state = new PlayState();
		state.setGridSize(PublicVariables.levelSizes[0].x, PublicVariables.levelSizes[0].y);
		FlxG.switchState(state); 
	}
	
}