package fastByteArray 
{
	import flash.utils.ByteArray;
	public interface IByteArray 
	{
		function clear(size:int = 1024):void;
		
		function setByteArray(byteArray:ByteArray):void;
		
		function readBytes(output:ByteArray, offset:Number, length:int):void;
		
		function writeBytes(input:ByteArray, offset:Number, length:uint):void;
		
		function readInt32():int;
		
		function writeInt32(value:int):void;
		
		function readInt16():int;
		
		function writeInt16(value:int):void;
		
		function readInt8():int;
		
		function writeInt8(value:int):void;
		
		function readFixedBits(bits:int):Number;
		
		function readBits(size:int):int;
		
		function writeFixedBits(value:Number, bits:int):void;
		
		function writeBits(value:int, bits:int):void;
		
		function writeBitsToBytes(value:int):void;
		
		function readUTF():String;
		
		function writeUTF(value:String):void;
		
		function end(releaseMemory:Boolean):void;
		
		function begin():void;
		
		function get byteArray():ByteArray;
		
		function set position(value:int):void;
		
		function get position():int;
		
		function set length(value:int):void;
		
		function get length():int;
	}
}