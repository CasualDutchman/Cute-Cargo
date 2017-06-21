package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.math.FlxPoint;

class MenuState extends FlxState
{
	private var buttonPlay:Button;
	
	var guy:FlxSprite;
	
	override public function create():Void
	{
		FlxG.camera.zoom = 1;
		
		//===================================================
		FlxG.sound.playMusic(AssetPaths.POL_metro_short__wav, 0.1); // Lynn
		
		var bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.StartScreen__png);
		add(bg);
		
		//creating a simple button to go to the game
		buttonPlay = new Button(0, 0, "Play", clickedPlay, true);
		buttonPlay.screenCenter();
		buttonPlay.y += 100;
		
		add(buttonPlay);
		
		guy = new FlxSprite(100, 100);
		guy.loadGraphic(AssetPaths.greenguy_walking__png, true, 80, 80);
		guy.animation.add("Walk", [0, 1, 2, 3, 4, 5], 8);
		guy.animation.play("Walk");
		add(guy);
		
		
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
