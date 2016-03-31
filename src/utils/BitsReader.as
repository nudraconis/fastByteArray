package utils 
{
	import flash.utils.ByteArray;
	import avm2.intrinsics.memory.li32;
	
	public class BitsReader 
	{
		private var byteArray:FastByteArray;
		
		private var position:int = 0;
		
		private var bitsInBuffer:int = 0;
		private var curentBuffer:int = 0;
		
		private var restBuffer:int = 0;
		private var bitsInRestBuffer:int = 0;
		
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
					var position:int = byteArray._position;
					curentBuffer = li32(position);
					byteArray._position = position + 4;
					//=======HAND INLINE readInt32========
					//curentBuffer = readInt32Inline();
					
					bitsInBuffer = 32;
					position = 0;
				}
				else
				{
					//=======HAND INLINE readInt32========
					var _position:int = byteArray._position;
					curentBuffer = li32(_position);
					byteArray._position = _position + 4;
					//=======HAND INLINE readInt32========
					//curentBuffer = readInt32Inline();
					
					bitsInBuffer = 32;
					
					position = 0;
				}
			}
			
			var returnValue:int;
			
			if (restBuffer != 0)
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
		}
	}
}