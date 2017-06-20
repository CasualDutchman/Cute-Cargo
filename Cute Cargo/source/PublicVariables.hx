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
}