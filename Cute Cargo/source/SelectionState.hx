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
		FlxG.camera.zoom = 5;
		
		for (i in 0...buttonCount)
		{
			var button:FlxButton = new FlxButton((FlxG.width - 80) / 2, 800 + (i * 60), i + 1 + "", function clicker()
				{ 	
					var state = new PlayState();
					state.setGridSize(7, Math.floor(5 + (i * 2)));
					FlxG.switchState(state); 
				});
			add(button);
		}
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
