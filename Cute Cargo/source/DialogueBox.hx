package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class DialogueBox extends FlxGroup
{
	var spr:FlxSprite;
	var titleBox:FlxText;
	var textBox:FlxText;
	var exit:ButtonSmall;
	
	public function new(_x:Float, _y:Float, _title:String, _text:String, ?_onClick:Void->Void) 
	{
		super();
		
		spr = new FlxSprite(_x, _y);
		spr.loadGraphic(AssetPaths.dialogue__png);
		add(spr);
		
		titleBox = new FlxText(_x + 33, _y + 33, 0, _title, 24);
		titleBox.bold = true;
		titleBox.setFormat(AssetPaths.Freshman__ttf, 28, FlxColor.BLACK);
		titleBox.color = FlxColor.BLACK;
		add(titleBox);
		
		textBox = new FlxText(_x + 33, _y + 80, 0, _text, 20);
		textBox.fieldWidth = 420;
		textBox.setFormat(AssetPaths.Freshman__ttf, 28, FlxColor.BLACK);
		textBox.color = FlxColor.BLACK;
		add(textBox);
		
		exit = new ButtonSmall(_x + 410, _y + 15, _onClick, AssetPaths.button_return__png);
		add(exit);
	}
	
	public function SetText(_text:String)
	{
		textBox.text = _text;
	}
	
	public function SetPosition(_x:Float, _y:Float)
	{
		spr.x = _x;
		spr.y = _y;
		titleBox.x = _x + 33;
		titleBox.y = _y + 33;
		textBox.x = _x + 33;
		textBox.y = _y + 80;
		exit.x = _x + 410;
		exit.y = _y + 15;
	}
	
	
	
}