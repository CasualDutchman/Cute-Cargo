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
	
	override public function create():Void
	{
		createGrid();
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
	}
	
	private function createGrid()
	{
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{
				if (x == 0)
					crateGrid.push(new Array<Int>());
					
				crateGrid[y][x] = crateIDList[FlxG.random.int(0, 2)];
			}
		}
		
		for (y in 0...gridSizeY)
		{
			for (x in 0...gridSizeX)
			{
				testText = new FlxText(x * 25, y * 20, 0, crateGrid[y][x] + "");
				add(testText);
			}
		}
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
