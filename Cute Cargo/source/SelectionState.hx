package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.FlxSprite;

class SelectionState extends FlxState
{			
	var box:DialogueBox;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 1;
		
		for (i in 0...PublicVariables.levelSizes.length)
		{
			if (i < PublicVariables.levelActiveLevels)
			{
				var button:Button = new Button((FlxG.width - 281) / 2, 370 + (i * 60), i + 1 + "", function clicker()
					{ 
						//===================================================
						for (sound in FlxG.sound.defaultMusicGroup.sounds) // Lynn
						{
							sound.stop();
						}
						
						if (i == 0)
						{
							FlxG.switchState(new CoachState());
						}
						else
						{
							var state = new PlayState();
							state.setGridSize(PublicVariables.levelSizes[i].x, PublicVariables.levelSizes[i].y);
							FlxG.switchState(state); 
						}
					});
				add(button);
			}
			else
			{
				var noClick:FlxSprite = new FlxSprite((FlxG.width - 281) / 2, 370 + (i * 60));
				noClick.loadGraphic(AssetPaths.button_notclick__png);
				add(noClick);
			}
		}
		
		var returnButton:ButtonSmall = new ButtonSmall((FlxG.width - 64) / 2, FlxG.height - 530, OnReturnClicked, AssetPaths.button_exit__png);
		add(returnButton);
		
		
		//dialogueBox added for first explaning
		box = new DialogueBox((FlxG.width - 500) / 2, 550, "Hint", "This is the level selection screen. Here you can choose the levels you want to play. Click on the first level to begin.", OnExit);
		add(box);
		
		super.create();
	}
	
	function OnExit()
	{
		box.kill();
	}

	function OnReturnClicked()
	{
		FlxG.switchState(new MenuState());
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
