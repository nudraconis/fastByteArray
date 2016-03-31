package utils 
{
	import ru.crazypanda.core.utils.MathUtils;
	
	public class ByteArrayUtils 
	{
		
		public function ByteArrayUtils() 
		{
			
		}
		
		[Inline]
		public static function calculateBits(value:int):int
		{
			return Math.floor(MathUtils.logBase(value, 2) + 1);
		}
		
		[Inline]
		public static function clampBitsToMaxBytes(value:int):int
		{
			var valueBitsSize:int = calculateBits(value);
			
			if (valueBitsSize < 8)
				return 1;
			else if (valueBitsSize < 17)
				return 2;
			else if (valueBitsSize < 25)
				return 3;
			else if (valueBitsSize < 33)
				return 4;
				
			return 0;
		}
	}
}