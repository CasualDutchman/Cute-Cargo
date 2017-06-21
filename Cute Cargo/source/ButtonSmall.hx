package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxG;

class ButtonSmall extends FlxButton
{
	public function new(_x:Float = 0, _y:Float = 0, ?_onClick:Void->Void, _imagePath:String, spriteWidth:Int = 64, spriteHeight:Int = 59) 
	{
		super(_x, _y, "", function clicker() { FlxG.sound.play(AssetPaths.NFF_menu_04_b__wav, 0.1); _onClick(); });
		this.loadGraphic(_imagePath, true, spriteWidth, spriteHeight);
		this.setupAnimation("normal", FlxButton.NORMAL);
		this.setupAnimation("pressed", FlxButton.PRESSED);
		this.updateHitbox();
	}
	
}