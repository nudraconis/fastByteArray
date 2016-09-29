package fastByteArray 
{
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si32;
	import avm2.intrinsics.memory.si8;
	import fastByteArray.BitsReader;
	import fastByteArray.BitsWriter;
	import fastByteArray.ByteArrayUtils;
	import fastByteArray.Constants;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class FastByteArray implements IByteArray
	{
		private var currentDomain:ApplicationDomain;
		
		public var byteArray:ByteArray;
		
		public var _position:int = 0;
		
		public var bitsReader:BitsReader;
		public var bitsWriter:BitsWriter;
		
		public function FastByteArray(byteArray:ByteArray = null, size:int = 1024) 
		{
			if (byteArray != null)
			{
				this.byteArray = byteArray;
			}
			else
			{
				this.byteArray = new ByteArray();
				this.byteArray.length = size;
				this.byteArray.endian = Endian.LITTLE_ENDIAN;
			}
			
			bitsReader = new BitsReader(this);
			bitsWriter = new BitsWriter(this);
			
			currentDomain = ApplicationDomain.currentDomain;
		}
		
		public function clear(size:int = 1024):void
		{
			if (this.byteArray)
				this.byteArray.clear();
				
			//this.byteArray = new ByteArray();
			this.byteArray.length = size;
			this.byteArray.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function setByteArray(byteArray:ByteArray):void
		{
			end(true);
			
			this.byteArray = byteArray;
			
			if (this.byteArray.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH)
				this.byteArray.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
				
			this.byteArray.endian = Endian.LITTLE_ENDIAN;
			_position = 0;
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
			return _position;
		}
		
		[Inline]
		public final function set position(value:int):void 
		{
			_position = value;
		}
		
		[Inline]
		public final function begin():void
		{
			currentDomain.domainMemory = byteArray;
		}
		
		[Inline]
		public final function end(releaseMemory:Boolean):void
		{
			if(releaseMemory)
				currentDomain.domainMemory = null;
				
			bitsWriter.end();
		}
		
		[Inline]
		public final function writeUTF(value:String):void
		{
			bitsWriter.end();
			
			byteArray.position = _position;
			byteArray.writeUTF(value);
			_position = byteArray.position;
		}
		
		[Inline]
		public final function readUTF():String
		{
			bitsReader.clear();
			
			byteArray.position = _position;
			var value:String = byteArray.readUTF();
			_position = byteArray.position;
			
			return value;
		}
		
		[Inline]
		public final function writeBitsToBytes(value:int):void
		{
			si32(value, _position);
			_position += ByteArrayUtils.clampBitsToMaxBytes(value);
		}
		
		[Inline]
		public final function writeBits(value:int, bits:int):void
		{
			bitsWriter.writeBits(value, bits);
		}
		
		[Inline]
		public final function writeFixedBits(value:Number, bits:int):void 
		{
			bitsWriter.writeBits(value * Constants.FIXED_PRECISSION_VALUE, bits);
		}
		
		[Inline]
		public final function readBits(size:int):int
		{
			return bitsReader.readBits(size);
		}
		
		[Inline]
		public final function readFixedBits(bits:int):Number {
			return Number(bitsReader.readBits(bits)) / Constants.FIXED_PRECISSION_VALUE;
		}
		
		[Inline]
		public final function writeInt8(value:int):void
		{
			si8(value, _position);
			_position += 1;
		}
		
		[Inline]
		public final function readInt8():int
		{
			var value:int = li8(_position);
			_position += 1;
			
			return value;
		}
		
		[Inline]
		public final function writeInt16(value:int):void
		{
			si16(value, _position);
			_position += 2;
		}
		
		[Inline]
		public final function readInt16():int
		{
			var value:int = li16(_position);
			
			if (value > 32767) //remove additional code
				value = ((value / 2) - 32768) * 2;
			
			_position += 2;
			
			return value;
		}
		
		[Inline]
		public final function writeInt32(value:int):void
		{
			si32(value, _position);
			_position += 4;
		}
		
		[Inline]
		public final function readInt32():int
		{
			var value:int = li32(_position);
			_position += 4;
			
			return value;
		}	
		
		[Inline]
		public final function writeBytes(input:ByteArray, offset:Number, length:uint):void 
		{
			byteArray.position = _position;
			byteArray.writeBytes(input, offset, length);
			_position = byteArray.position;
		}
		
		public function readBytes(output:ByteArray, offset:Number, length:int):void 
		{
			byteArray.position = _position;
			byteArray.readBytes(output, offset, length);
			_position = byteArray.position;
		}
	}
}