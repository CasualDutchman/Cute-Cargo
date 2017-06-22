package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;

class MenuState extends FlxState
{
	private var buttonPlay:Button;
		
	override public function create():Void
	{
		FlxG.camera.zoom = 1;
		
		//===================================================
		FlxG.sound.playMusic(AssetPaths.POL_metro_short__wav, 0.1); // Lynn
		
		var bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.StartScreen__png);
		add(bg);
		
		var icon = new FlxSprite((FlxG.width - 200) / 2, 150);
		icon.loadGraphic(AssetPaths.logo2__png);
		icon.antialiasing = true;
		//icon.scale.set(2, 2);
		add(icon);
		
		//creating a simple button to go to the game
		buttonPlay = new Button(0, 0, "Play", clickedPlay, true);
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
		FlxG.sound.play(AssetPaths.NFF_menu_04_b__wav, 0.1, false, FlxG.sound.defaultSoundGroup, true, GoToSelect); //Lynn
		
		//FlxG.switchState(new SelectionState());
	}
	
	function GoToSelect()
	{
		FlxG.switchState(new CoachState());
	}
}
