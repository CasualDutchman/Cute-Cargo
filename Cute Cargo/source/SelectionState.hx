package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;

class SelectionState extends FlxState
{	
	var maxColumns = 3;
	var buttonCount = 6;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 2;
		
		for (i in 0...buttonCount)
		{
			var button:Button = new Button((FlxG.width - 281) / 2, 370 + (i * 60), i + 1 + "", function clicker()
				{ 	
					var state = new PlayState();
					state.setGridSize(7, Math.floor(5 + (i * 2)));
					FlxG.switchState(state); 
				});
			add(button);
		}
		
		var returnButton:ButtonSmall = new ButtonSmall((FlxG.width - 64) / 2, FlxG.height - 430, OnReturnClicked, AssetPaths.button_exit__png);
		add(returnButton);
		
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
