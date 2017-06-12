package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class DialogueBox extends FlxGroup
{

	public function new(_x:Float, _y:Float, _title:String, _text:String) 
	{
		super();
		
		var spr = new FlxSprite(_x, _y);
		spr.loadGraphic(AssetPaths.dialogue__png);
		add(spr);
		
		var titleBox = new FlxText(_x + 33, _y + 33, 0, _title, 24);
		//titleBox.addFormat(new FlxTextFormat(FlxColor.BLACK, true));
		titleBox.bold = true;
		titleBox.color = FlxColor.BLACK;
		add(titleBox);
		
		var textBox = new FlxText(_x + 33, _y + 80, 0, _text, 20);
		textBox.fieldWidth = 420;
		textBox.color = FlxColor.BLACK;
		add(textBox);
		
		var exit = new ButtonSmall(_x + 410, _y + 15, OnExit, AssetPaths.button_return__png);
		add(exit);
	}
	
	function OnExit()
	{
		kill();
	}
	
}