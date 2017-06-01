package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.system.FlxAssets;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	//crate color ID's (red, blue, yellow, purple, orange, green)
	public static var crateIDList:Array<Int> = [1, 10, 100, 11, 101, 110];
	
	public var crateGrid:Array<Array<Int>> = new Array<Array<Int>>();
	//grid preferences, size, starting x y in game
	public static var gridSizeX:Int = 8;
	public static var gridSizeY:Int = 5;
	public static var gridStartX:Int = 80;
	public static var gridStartY:Int = 80;
	public static var cratePixelSize:Int = 64;
	
	public static var testText:FlxText;
	
	private var crate:FlxSprite;
	private var crateGroup:FlxGroup; // this group manages updating the graphix grid
	
	public var currentMovingPlayer:Int = 0; // who's turn?
	
	public var trainTimer:Float = 0.0;
	public var trainTimerIncrement = 0.001;
	
	private var player1:Player;
	private var player2:Player;
	private var player3:Player;
	private var playerList:Array<Player> = [];
	
	override public function create():Void
	{
		gridStartX = Std.int((FlxG.width - (gridSizeX * cratePixelSize)) / 2);
		gridStartY = Std.int((FlxG.height - (gridSizeY * cratePixelSize)) / 2);
		
		var zoomX = FlxG.width / (gridSizeX * cratePixelSize);
		var zoomY = FlxG.height / (gridSizeY * cratePixelSize);
		
		FlxG.camera.zoom = zoomX > zoomY ? zoomY : zoomX;
		createGrid();
		
		trainTimer = 75;
		
		testText = new FlxText(gridStartX - 80, gridStartY + 10, 200, "", 20);
		testText.color = FlxColor.WHITE;
		add(testText);
		
		//testText = new FlxText(FlxG.width - 280, 20, 0, "[Space] next player\n[R] reset", 20);
		//add(testText);

		super.create();
	}
	
	/**
	 * Update function. Handles UpdateGrid() and player.movement()
	 */
	override public function update(elapsed:Float):Void
	{	
		trainTimer -= trainTimerIncrement;
		trainTimerIncrement = ClampFloat(trainTimerIncrement, trainTimerIncrement + 0.000001, 0.35);
		testText.text = Std.int(trainTimer) + "";
		
		if (trainTimer <= 0)
		{
			FlxG.switchState(new MenuState());
		}
		
		playerList[currentMovingPlayer].movement(crateGrid, this);
		
		#if flash
		if (FlxG.mouse.justPressed)
			playerList[currentMovingPlayer].ClickBlock(crateGrid, FlxG.mouse.screenX, FlxG.mouse.screenY);
		#end
		
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			playerList[currentMovingPlayer].ClickBlock(crateGrid, touch.x, touch.y);
		}	
		#end
		
		//when SPACE pressed, which currentMovingPlayer
		#if flash
		if (FlxG.keys.anyJustPressed([SPACE]))
		{
			currentMovingPlayer++;
			if (currentMovingPlayer >= 3)
				currentMovingPlayer = 0;
		}
		
		//when R pressed, reset current level
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.resetState();
		
		//when escape is pressed, go to first screen
		if (FlxG.keys.anyJustPressed([ESCAPE]))
			FlxG.switchState(new MenuState());
		
		#end
		
		super.update(elapsed);
		
		updateGrid();	
	}
	
	public function setGridSize(x:Int, y:Int)
	{
		gridSizeX = x;
		gridSizeY = y;
	}
	
	/**
	 * This crates players and a grid according to the preferences set at the top
	 */
	private function createGrid()
	{
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{
				if (x == 0)
					crateGrid.push(new Array<Int>());
					
				crateGrid[y][x] = crateIDList[FlxG.random.int(0, 2)];
				
				if (FlxG.random.bool(10))
				{
					crateGrid[y][x] = 12; // coal
				}
				
				if (FlxG.random.bool(20))
					crateGrid[y][x] = 0; // empty
				
				if (x < 4 && y < 3)
					crateGrid[y][x] = 0; // empty space around players
			}
		}
		
		crateGroup = new FlxGroup();
		
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{				
				if (crateGrid[y][x] != 0)
				{
					crate = new FlxSprite(gridStartX + (x * cratePixelSize), gridStartY + (y * cratePixelSize));
					crate.loadGraphic(getAsset(crateGrid[y][x]));
					crateGroup.add(crate);
				}
			}
		}
		
		player1 = new Player(gridStartX, gridStartY, 0, 0, 0);
		player1.movement(crateGrid, this);
		add(player1);
		
		player2 = new Player(gridStartX + cratePixelSize, gridStartY, 1, 1, 0);
		player2.movement(crateGrid, this);
		add(player2);
		
		player3 = new Player(gridStartX + (cratePixelSize * 2), gridStartY, 2, 2, 0);
		player3.movement(crateGrid, this);
		add(player3);
		
		playerList.push(player1);
		playerList.push(player2);
		playerList.push(player3);
	}
	
	public static function GetGridPositionByScreenSpace(_x:Int, _y:Int):FlxPoint
	{
		_x -= gridStartX;
		_y -= gridStartY;
		
		var xOnGrid = Math.floor(_x / cratePixelSize);
		var yOnGrid = Math.floor(_y / cratePixelSize);
		
		xOnGrid = ClampInt(xOnGrid, 0, gridSizeX - 1);
		yOnGrid = ClampInt(yOnGrid, 0, gridSizeY - 1);
		
		return new FlxPoint(xOnGrid, yOnGrid);
	}
	
	/**
	 * Updates the graphics of the grid
	 */
	private function updateGrid()
	{
		crateGroup.destroy();
		
		crateGroup = new FlxGroup();
		
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{				
				if (crateGrid[y][x] != 0 && crateGrid[y][x] != 2 && crateGrid[y][x] != 3 && crateGrid[y][x] != 4)
				{
					crate = new FlxSprite(gridStartX + (x * cratePixelSize), gridStartY + (y * cratePixelSize));
					crate.loadGraphic(getAsset(crateGrid[y][x]));
					crateGroup.add(crate);
				}
			}
		}
		
		add(crateGroup);
	}
	
	/**
	 * What asset to use for different ID crates
	 */
	private function getAsset(id:Int):FlxGraphicAsset
	{
		switch(id)
		{
			case 1: return AssetPaths.red_crate__png;
			case 10: return AssetPaths.blue_crate__png;
			case 100: return AssetPaths.yellow_crate__png;
			case 11: return AssetPaths.purple_crate__png;
			case 101: return AssetPaths.orange_crate__png;
			case 110: return AssetPaths.green_crate__png;
			case 12: return AssetPaths.coal__png;
			default: return AssetPaths.red_crate__png;
		}
	}
	
	public static function ClampInt(value:Int, min:Int, max:Int):Int
	{		
		if (value < min)
		{
			return min;
		}
		else if (value > max)
		{
			return max;
		}
		else
		{
			return value;
		}
	}
	
	public static function ClampFloat(value:Float, min:Float, max:Float):Float
	{		
		if (value < min)
		{
			return min;
		}
		else if (value > max)
		{
			return max;
		}
		else
		{
			return value;
		}
	}
}
