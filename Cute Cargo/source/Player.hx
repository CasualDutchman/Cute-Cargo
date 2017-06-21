package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.input.FlxSwipe;
import flixel.input.touch.FlxTouch;

class Player extends FlxSprite 
{
	//Ids of which block, which player can move
	public var colorCodeToPlayerID:Array<Array<Int>> = [[11, 1, 10], [101, 1, 100], [110, 10, 100]];
	public var primaryPushableToPlayerID:Array<Array<Int>> = [[1, 10], [1, 100], [10, 100]];
	public var matchingColorID:Array<Int> = [11, 101, 110];
	
	public var movementArray:Array<MoveOrientation> = [];
	public var prevMovement:FlxPoint = new FlxPoint();
	var isMoving:Bool = false;
	
	public var playerID:Int;
	public var posX:Int = 0;
	public var posY:Int = 0;
	
	public var prevPosX:Int = 0;
	public var prevPosY:Int = 0;
	
	public var pullingBlockPosX:Int = 0;
	public var pullingBlockPosY:Int = 0;
	
	public var pullingOrientation:MoveOrientation = MoveOrientation.NONE;
	
	public var sizer:Int;
	
	var movementSteps:Int;
	
	var movementTimer:Float = 0;
	
	var changeCharacter:Bool;
	
	public function new(X:Float, Y:Float, _id:Int, pX:Int, pY:Int) 
	{
		super(X, Y);
		playerID = _id;
		posX = pX;
		posY = pY;
		sizer = PlayState.cratePixelSize;
		loadGraphic(_id == 0 ? AssetPaths.purple_crate__png : (_id == 1 ? AssetPaths.orange_crate__png : AssetPaths.green_crate__png));
		//makeGraphic(sizer, sizer, playerID == 0? FlxColor.PURPLE : ( playerID == 1 ? FlxColor.ORANGE : FlxColor.GREEN)); // placeholder colored block
	}
	
