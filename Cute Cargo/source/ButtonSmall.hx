package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxG;

class ButtonSmall extends FlxButton
{
	public function new(_x:Float = 0, _y:Float = 0, ?_onClick:Void->Void, _imagePath:String) 
	{
		super(_x, _y, "", function clicker() { FlxG.sound.play(AssetPaths.NFF_bump__wav); _onClick(); });
		this.loadGraphic(_imagePath, true, 64, 59);
		this.setupAnimation("normal", FlxButton.NORMAL);
		this.setupAnimation("pressed", FlxButton.PRESSED);
		this.updateHitbox();
	}
	
}