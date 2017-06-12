package;

class MathHelper 
{
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