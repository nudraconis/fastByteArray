package fastByteArray 
{
	import flash.utils.ByteArray;
	import avm2.intrinsics.memory.li32;
	
	public class BitsReader 
	{
		public var byteArray:FastByteArray;
		
		public var position:int = 0;
		
		public var bitsInBuffer:int = 0;
		public var curentBuffer:int = 0;
		
		public var restBuffer:int = 0;
		public var bitsInRestBuffer:int = 0;
		
		public function BitsReader(byteArray:FastByteArray) 
		{
			this.byteArray = byteArray;
		}
		
		[Inline]
		public final function readInt32Inline():int
		{
			var position:int = byteArray._position;
			var value:int = li32(position);
			byteArray._position = position + 4;
			
			return value;
		}
		
		[Inline]
		public final function readBits(bits:int):int
		{
			if (bitsInBuffer < bits)
			{
				if (bitsInBuffer != 0)
				{					
					restBuffer = curentBuffer >>> 32 - bitsInBuffer;
					bitsInRestBuffer = bitsInBuffer;
					
					//=======HAND INLINE readInt32========
					var bytePosition:int = byteArray._position;
					curentBuffer = li32(bytePosition);
					byteArray._position = bytePosition + 4;
					//=======HAND INLINE readInt32========
					//curentBuffer = readInt32Inline();
					
					bitsInBuffer = 32//ByteArrayUtils.calculateBits(curentBuffer);
					position = 0;
				}
				else 
				{
					//=======HAND INLINE readInt32========
					var _bytePosition:int = byteArray._position;
					curentBuffer = li32(_bytePosition);
					byteArray._position = _bytePosition + 4;
					//=======HAND INLINE readInt32========
					//curentBuffer = readInt32Inline();
					bitsInBuffer = 32//ByteArrayUtils.calculateBits(curentBuffer);
					
					position = 0;
				}
			}
			
			var returnValue:int;
			
			if (bitsInRestBuffer != 0)
			{
				returnValue = restBuffer;
				bits -= bitsInRestBuffer;
				
				bitsInBuffer -= bits;
				position += bits;
				
				returnValue = (curentBuffer << 32 - position >>> 32 - bits) << bitsInRestBuffer ^ returnValue;
				
				bitsInRestBuffer = 0;
				restBuffer = 0;
			}
			else
			{
				bitsInBuffer -= bits;
				position += bits;
				
				returnValue = curentBuffer << 32 - position >>> 32 - bits;
			}
			
			return returnValue;
		}
		
		[Inline]
		public final function clear():void 
		{
			position = 0;
			
			bitsInBuffer = 0;
			curentBuffer = 0;
			
			restBuffer = 0
			bitsInRestBuffer = 0;
		}
	}
}