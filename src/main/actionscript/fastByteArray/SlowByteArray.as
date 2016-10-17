package fastByteArray 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SlowByteArray implements IByteArray
	{
		private var _byteArray:ByteArray;
		
		public function SlowByteArray(byteArray:ByteArray = null, size:int = 1024) 
		{
			if (byteArray != null)
			{
				_byteArray = byteArray;
			}
			else
			{
				_byteArray = new ByteArray();
				_byteArray.length = size;
				_byteArray.endian = Endian.LITTLE_ENDIAN;
			}
		}
		
		public function clear(size:int = 1024):void
		{
			if (_byteArray)
				_byteArray.clear();
				
			_byteArray = new ByteArray();
			_byteArray.length = size;
			_byteArray.position = 0;
			//_byteArray.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function setByteArray(byteArray:ByteArray):void
		{
			end(true);
			
			_byteArray = byteArray;
			_byteArray.endian = Endian.LITTLE_ENDIAN;
			_byteArray.position = 0;
		}
		
		[Inline]
		public final function get length():int 
		{
			return byteArray.length;
		}
		
		[Inline]
		public final function set length(value:int):void 
		{
			byteArray.length = value;
		}
		
		
		[Inline]
		public final function get position():int 
		{
			return _byteArray.position;
		}
		
		[Inline]
		public final function set position(value:int):void 
		{
			_byteArray.position = value;
		}
		
		public function get byteArray():ByteArray 
		{
			return _byteArray;
		}
		
		[Inline]
		public final function begin():void
		{
			
		}
		
		[Inline]
		public final function end(releaseMemory:Boolean):void
		{
			
		}
		
		[Inline]
		public final function writeUTF(value:String):void
		{
			byteArray.writeUTF(value);
		}
		
		[Inline]
		public final function readUTF():String
		{
			var value:String = byteArray.readUTF();
			
			return value;
		}
		
		[Inline]
		public final function writeBitsToBytes(value:int):void
		{
			
		}
		
		[Inline]
		public final function writeBits(value:int, bits:int):void
		{
			
		}
		
		[Inline]
		public final function writeFixedBits(value:Number, bits:int):void 
		{
			
		}
		
		[Inline]
		public final function readBits(size:int):int
		{
			return 0;
		}
		
		[Inline]
		public final function readFixedBits(bits:int):Number {
			return 0;
		}
		
		[Inline]
		public final function writeInt8(value:int):void
		{
			byteArray[_byteArray.position++] = value;
		}
		
		[Inline]
		public final function readInt8():int
		{
			var value:int = _byteArray[_byteArray.position++];
			
			return value;
		}
		
		[Inline]
		public final function writeInt16(value:int):void
		{
			byteArray.writeShort(value);
		}
		
		[Inline]
		public final function readInt16():int
		{
			var value:int = byteArray.readShort();
			
			//if (value > 32767) //remove additional code
			//	value = ((value / 2) - 32768) * 2;
			
			return value;
		}
		
		[Inline]
		public final function writeInt32(value:int):void
		{
			byteArray.writeInt(value);
		}
		
		[Inline]
		public final function readInt32():int
		{
			var value:int = byteArray.readInt();
			
			return value;
		}	
		
		[Inline]
		public final function writeBytes(input:ByteArray, offset:Number, length:uint):void 
		{
			byteArray.writeBytes(input, offset, length);
		}
		
		public function readBytes(output:ByteArray, offset:Number, length:int):void 
		{
			byteArray.readBytes(output, offset, length);
		}
	}
}