package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxObject;

class PlayState extends FlxState
{
	public static var crateIDList:Array<Int> = [1, 10, 100, 11, 101, 110];
	
	public var crateGrid:Array<Array<Int>> = new Array<Array<Int>>();
	public var gridSizeX:Int = 10;
	public var gridSizeY:Int = 8;
	
	private var testText:FlxText;
	private var crate:FlxSprite;
	
	private var player1:Player;
	private var player2:Player;
	private var player3:Player;
	
	override public function create():Void
	{
		createGrid(10, 10);
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{	
		player1.movement(crateGrid);
		super.update(elapsed);
	}
	
	private function createGrid(startX:Int, startY:Int)
	{
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{
				if (x == 0)
					crateGrid.push(new Array<Int>());
					
				crateGrid[y][x] = crateIDList[FlxG.random.int(0, 2)];
				
				if (FlxG.random.bool(10))
					crateGrid[y][x] = 0;
				
				if (x < 4 && y < 3)
					crateGrid[y][x] = 0;
			}
		}
		
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{
				//testText = new FlxText(x * 25, y * 20, 0, crateGrid[y][x] + "");
				//add(testText);
				
				if (crateGrid[y][x] != 0)
				{
					crate = new FlxSprite(startX + (x * 64), startY + (y * 64));
					crate.loadGraphic(getAsset(crateGrid[y][x]));
					add(crate);
				}
			}
		}
		
		player1 = new Player(10, 10, 0, 0, 0);
		player1.movement(crateGrid);
		add(player1);
		
		player2 = new Player(10 + 64, 10, 1, 1, 0);
		player2.movement(crateGrid);
		add(player2);
		
		player3 = new Player(10 + 128, 10, 2, 2, 0);
		player3.movement(crateGrid);
		add(player3);
	}
	
	private function updateGrid()
	{
		
	}
	
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
			default: return AssetPaths.red_crate__png;
		}
	}
}
