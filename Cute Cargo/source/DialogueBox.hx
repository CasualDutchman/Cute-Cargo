package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class DialogueBox extends FlxGroup
{
	var spr:FlxSprite;
	var textBox:FlxText;
	var exit:ButtonSmall;
	
	public function new(_x:Float, _y:Float, _text:String, ?_onClick:Void->Void, spritename:String = AssetPaths.CoachSpeech_03__png, hasButton:Bool = true) 
	{
		super();
		
		spr = new FlxSprite(_x, _y);
		spr.loadGraphic(spritename);
		add(spr);
		
		textBox = new FlxText(_x + 24, _y + 24, 0, _text, 16);
		textBox.fieldWidth = 270;
		textBox.setFormat(AssetPaths.ChateaudeGarage_FREE_FOR_PERSONAL_USE_ONLY__ttf, 22, FlxColor.BLACK);
		textBox.color = FlxColor.BLACK;
		add(textBox);
		
		if (hasButton)
		{
			exit = new ButtonSmall(_x + 256, _y + 246, _onClick, AssetPaths.button_coach_cont__png, 42, 41);
			add(exit);
		}
	}
	
	public function SetText(_text:String)
	{
		textBox.text = _text;
	}
	
	public function SetPosition(_x:Float, _y:Float)
	{
		spr.x = _x;
		spr.y = _y;
		textBox.x = _x + 24;
		textBox.y = _y + 24;
		exit.x = _x + 256;
		exit.y = _y + 247;
	}
	
	
	
}