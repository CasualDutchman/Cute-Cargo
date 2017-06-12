package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import flixel.FlxSprite;

class SelectionState extends FlxState
{			
	override public function create():Void
	{
		FlxG.camera.zoom = 1.5;
		
		for (i in 0...PublicVariables.levelSizes.length)
		{
			if (i < PublicVariables.levelActiveLevels)
			{
				var button:Button = new Button((FlxG.width - 281) / 2, 370 + (i * 60), i + 1 + "", function clicker()
					{ 	
						var state = new PlayState();
						state.setGridSize(PublicVariables.levelSizes[i].x, PublicVariables.levelSizes[i].y);
						FlxG.switchState(state); 
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
		var box = new DialogueBox((FlxG.width - 500) / 2, 350, "Hint", "This screen will guide you to a level.\nIf a button is dark it can not be pushed, otherwise you can push it to go to that level.");
		add(box);
		
		super.create();
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
