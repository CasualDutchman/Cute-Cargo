package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.system.FlxSoundGroup;
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
	public static var gridStartX:Int = 120;
	public static var gridStartY:Int = 165;
	public static var cratePixelSize:Int = 80;
	
	public static var testText:FlxText;
	
	private var crate:FlxSprite;
	private var crateGroup:FlxGroup; // this group manages updating the graphics grid
	
	public var currentMovingPlayer:Int = 0; // who's turn?
	
	public var trainTimer:Float = 0.0;
	var maxTrainTimer:Float;
	public var trainTimerIncrement:Float = 0.0;
	
	private var player1:Player;
	private var player2:Player;
	private var player3:Player;
	private var playerList:Array<Player> = [];
	
	var grass:Array<FlxSprite> = new Array<FlxSprite>();
	var carrier:FlxSprite;
	
	var carrierBumped:Int = 0;
	var carrierBumpInterval:Float = 10;
	
	//Debug options
	private var debugGridText:FlxGroup;
	private var debugText:FlxText;
	
	var hints:DialogueBox;
	var hinttimer:Float = 0;
	var showHint:Bool;
	var bigHint:Bool;
	
	public var hintSystem:HintSystem;
	
	var coalCounter:Int;
	var coalMax:Int;
	var coalCounterSprite:FlxSprite;
	var coalCounterText:FlxText;
	var walkCounterSprite:FlxSprite;
	var walkCounterText:FlxText;
	
	var speedClock:FlxSprite;
	var speedClockArrow:FlxSprite;
	
	var activePlayerSprite:Array<FlxSprite> = [];
	
	override public function create():Void
	{
		CreateBackgroundItems();
		
		CreateGrid();
		
		CreatePlayers();
		
		if (PublicVariables.UseDebug)
		{
			testText = new FlxText(gridStartX - 80, gridStartY + 10, 200, "", 20);
			testText.color = FlxColor.WHITE;
			add(testText); 
		}

		hintSystem = new HintSystem();
		
		updateGrid();
		
		CreateUI();
		
		GiveHint(PublicVariables.coachMovementExplain, true);
		
		super.create();
	}
	
	/**
	 * Update function. Handles UpdateGrid() and player.movement()
	 */
	override public function update(elapsed:Float):Void
	{	
		if (!bigHint)
		{
			trainTimer -= (trainTimerIncrement / 60.0);
			trainTimerIncrement = MathHelper.ClampFloat(trainTimerIncrement + (PublicVariables.trainIncrement / 60.0), 0, PublicVariables.trainMaxIncrement);
		}
		
		if (trainTimer <= 20 && !hintSystem.warnedSpeed)
		{
			GiveHint(PublicVariables.coachHurryUp(coalMax - coalCounter));
			hintSystem.warnedSpeed = true;
		}
		
		
		
		if (trainTimer <= 0)
		{
			hints.destroy();
			bigHint = true;
			hints = new DialogueBox((FlxG.width  - 420) / 2, 300, "You were too late. You did not grab the coal, please try again.", OnExit);
			add(hints);
		}
		
		UpdateBackGround();
		
		UpdateUI();
		
		if(!bigHint)
			playerList[currentMovingPlayer].movement(crateGrid, this);
		
		if(PublicVariables.UseDebug)
			testText.text = trainTimer + " / " + maxTrainTimer + "";
		
		if(PublicVariables.UseDebug)
			//debugText.text = playerList[currentMovingPlayer].prevMovement + " - (" + playerList[currentMovingPlayer].posX + " - " + playerList[currentMovingPlayer].posY + ")";
		
		#if flash
			UpdateFlash();
		#end
		
		#if mobile
			UpdateAndroid();
		#end
		
		super.update(elapsed);
		
	}
	
	public function AddToMaxTime(i:Int)
	{
		maxTrainTimer = PublicVariables.trainStartSpeed + i;
		trainTimer = maxTrainTimer;
	}
	
	public function AddCoal(value:Float)
	{
		trainTimer += value;
		if (trainTimer >= maxTrainTimer)
		{
			trainTimer = maxTrainTimer;
		}
		trainTimerIncrement = 0.00001;
		
		FlxG.sound.play(AssetPaths.NFF_coin_04__wav, 0.1);
		
		GiveHint(PublicVariables.coachCoalReward);
		hintSystem.CoalHint = true;
		
		coalCounter++;
	}
	
	/**
	 * This is the update for all the flash components. e.g. mouse events
	 */
	function UpdateFlash()
	{
		#if flash
		if (FlxG.mouse.justReleased)
			//playerList[currentMovingPlayer].ClickBlock(crateGrid, FlxG.mouse.screenX, FlxG.mouse.screenY);
		
		//when SPACE pressed, which currentMovingPlayer
		if (FlxG.keys.anyJustPressed([SPACE]))
		{
			ChangeActivePlayer();
		}
		
		//when R pressed, reset current level
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.resetState();
		
		//when escape is pressed, go to first screen
		if (FlxG.keys.anyJustPressed([ESCAPE]))
			FlxG.switchState(new MenuState());
		
		#end
	}
	
	/**
	 * This is the update for all the mobile components. e.g. touch events
	 */
	function UpdateAndroid()
	{
		for (touch in FlxG.touches.list)
		{			
			if (touch.justPressed){}
				//playerList[currentMovingPlayer].ClickBlock(crateGrid, touch.x, touch.y);
		}
	}
	
	public function setGridSize(x:Float, y:Float)
	{
		gridSizeX = Std.int(x);
		gridSizeY = Std.int(y);
	}
	
	/**
	 * Give a hint tot he player
	 */
	public function GiveHint(_text:String, BIG:Bool = false)
	{	
		hints.destroy();
		if (BIG)
		{
			bigHint = true;
			hints = new DialogueBox((FlxG.width  - 420) / 2, 300, _text, OnDialogueBox);
			add(hints);
			//hints.SetPosition((FlxG.width  - 420) / 2, 300);
		}
		else
		{
			hints = new DialogueBox((FlxG.width  - 400) / 2, FlxG.height - 350, _text, OnDialogueBox, AssetPaths.SpeechBubbleSmallNew_03__png, false);
			add(hints);
			//hints.SetPosition((FlxG.width  - 420) / 2, FlxG.height - 250);
		}
		showHint = !BIG;
	}
	
	/**
	 * Creating the UI components
	 */
	function CreateUI()
	{
		activePlayerSprite.push(new FlxSprite((FlxG.width - 270) / 2, FlxG.height - 120));
		activePlayerSprite[0].loadGraphic(AssetPaths.PurpleBig_03__png);
		activePlayerSprite[0].scale.set(1.2, 1.2);
		add(activePlayerSprite[0]);
		
		activePlayerSprite.push(new FlxSprite(((FlxG.width - 270) / 2) + 90, FlxG.height - 120));
		activePlayerSprite[1].loadGraphic(AssetPaths.YellowBig_03__png);
		activePlayerSprite[1].scale.set(.7, .7);
		add(activePlayerSprite[1]);
		
		activePlayerSprite.push(new FlxSprite(((FlxG.width - 270) / 2) + 180, FlxG.height - 120));
		activePlayerSprite[2].loadGraphic(AssetPaths.GreenBig_03__png);
		activePlayerSprite[2].scale.set(.7, .7);
		add(activePlayerSprite[2]);
		
		hints = new DialogueBox((FlxG.width  - 420) / 2, FlxG.height + 10, "", OnDialogueBox);
		add(hints);
		
		coalCounterSprite = new FlxSprite(FlxG.width - 170, 33);
		coalCounterSprite.loadGraphic(AssetPaths.coalCounter__png);
		add(coalCounterSprite);
		
		coalCounterText = new FlxText(FlxG.width - 170 + 85, 33 + 20, 0, "", 24);
		coalCounterText.text = coalCounter + "/" + coalMax + "";
		coalCounterText.setFormat(AssetPaths.ChateaudeGarage_FREE_FOR_PERSONAL_USE_ONLY__ttf, 24, FlxColor.BLACK);
		add(coalCounterText);
		
		walkCounterSprite = new FlxSprite(17, 37);
		walkCounterSprite.loadGraphic(AssetPaths.FeetButton_03__png);
		add(walkCounterSprite);
		
		walkCounterText = new FlxText(20 + 17, 33 + 20, 0, "", 24);
		walkCounterText.setFormat(AssetPaths.ChateaudeGarage_FREE_FOR_PERSONAL_USE_ONLY__ttf, 24, FlxColor.BLACK);
		add(walkCounterText);
		
		speedClock = new FlxSprite((FlxG.width - 103) / 2, 20);
		speedClock.loadGraphic(AssetPaths.NewClock_03__png);
		add(speedClock);
		
		speedClockArrow = new FlxSprite((FlxG.width - 103) / 2, 20);
		speedClockArrow.antialiasing = true;
		speedClockArrow.loadGraphic(AssetPaths.Arrow_03__png);
		add(speedClockArrow);
		
		var infoButton = new ButtonSmall(40, FlxG.height - 90, SupplyInformation, AssetPaths.button_info__png);
		add(infoButton);
		
		var exitButton = new ButtonSmall(FlxG.width - 40 - 64, FlxG.height - 90, OnExit, AssetPaths.button_return__png);
		add(exitButton);
		
		if (PublicVariables.UseDebug)
		{
			debugText = new FlxText(0, 0, 0, "", 20);
			add(debugText);
		}
	}
	
	function OnExit()
	{
		for (sound in FlxG.sound.defaultMusicGroup.sounds)
		{
			sound.stop();
		}
		var newstate = new SelectionState();
		newstate.addHint = false;
		FlxG.switchState(newstate);
	}
	
	function SupplyInformation()
	{
		GiveHint("This option is under construction, please try again later.", true);
	}
	
	/**
	 * Change the current moving player
	 */
	public function ChangeActivePlayer()
	{
		currentMovingPlayer++;
		if (currentMovingPlayer >= 3)
			currentMovingPlayer = 0;
			
		for (i in 0...3)
		{
			activePlayerSprite[i].scale.set(i == currentMovingPlayer ? 1.2 : .7, i == currentMovingPlayer ? 1.2 : .7);
		}
		
		playerList[currentMovingPlayer].prevMovement.set(playerList[currentMovingPlayer].posX, playerList[currentMovingPlayer].posY);
	}
	
	/**
	 * updating the UI components
	 */
	function UpdateUI()
	{
		if (showHint && !bigHint)
		{
			hinttimer += 1 / 60;
			
			if (hinttimer >= 5)
			{
				OnDialogueBox();
				hinttimer = 0;
				showHint = false;
			}
		}
		
		if (coalCounter >= 3)
		{
			hints.destroy();
			bigHint = true;
			hints = new DialogueBox((FlxG.width  - 420) / 2, 300, "You got all 3 coal, congratulations!", OnExit);
			add(hints);
		}
		
		walkCounterText.text = 10 - playerList[currentMovingPlayer].movementSteps + "";
		
		coalCounterText.text = coalCounter + "/" + coalMax + "";
		
		speedClockArrow.angle = 360 * (trainTimer / maxTrainTimer);
		
	}
	
	/**
	 * rest dialogueBox
	 */
	function OnDialogueBox()
	{
		bigHint = false;
		hints.kill();
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
				
				if (x < 4 && y < 3)
				{
					crateGrid[y][x] = 0; // empty space around players
				}
				else if ((x == gridSizeX - 1 && y == 0) || (x == 0 && y == gridSizeY - 1) || (x == gridSizeX - 1 && y == gridSizeY - 1))
				{
					crateGrid[y][x] = 12; // coal
					coalMax++;
				}
				else if (FlxG.random.bool(20))
				{
					crateGrid[y][x] = 0; // empty
				}	
			}
		}
		
		crateGroup = new FlxGroup();
		debugGridText = new FlxGroup();
		
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
		grass[0].y += trainTimer / 4;
		grass[1].y += trainTimer / 4;
		
		carrierBumpInterval -= (trainTimer / 60.0);
		
		if (grass[0].y >= 1280)
		{
			grass[0].y = grass[1].y - grass[0].graphic.height;
			grass[0].loadGraphic(FlxG.random.bool(50) ? AssetPaths.Level_1_Main__png : AssetPaths.Level_1_Main__png);
		}
		
		if (grass[1].y >= 1280)
		{
			grass[1].y = grass[0].y - grass[1].graphic.height;
			grass[1].loadGraphic(FlxG.random.bool(50) ? AssetPaths.Level_1_Main__png : AssetPaths.Level_1_Main__png);
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
			
			FlxG.sound.play(AssetPaths.NFF_bump__wav, 0.1);
		}
	}
	
	/**
	 * Create all background components
	 */
	function CreateBackgroundItems()
	{		
		grass.push(new FlxSprite());
		grass[0].loadGraphic(AssetPaths.Level_1_Main__png);
		add(grass[0]);
		
		grass.push(new FlxSprite(0, -grass[0].height));
		grass[1].loadGraphic(AssetPaths.Level_1_Main__png);
		add(grass[1]);
		
		carrier = new FlxSprite(100, 140);
		carrier.loadGraphic(AssetPaths.WoodMain__png);
		add(carrier);
		
		FlxG.sound.playMusic(AssetPaths.POL_train_cabin_short__wav, 0.1);
		FlxG.sound.play(AssetPaths.POL_metro_short__wav, 0.1, true);
	}
	
	/**
	 * Get a point on the grid with mouse screen position
	 * @param	_x mouse X position
	 * @param	_y mouse Y position
	 * @return FlxPoint with the grid info
	 */
	public static function GetGridPositionByScreenSpace(_x:Float, _y:Float):FlxPoint
	{
		_x -= gridStartX;
		_y -= gridStartY;
		
		var xOnGrid = Math.floor(_x / cratePixelSize);
		var yOnGrid = Math.floor(_y / cratePixelSize);
		
		xOnGrid = MathHelper.ClampInt(xOnGrid, 0, gridSizeX - 1);
		yOnGrid = MathHelper.ClampInt(yOnGrid, 0, gridSizeY - 1);
		
		return new FlxPoint(xOnGrid, yOnGrid);
	}
	
	/**
	 * Updates the graphics of the grid
	 */
	public function updateGrid()
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
		
		if (PublicVariables.UseDebug)
		{
			debugGridText.destroy();
			
			debugGridText = new FlxGroup();
			
			for (y in 0...gridSizeY)
			{
				for (x in 0...gridSizeX)
				{				
					var newText = new FlxText(gridStartX + (x * cratePixelSize), gridStartY + (y * cratePixelSize), 0, crateGrid[y][x] + "", 24);
					debugGridText.add(newText);
				}
			}
			
			add(debugGridText);
		}
	}
	
	/**
	 * What asset to use for different ID crates
	 */
	private function getAsset(id:Int):FlxGraphicAsset
	{
		switch(id)
		{
			case 1: return AssetPaths.red_block__png;
			case 10: return AssetPaths.blue_block__png;
			case 100: return AssetPaths.yellow_block__png;
			case 11: return AssetPaths.purple_block__png;
			case 101: return AssetPaths.orange_block__png;
			case 110: return AssetPaths.green_block__png;
			case 12: return AssetPaths.Coal8080_03__png;
			default: return AssetPaths.red_block__png;
		}
	}
	
	
}
