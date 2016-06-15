package fastByteArray 
{
	public class ByteArrayUtils 
	{
		private static const LOG_2:Number = Math.log(2);
		
		public function ByteArrayUtils() 
		{
			
		}
		
		[Inline]
		public static function addBitsValue(mask:uint, value:int):uint
		{
			if (value >= 0)			
				mask |= value;
			else
				mask |= ~value << 1;
				
			return mask;
		}
		
		public static function calculateMaxFixedBits(signed:Boolean, a:Number, b:Number):uint 
		{
			return calculateMaxBits(signed, a * Constants.FIXED_PRECISSION_VALUE, b * Constants.FIXED_PRECISSION_VALUE);
		}
		
		public static function calculateMaxBits(signed:Boolean, a:int, b:int):int 
		{
			
			
			var i:int = 0;
			var bitMask:int = 0;
			var valueMax:int = int.MIN_VALUE;
			
			if (!signed) 
			{
				bitMask = a | b;
			}
			else 
			{
				bitMask = addBitsValue(bitMask, a);
				bitMask = addBitsValue(bitMask, b);
					
				if (valueMax < a)
					valueMax = a;
					
				if (valueMax < b)
					valueMax = b;
			}
			
			var bits:int = 0;
			if (bitMask > 0) 
			{
				bits = calculateBits(bitMask);
				if (signed && valueMax > 0 && calculateBits(valueMax) >= bits) 
				{
					bits++;
				}
			}
			
			return bits;
		}
		
		
		public static function calculateMaxBits4(signed:Boolean, a:int, b:int, c:int, d:int):int 
		{
			var i:int = 0;
			var bitMask:int = 0;
			var valueMax:int = int.MIN_VALUE;
			
			if (!signed) 
			{
				bitMask = a | b | c | d;
			}
			else 
			{
				bitMask = addBitsValue(bitMask, a);
				bitMask = addBitsValue(bitMask, b);
				bitMask = addBitsValue(bitMask, c);
				bitMask = addBitsValue(bitMask, d);
					
				if (valueMax < a)
					valueMax = a;
					
				if (valueMax < b)
					valueMax = b;
					
				if (valueMax < c)
					valueMax = c;
					
				if (valueMax < d)
					valueMax = d;
			}
			
			var bits:int = 0;
			if (bitMask > 0) 
			{
				bits = calculateBits(bitMask);
				if (signed && valueMax > 0 && calculateBits(valueMax) >= bits) 
				{
					bits++;
				}
			}
			
			return bits;
		}
		
		[Inline]
		public static function calculateBits(value:uint):int
		{
			if (value == 0)
				return 1;
				
			return Math.floor((Math.log(uint(value)) / LOG_2) + 1);
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