package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Button extends FlxButton
{
	public function new(_x:Float = 0, _y:Float = 0, _text:String, ?_onClick:Void->Void) 
	{
		super(_x, _y, _text, _onClick);
		this.loadGraphic(AssetPaths.button__png, true, 281, 64);
		this.setupAnimation("normal", FlxButton.NORMAL);
		this.setupAnimation("pressed", FlxButton.PRESSED);
		this.updateHitbox();
		this.label.offset.y -= 15;
		this.label.setFormat(AssetPaths.Freshman__ttf, 28, FlxColor.BLACK);
	}
	
}