package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.touch.FlxTouch;
import flixel.ui.FlxVirtualPad;

class PlayState extends FlxState
{
	
	var _text:FlxText;
	var _int:Int;
	var touch1:Float;
	
	override public function create():Void
	{
		_text = new FlxText(0, 0, 0, "0 - 0", 48);
		add(_text);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{	
		#if flash
		_text.text = FlxG.mouse.screenX + " - " + FlxG.mouse.screenY + "";
		#end
		
		#if mobile
		for (touch in FlxG.touches.list){
			if (touch.pressed)
			{
				_text.text = touch.screenX + " - " + touch.screenY + "";
			}
		}
		#end
		super.update(elapsed);
	}
}
