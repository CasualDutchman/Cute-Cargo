package;

import flixel.math.FlxPoint;

class PublicVariables 
{
	public static var UseDebug:Bool = false;
	
	/** Amount of time it takes to change to the new spot in the array, in seconds */
	public static var playerMoveUpdate:Float = 0.2;
	
	/** Speed at which the train starts */
	public static var trainStartSpeed:Int = 50;
	
	/** Max speed of the train || 0 if there is no limit */
	public static var trainMaxSpeed:Int = 120;
	
	/** Speed increment handles in what pace the train slows down. This number will be added to itself, and that number will be subtracted from the speed*/
	public static var trainIncrement:Float = 0.02;
	
	/** Max increment, read description of tranIncrement of what it does*/
	public static var trainMaxIncrement:Float = 1;
	
	/** Amount of speed added tot he train after picking up coal */
	public static var coalAddValue:Float = 30;
	
	/** Level available*/
	public static var levelActiveLevels:Int = 3;
	
	/** Array of level sizes */
	public static var levelSizes:Array<FlxPoint> = [new FlxPoint(7, 5), new FlxPoint(7, 6), new FlxPoint(7, 8), new FlxPoint(7, 9), new FlxPoint(7, 11), new FlxPoint(7, 12)]; 
	
	//Coach lines
	public static var coachSelectionHint:String = "This is the level selection screen. Here you can choose the levels you want to play. Click on the first level to start the game.";
	public static var coachMovementExplain:String = "Move by making a path with your fingers. You have a limited amout of steps, so watch out!";
	public static var coachColorHint:String = "You can move cargo based on your player's colour.";
	public static var coachPullHint:String = "When standing next to cargo, try pulling it towards you.";
	public static var coachBlockedHint:String = "You can't move this cargo, because it is not based on your colour.";
	
	public static var coachCoalReward:String = "Good job! You found coal.";
	
	public static function coachHurryUp(needed:Int):String { return 'Hurry up, the train is slowing down. You need $needed coal!'; }
}