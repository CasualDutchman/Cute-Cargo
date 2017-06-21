package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

import flixel.FlxG;

class Button extends FlxButton
{
	public function new(_x:Float = 0, _y:Float = 0, _text:String, ?_onClick:Void->Void, hasSound:Bool = false) 
	{
		super(_x, _y, _text, function clicker() { if(!hasSound) { FlxG.sound.play(AssetPaths.NFF_menu_04_b__wav, 0.1); } _onClick(); });
		this.loadGraphic(AssetPaths.button__png, true, 281, 64);
		this.setupAnimation("normal", FlxButton.NORMAL);
		this.setupAnimation("pressed", FlxButton.PRESSED);
		this.updateHitbox();
		this.label.offset.y -= 11;
		this.label.setFormat(AssetPaths.ChateaudeGarage_FREE_FOR_PERSONAL_USE_ONLY__ttf, 28, FlxColor.BLACK);
	}
	
}