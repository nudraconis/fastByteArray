package 
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si32;

	public class TestFastMemory extends Sprite 
	{
		
		public function TestFastMemory() 
		{
			super();
			
			var bytes:ByteArray = new ByteArray();
			bytes.length = 1024;
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			ApplicationDomain.currentDomain.domainMemory = bytes;
			
			si16(-6, 0);
			var loadedValue:int = li16(0);
			trace("loadedvalue", loadedValue);
			
			trace("after remove additional code", (loadedValue / 2 - 32768) * 2);
			
			trace("byteArray.readShort", bytes.readShort());
			
			
			si32(-6, 0);
			loadedValue = li32(0);
			trace("store/load value 32 bit", loadedValue, loadedValue.toString(2));
		}
	}
}