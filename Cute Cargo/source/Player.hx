package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class Player extends FlxSprite 
{
	//Ids of which block, which player can move
	public var colorCodeToPlayerID:Array<Array<Int>> = [[11, 1, 10], [101, 1, 100], [110, 10, 100]];
	public var primaryPushableToPlayerID:Array<Array<Int>> = [[1, 10], [1, 100], [10, 100]];
	public var matchingColorID:Array<Int> = [11, 101, 110];
	
	public var playerID:Int;
	public var posX:Int = 0;
	public var posY:Int = 0;
	
	public var prevPosX:Int = 0;
	public var prevPosY:Int = 0;
	
	public var pullingBlockPosX:Int = 0;
	public var pullingBlockPosY:Int = 0;
	
	public var pullingOrientation:MoveOrientation = MoveOrientation.NONE;
		
	public function new(X:Float, Y:Float, _id:Int, pX:Int, pY:Int) 
	{
		super(X, Y);
		playerID = _id;
		posX = pX;
		posY = pY;
		makeGraphic(64, 64, playerID == 0? FlxColor.PURPLE : ( playerID == 1 ? FlxColor.ORANGE : FlxColor.GREEN)); // placeholder colored block
	}
	
	public function movement(currentGrid:Array<Array<Int>>)
	{
		currentGrid[posY][posX] = 0; // reset previous location to air
		
		//buttons
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		_up = FlxG.keys.anyJustPressed([UP, W]);
		_down = FlxG.keys.anyJustPressed([DOWN, S]);
		_left = FlxG.keys.anyJustPressed([LEFT, A]);
		_right = FlxG.keys.anyJustPressed([RIGHT, D]);
		
		if (pullingOrientation == MoveOrientation.UP || pullingOrientation == MoveOrientation.DOWN)
			_left = _right = false;
		if (pullingOrientation == MoveOrientation.LEFT || pullingOrientation == MoveOrientation.RIGHT)
			_up = _down = false;
		
		//button presses
		//checks which button and if the location is within the grid
		if (_up && posY > 0)
		{
			if (pullingOrientation == MoveOrientation.UP)
				pullingOrientation = MoveOrientation.NONE;
				
			Moving(MoveOrientation.UP, currentGrid);
		}
		if (_down && posY < (PlayState.gridSizeY - 1))
		{
			if (pullingOrientation == MoveOrientation.DOWN)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.DOWN, currentGrid);
		}
		if (_left && posX > 0)
		{
			if (pullingOrientation == MoveOrientation.LEFT)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.LEFT, currentGrid);
		}
		if (_right && posX < (PlayState.gridSizeX - 1))
		{
			if (pullingOrientation == MoveOrientation.RIGHT)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.RIGHT, currentGrid);
		}
		
		currentGrid[posY][posX] = playerID + 2; // set current position to a player grid ID
	}

	public function ClickBlock(currentGrid:Array<Array<Int>>)
	{
		var positionClicked:FlxPoint = PlayState.GetGridPositionByScreenSpace(FlxG.mouse.screenX, FlxG.mouse.screenY);
		
		for (i in 0...3)
		{
			if (currentGrid[Std.int(positionClicked.y)][Std.int(positionClicked.x)] == colorCodeToPlayerID[playerID][i])
			{
				if (posX - positionClicked.x == -1)
					pullingOrientation = MoveOrientation.RIGHT;
				if (posX - positionClicked.x == 1)
					pullingOrientation = MoveOrientation.LEFT;
				if (posY - positionClicked.y == -1)
					pullingOrientation = MoveOrientation.DOWN;
				if (posY - positionClicked.y == 1)
					pullingOrientation = MoveOrientation.UP;
				
					trace(pullingOrientation);
					
				if (pullingOrientation != MoveOrientation.NONE)
				{
					pullingBlockPosX = Std.int(positionClicked.x);
					pullingBlockPosY = Std.int(positionClicked.y);
					break;
				}
			}
		}
	}
	
	private function Moving(ori:MoveOrientation, currentGrid:Array<Array<Int>>)
	{
		//this system sets a _x and _y value to the corect value of which way to push/merge
		//by doing this, we only use 1 function, instead of copy-pasting and chaning in the movement() function
		//e.g. moving right will set _x to 1 and _y to 0. now the system knows where to look on the x and y level
		var _x:Int = ori == MoveOrientation.LEFT ? -1 : (ori == MoveOrientation.RIGHT ? 1 : 0);
		var _y:Int = ori == MoveOrientation.DOWN ? 1 : (ori == MoveOrientation.UP ? -1 : 0);
		
		var _x2:Int = ori == MoveOrientation.LEFT ? -2 : (ori == MoveOrientation.RIGHT ? 2 : 0);
		var _y2:Int = ori == MoveOrientation.DOWN ? 2 : (ori == MoveOrientation.UP ? -2 : 0);
		
		prevPosX = posX;
		prevPosY = posY;
		
		if (currentGrid[posY + _y][posX + _x] == 0)
		{
			//moving the player;
			posX += _x;
			posY += _y;
			this.x += 64 * _x;
			this.y += 64 * _y;
			
			if (pullingOrientation != MoveOrientation.NONE)
			{
				currentGrid[prevPosY][prevPosX] = currentGrid[pullingBlockPosY][pullingBlockPosX];
				
				currentGrid[pullingBlockPosY][pullingBlockPosX] = 0;
				
				pullingBlockPosX = prevPosX;
				pullingBlockPosY = prevPosY;
			}
		}
		else
		{
			if (pullingOrientation == MoveOrientation.NONE)
			{
				for (i in 0...3)
				{
					if (currentGrid[posY + _y][posX + _x] == colorCodeToPlayerID[playerID][i]) // check if first block is pushable by player
					{
						if ((ori == MoveOrientation.LEFT && posX + _x2 >= 0) || (ori == MoveOrientation.RIGHT && posX + _x2 <= (PlayState.gridSizeX - 1)) || (ori == MoveOrientation.UP && posY + _y2 >= 0) || (ori == MoveOrientation.DOWN && posY + _y2 <= (PlayState.gridSizeY - 1)))
						{
							if (currentGrid[posY + _y][posX + _x] == colorCodeToPlayerID[playerID][i] && currentGrid[posY + _y2][posX + _x2] == 0) // check if first block is pushable by matching player and if second block is nothing
							{
								currentGrid[posY + _y2][posX + _x2] = currentGrid[posY + _y][posX + _x]; // set second block to the first block
								currentGrid[posY + _y][posX + _x] = 0; // set air
								//moving the player
								posX += _x;
								posY += _y;
								this.x += 64 * _x;
								this.y += 64 * _y;
								break;
							}
							
							for (j in 0...2)
							{
								if (currentGrid[posY + _y][posX + _x] == primaryPushableToPlayerID[playerID][j] && currentGrid[posY + _y2][posX + _x2] != currentGrid[posY + _y][posX + _x]) // check if first block is pushable by matching player and if second block is not the same as the first one
								{
									currentGrid[posY + _y2][posX + _x2] = currentGrid[posY + _y][posX + _x] + currentGrid[posY + _y2][posX + _x2]; // set second block to the merged block
									currentGrid[posY + _y][posX + _x] = 0; // set air
									//moving the player
									posX += _x;
									posY += _y;
									this.x += 64 * _x;
									this.y += 64 * _y;
									break;
								}
							}
						}
					}
				}
			}
		}
	}
}

enum MoveOrientation
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
	NONE;
}