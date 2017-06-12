package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class DialogueBox extends FlxGroup
{

	public function new(_x:Float, _y:Float, _text:String) 
	{
		super();
		
		//var spr = new FlxSprite(_x, _y);
		//spr.makeGraphic(100, 100);
		//add(spr);
		
		var textBox = new FlxText(_x, _y, 0, _text, 12);
		textBox.color = FlxColor.WHITE;
		add(textBox);
	}
	
}