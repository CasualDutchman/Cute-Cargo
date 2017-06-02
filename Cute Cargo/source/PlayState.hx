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
	public static var gridStartX:Int = 140 + 45;
	public static var gridStartY:Int = 160 + 40;
	public static var cratePixelSize:Int = 102;
	
	public static var testText:FlxText;
	
	private var crate:FlxSprite;
	private var crateGroup:FlxGroup; // this group manages updating the graphics grid
	
	public var currentMovingPlayer:Int = 0; // who's turn?
	
	public var trainTimer:Float = 0.0;
	public var trainTimerIncrement:Float = 0.0;
	
	private var player1:Player;
	private var player2:Player;
	private var player3:Player;
	private var playerList:Array<Player> = [];
	
	var grass:FlxSprite;
	var grass2:FlxSprite;
	var carrier:FlxSprite;
	
	var carrierBumped:Int = 0;
	var carrierBumpInterval:Float = 10;
	
	override public function create():Void
	{
		CreateBackgroundItems();
		
		CreateGrid();
		
		CreatePlayers();
		
		CreateUI();
		
		trainTimer = 50;
		
		testText = new FlxText(gridStartX - 80, gridStartY + 10, 200, "", 20);
		testText.color = FlxColor.WHITE;
		add(testText);

		super.create();
	}
	
	/**
	 * Update function. Handles UpdateGrid() and player.movement()
	 */
	override public function update(elapsed:Float):Void
	{	
		trainTimer -= (trainTimerIncrement / 60.0);
		trainTimerIncrement = ClampFloat(trainTimerIncrement + (0.02 / 60.0), 0, 1);
		testText.text = Std.int(trainTimer) + "";
		
		if (trainTimer <= 0)
		{
			FlxG.switchState(new MenuState());
		}
		
		UpdateBackGround();
		
		playerList[currentMovingPlayer].movement(crateGrid, this);
		
		#if flash
			UpdateFlash();
		#end
		
		#if mobile
			UpdateAndroid();
		#end
		
		super.update(elapsed);
		
		updateGrid();	
	}
	
	/**
	 * This is the update for all the flash components. e.g. mouse events
	 */
	function UpdateFlash()
	{
		if (FlxG.mouse.justReleased)
			playerList[currentMovingPlayer].ClickBlock(crateGrid, FlxG.mouse.screenX, FlxG.mouse.screenY);
		
		//when SPACE pressed, which currentMovingPlayer
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
	}
	
	/**
	 * This is the update for all the mobile components. e.g. touch events
	 */
	function UpdateAndroid()
	{
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
				playerList[currentMovingPlayer].ClickBlock(crateGrid, touch.x, touch.y);
		}
	}
	
	public function setGridSize(x:Int, y:Int)
	{
		gridSizeX = x;
		gridSizeY = y;
	}
	
	function CreateUI()
	{
		
	}
	
	/**
	 * This creates a grid according to the preferences set at the top
	 */
	private function CreateGrid()
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
	}
	
	/**
	 * Creating all the players
	 */
	function CreatePlayers()
	{
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
	
	/**
	 * Update all background components
	 */
	function UpdateBackGround()
	{
		grass.y += trainTimer;
		grass2.y += trainTimer;
		
		carrierBumpInterval -= (trainTimer / 60.0);
		//testText.text = trainTimerIncrement + " -/- " + Std.int(trainTimer);
		
		if (grass.y >= 1920)
		{
			grass.y = grass2.y - grass.graphic.height;
			grass.loadGraphic(FlxG.random.bool(50) ? AssetPaths.background_2__png : AssetPaths.background__png);
		}
		
		if (grass2.y >= 1920)
		{
			grass2.y = grass.y - grass2.graphic.height;
			grass2.loadGraphic(FlxG.random.bool(50) ? AssetPaths.background_2__png : AssetPaths.background__png);
		}
		
		if (carrierBumped != 0)
		{
			carrier.x -= carrierBumped;
			carrierBumped = 0;
		}
		
		if ((FlxG.random.bool(1) && carrierBumpInterval <= 0) && carrierBumped == 0)
		{
			var variation:Int = FlxG.random.bool(50) ? -7 : 7;
			carrier.x += variation;
			carrierBumpInterval = 100;
			carrierBumped = variation;
		}
	}
	
	/**
	 * Create all background components
	 */
	function CreateBackgroundItems()
	{
		grass = new FlxSprite();
		grass.loadGraphic(AssetPaths.background__png);
		add(grass);
		
		grass2 = new FlxSprite(0, -1920);
		grass2.loadGraphic(AssetPaths.background_2__png);
		add(grass2);
		
		carrier = new FlxSprite(140, 160);
		carrier.loadGraphic(AssetPaths.carrier_wood__png);
		add(carrier);
	}
	
	/**
	 * Get a point on the grid with mouse screen position
	 * @param	_x mouse X position
	 * @param	_y mouse Y position
	 * @return FlxPoint with the grid info
	 */
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
