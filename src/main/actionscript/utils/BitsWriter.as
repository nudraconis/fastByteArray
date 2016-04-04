package utils 
{
	import flash.utils.ByteArray;
	import avm2.intrinsics.memory.si32;
	
	public class BitsWriter 
	{
		private var currentBuffer:int = 0;
		private var bitsInBuffer:int = 0;
		
		private var byteArray:FastByteArray;
		
		public function BitsWriter(byteArray:FastByteArray) 
		{
			this.byteArray = byteArray;
		}
		
		[Inline]
		/**
		 * Write int as 32 bit buffer to byteArray and change position to +4 byte
		 * @param	value
		 */
		public final function writeBits32Inline(value:Number):void
		{
			/**
			 * NOTE: 
			 * that function does not inlined
			 * hand inline "technique" make about 60-80% 
			 * perfomance improvment
			 */
			var position:int = byteArray._position;
			si32(value, position);
			byteArray._position = position + 4;
		}
		
		[Inline]
		/**
		 * Clear bits buffer
		 */
		public final function clear():void
		{
			bitsInBuffer = 0;
		}
		
		[Inline]
		/**
		 * write bits in buffer to byteArray if still have bits in buffer
		 */
		public final function end():void
		{
			if (bitsInBuffer != 0)
			{
				//========hand inline writeInt32=======
				var position:int = byteArray._position;
				si32(currentBuffer, position);
				byteArray._position = position + 4//ByteArrayUtils.clampBitsToMaxBytes(currentBuffer);
				//========hand inline writeInt32=======
				//writeBits32Inline(currentBuffer);
				
				bitsInBuffer = 0;
			}
		}
		
		[Inline]
		/**
		 * Write bits to buffer
		 * @param	value - value to write
		 * @param	bits - number of bits to write
		 */
		public final function writeBits(value:int, bits:int):void
		{
			if (bitsInBuffer + bits > 32)
			{
				bitsInBuffer = 32 - bitsInBuffer;
				
				currentBuffer = (value << 32 - bitsInBuffer) ^ currentBuffer;
				
				//========hand inline writeInt32=======
				var position:int = byteArray._position;
				si32(currentBuffer, position);
				byteArray._position = position + 4;
				//========hand inline writeInt32=======
				//writeBits32Inline(currentBuffer);
				currentBuffer = value >>> bitsInBuffer;
				bitsInBuffer = bits - bitsInBuffer;
			}
			else
			{
				currentBuffer = (value << bitsInBuffer) ^ currentBuffer;
				bitsInBuffer += bits;
			}
			
			if (bitsInBuffer == 32)
			{
				//========hand inline writeInt32=======
				var _position:int = byteArray._position;
				si32(currentBuffer, _position);
				byteArray._position = _position + 4;
				//========hand inline writeInt32=======
				//writeBits32Inline(currentBuffer);
				currentBuffer = 0;
				bitsInBuffer = 0;
			}
		}
	}
}