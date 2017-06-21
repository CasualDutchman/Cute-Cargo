package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class CoachState extends FlxState
{
	private var buttonPlay:Button;
	
	var currentmessage:Int = 0;
	var messages:Array<String> = ["Hi! My name is Coach. I will help you throughout the game.", "I will explain how to play the game and tell you something about teambuilding.", "I can always ask me for help, by pressing the\n'!' button.", "Good luck and get to work!"];
	
	var box:DialogueBox;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 1;
		
		var bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.LevelScreen__png);
		add(bg);
		
		box = new DialogueBox((FlxG.width - 420) / 2, 350, messages[currentmessage], clickedPlay);
		add(box);
		
		add(buttonPlay);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickedPlay():Void
	{
		if (currentmessage <= messages.length - 2)
		{		
			FlxG.sound.play(AssetPaths.NFF_menu_04_b__wav, 0.1);
			
			currentmessage++;
			box.SetText(messages[currentmessage]);
		}
		else
		{
			FlxG.sound.play(AssetPaths.NFF_menu_04_b__wav, 0.1, false, FlxG.sound.defaultSoundGroup, true, GoToSelect);
		}
		
	}
	
	function GoToSelect()
	{
		FlxG.switchState(new SelectionState()); 
	}
	
}