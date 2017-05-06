package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;

class Player extends FlxSprite 
{
	public var colorCodeToPlayerID:Array<Array<Int>> = [[11, 1, 10], [101, 1, 100], [110, 10, 100]];
	
	public var playerID:Int;
	public var posX:Int = 0;
	public var posY:Int = 0;
	
	public function new(X:Float, Y:Float, _id:Int, pX:Int, pY:Int) 
	{
		super(X, Y);
		playerID = _id;
		posX = pX;
		posY = pY;
		makeGraphic(64, 64, playerID == 0? FlxColor.PURPLE : ( playerID == 1 ? FlxColor.ORANGE : FlxColor.GREEN));
	}
	
	public function movement(currentGrid:Array<Array<Int>>)
	{
		currentGrid[posY][posX] = 0;
		
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyJustPressed([UP, W]);
		_down = FlxG.keys.anyJustPressed([DOWN, S]);
		_left = FlxG.keys.anyJustPressed([LEFT, A]);
		_right = FlxG.keys.anyJustPressed([RIGHT, D]);
		
		if (_up && posY > 0 && currentGrid[posY - 1][posX] == 0)
		{
			posY--;
			this.y -= 64;
		}
		if (_down && posY < 7 && currentGrid[posY + 1][posX] == 0)
		{
			posY++;
			this.y += 64;
		}
		if (_left && posX > 0 && currentGrid[posY][posX - 1] == 0)
		{
			posX--;
			this.x -= 64;
		}
		if (_right && posX < 9 && currentGrid[posY][posX + 1] == 0)
		{
			posX++;
			this.x += 64;
		}
		
		currentGrid[posY][posX] = playerID + 2;
	}
	
}