	public function movement(currentGrid:Array<Array<Int>>, state:PlayState)
	{
		currentGrid[posY][posX] = 0; // reset previous location to air
		
		//buttons
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		var positionTouched:FlxPoint = new FlxPoint();
		var isPressing:Bool = false;
		var isReleasing:Bool = false;
		
		//moving
		
		#if flash
		positionTouched = FlxG.mouse.getScreenPosition();
		isPressing = FlxG.mouse.pressed;
		isReleasing = FlxG.mouse.justReleased;
		#end
		
		#if mobile
		for (touch in FlxG.touches.list)
		{
			positionTouched = new FlxPoint(touch.screenX, touch.screenY);
			isPressing = touch.pressed;
			isReleasing = touch.justReleased;
		}
		#end
		
		if (isPressing && !isMoving)
		{
			var mousePoint = PlayState.GetGridPositionByScreenSpace(positionTouched.x, positionTouched.y);
			if (prevMovement.x - mousePoint.x == 0)
			{
				if (prevMovement.y - mousePoint.y == -1)
				{
					movementArray.push(MoveOrientation.DOWN);
					movementSteps++;
					prevMovement = mousePoint;
					
					if (movementSteps >= 10)
					{
						isMoving = true;
						movementSteps = 0;
						movementArray.reverse();
						changeCharacter = true;
					}
				}
				if (prevMovement.y - mousePoint.y == 1)
				{
					movementArray.push(MoveOrientation.UP);
					movementSteps++;
					prevMovement = mousePoint;
					
					if (movementSteps >= 10)
					{
						isMoving = true;
						movementSteps = 0;
						movementArray.reverse();
						changeCharacter = true;
					}
				}
			}
			if (prevMovement.y - mousePoint.y == 0)
			{
				if (prevMovement.x - mousePoint.x == -1)
				{
					movementArray.push(MoveOrientation.RIGHT);
					movementSteps++;
					prevMovement = mousePoint;
					
					if (movementSteps >= 10)
					{
						isMoving = true;
						movementSteps = 0;
						movementArray.reverse();
						changeCharacter = true;
					}
				}
				if (prevMovement.x - mousePoint.x == 1)
				{
					movementArray.push(MoveOrientation.LEFT);  
					movementSteps++;
					prevMovement = mousePoint;
					
					if (movementSteps >= 10)
					{
						isMoving = true;
						movementSteps = 0;
						movementArray.reverse();
						changeCharacter = true;
					}
				}
			}
		}
		else if (isReleasing)
		{
			isMoving = true;
			movementArray.reverse();
			if (!state.hintSystem.firstColorExplain && movementArray.length >= 1)
			{
				state.GiveHint("You can move blocks based on your player's color.");
				state.hintSystem.firstColorExplain = true;
			}
		}
		
		if (isMoving)
		{
			movementTimer += 1.0;
		}
		
		if (isMoving && movementTimer >= (60 * PublicVariables.playerMoveUpdate))
		{
			var todoMovement:MoveOrientation = movementArray.pop();
			
			_up = todoMovement == MoveOrientation.UP;
			_down = todoMovement == MoveOrientation.DOWN;
			_left = todoMovement == MoveOrientation.LEFT;
			_right = todoMovement == MoveOrientation.RIGHT;
			
			movementTimer = 0;
			
			if (movementArray.length <= 0)
			{
				if (changeCharacter)
				{
					state.ChangeActivePlayer();
				}
				
				isMoving = false;
			}
		}
		
		//pulling
		
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
				
			Moving(MoveOrientation.UP, currentGrid, state);
		}
		if (_down && posY < (PlayState.gridSizeY - 1))
		{
			if (pullingOrientation == MoveOrientation.DOWN)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.DOWN, currentGrid, state);
		}
		if (_left && posX > 0)
		{
			if (pullingOrientation == MoveOrientation.LEFT)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.LEFT, currentGrid, state);
		}
		if (_right && posX < (PlayState.gridSizeX - 1))
		{
			if (pullingOrientation == MoveOrientation.RIGHT)
				pullingOrientation = MoveOrientation.NONE;
			
			Moving(MoveOrientation.RIGHT, currentGrid, state);
		}
		
		//currentGrid[posY][posX] = playerID + 2; // set current position to a player grid ID
	}

	public function ClickBlock(currentGrid:Array<Array<Int>>, clickX:Int, clickY:Int)
	{
		var positionClicked:FlxPoint = PlayState.GetGridPositionByScreenSpace(clickX, clickY);
		
		if (pullingOrientation != MoveOrientation.NONE && positionClicked.x == pullingBlockPosX && positionClicked.y == pullingBlockPosY)
		{
			pullingOrientation = MoveOrientation.NONE;
			return;
		}
		
		for (i in 0...3)
		{
			if (currentGrid[Std.int(positionClicked.y)][Std.int(positionClicked.x)] == colorCodeToPlayerID[playerID][i])
			{
				if (posX - positionClicked.x == -1 && posY - positionClicked.y == 0)
					pullingOrientation = MoveOrientation.RIGHT;
				if (posX - positionClicked.x == 1 && posY - positionClicked.y == 0)
					pullingOrientation = MoveOrientation.LEFT;
				if (posY - positionClicked.x == 0 && posX - positionClicked.y == -1)
					pullingOrientation = MoveOrientation.DOWN;
				if (posY - positionClicked.x == 0 && posX - positionClicked.y == 1)
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
	
	private function Moving(ori:MoveOrientation, currentGrid:Array<Array<Int>>, state:PlayState)
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
		
		if (currentGrid[posY + _y][posX + _x] == 0) //If the spot is empty
		{
			//moving the player;
			MovePlayer(_x, _y, state, currentGrid);
			
			if (pullingOrientation != MoveOrientation.NONE)
			{
				currentGrid[prevPosY][prevPosX] = currentGrid[pullingBlockPosY][pullingBlockPosX];
				
				currentGrid[pullingBlockPosY][pullingBlockPosX] = 0;
				
				pullingBlockPosX = prevPosX;
				pullingBlockPosY = prevPosY;
			}
		}
		else if (currentGrid[posY + _y][posX + _x] == 12) // if the spot is coal
		{
			state.AddCoal(PublicVariables.coalAddValue);
			
			MovePlayer(_x, _y, state, currentGrid);
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
								
								MovePlayer(_x, _y, state, currentGrid);
								break;
							}
							
							for (j in 0...2)
							{
								if (currentGrid[posY + _y][posX + _x] == primaryPushableToPlayerID[playerID][j] && currentGrid[posY + _y2][posX + _x2] != currentGrid[posY + _y][posX + _x] && currentGrid[posY + _y2][posX + _x2] != 12) // check if first block is pushable by matching player and if second block is not the same as the first one
								{
									currentGrid[posY + _y2][posX + _x2] = currentGrid[posY + _y][posX + _x] + currentGrid[posY + _y2][posX + _x2]; // set second block to the merged block
									currentGrid[posY + _y][posX + _x] = 0; // set air
									//moving the player
									
									MovePlayer(_x, _y, state, currentGrid);
									break;
								}
							}
						}
					}
					else{
						if (!state.hintSystem.BasedColor)
						{
							state.hintSystem.BasedColorTimer++;
							if (state.hintSystem.BasedColorTimer >= 5)
							{
								state.GiveHint("You won't be able to move those blocks, because they are not based on your color");
								state.hintSystem.BasedColor = true;
							}
						}
					}
				}
			}
		}
	}
	
	function MovePlayer(_x:Int, _y:Int, state:PlayState, currentGrid:Array<Array<Int>>)
	{
		posX += _x;
		posY += _y;
		this.x += sizer * _x;
		this.y += sizer * _y;
		prevMovement = new FlxPoint(posX, posY);
		
		currentGrid[posY][posX] = playerID + 2;
		
		state.updateGrid();
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