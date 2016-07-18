package fastByteArray 
{
	import flash.system.ApplicationDomain;
	import org.flexunit.Assert;
	
	public class FastByteArrayTest 
	{
		private var byteArray:FastByteArray;
		
		public function FastByteArrayTest() 
		{
			
		}
		
		[Before]
		public function setUp():void
		{
			byteArray = new FastByteArray(null, 8001);
		}
		
		[After]
		public function end():void
		{
			byteArray.end(true);
			byteArray = null;
		}
		
		[Test]
		public function mixedUtfReadWithBitsTest():void
		{
			byteArray.begin();
			
			var utfValue:String = "test utf value";
			var intValue:int = 56;
			var intValue2:int = 44;
			
			byteArray.writeBits(intValue, 6);
			byteArray.writeUTF(utfValue);
			byteArray.writeBits(intValue2, 6);
			byteArray.end(false);
			
			byteArray.position = 0;
			
			Assert.assertEquals("int value is not equals", intValue, byteArray.readBits(6));
			Assert.assertEquals("UTF value is not equals", utfValue, byteArray.readUTF());
			Assert.assertEquals("int value 2 is not equals", intValue2, byteArray.readBits(6));
			
			byteArray.end(true);
		}
		
		[Test]
		public function mixedUtfReadWithByteTest():void
		{
			byteArray.begin();
			
			var utfValue:String = "test utf value";
			var intValue:int = 56;
			var intValue2:int = 44;
			
			byteArray.writeInt8(intValue);
			byteArray.writeUTF(utfValue);
			byteArray.writeInt8(intValue2);
			
			byteArray.position = 0;
			
			Assert.assertEquals("int value is not equals", intValue, byteArray.readInt8());
			Assert.assertEquals("UTF value is not equals", utfValue, byteArray.readUTF());
			Assert.assertEquals("int value 2 is not equals", intValue2, byteArray.readInt8());
			
			byteArray.end(true);
		}
		
		[Test]
		public function readWriteUTFTest():void
		{
			byteArray.begin();
			
			var utfValue:String = "test utf value";
			
			byteArray.writeUTF(utfValue);
			
			byteArray.position = 0;
			
			Assert.assertEquals("UTF value is not equals", utfValue, byteArray.readUTF());
			
			byteArray.end(true);
		}
		
		[Test]
		public function setPositionTest():void
		{
			byteArray.begin();
			
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeInt8(i);
			}
			
			byteArray.position = 1;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 1);
			
			byteArray.position = 2;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 2);
			
			byteArray.position = 0;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 0);
			
			byteArray.position = 15;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 15);
			
			byteArray.position = 36;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 36);
			
			byteArray.position = 99;
			Assert.assertEquals("value current position is wrong", byteArray.readInt8(), 99);
		}
		
		[Test(expects="RangeError")]
		public function setPositionOutOfBoundTest():void
		{
			byteArray.begin();
			
			byteArray.position = 8001;
			
			byteArray.writeInt8(1);
		}
		
		[Test(expects="RangeError")]
		public function outOfByteBoundsTest():void
		{
			byteArray.begin();
			
			/**
			 * we have 8001 bytes so if we write more then 8001 bytes
			 * we should catch an exception
			 */
			
			for (var i:int = 0; i < 7900; i++)
			{
				byteArray.writeInt8(1);
			}
		}
		
		[Test]
		[Ignore("not implemented for perfomance reason")]
		public function failReadWithOutOfBitsRangeTest():void
		{
			byteArray.begin();
			
			
			//50 - 110010 write only 4 so - 1100 (12)
			byteArray.writeBits(50, 4);
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			var value:int = byteArray.readBits(6);
			Assert.assertEquals("walue that write should store only 4 bits of 50(110010) - 1100 but store " + value.toString(2), 12, value); 
		}
		
		[Test]
		public function readWriteBitsWithCalculatedRangeTest():void
		{
			byteArray.begin();
			
			for (var i:int = 0; i < 1024; i++)
			{
				byteArray.writeBits(i, ByteArrayUtils.calculateBits(i));
			}
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 1024; j++)
			{
				var value:int = byteArray.readBits(ByteArrayUtils.calculateBits(j));
				Assert.assertEquals("read range fail with bits range: " + ByteArrayUtils.calculateBits(j) + ", at: " + j, j, value); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readWriteBitsWithDifferentRangeTest():void
		{
			byteArray.begin();
			
			var bitsRangeValues:Vector.<int> = new <int>[6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
			
			var counter:int = 0;
			var bitsRange:int = bitsRangeValues.shift();
			
			for (var i:int = 0; i < 700; i++)
			{
				if (counter == 50)
				{
					counter = 0;
					bitsRange = bitsRangeValues.shift();
				}
				
				counter++;
				
				byteArray.writeBits(i, bitsRange);
			}
			
			byteArray.end(false);
			byteArray.position = 0;
			
			bitsRangeValues = new <int>[6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
			
			counter = 0;
			bitsRange = bitsRangeValues.shift();
			
			for (var j:int = 0; j < 700; j++)
			{
				if (counter == 50)
				{
					counter = 0;
					bitsRange = bitsRangeValues.shift();
				}
				
				counter++;
				
				var value:int = byteArray.readBits(bitsRange);
				Assert.assertEquals("read bits range fail at: " + j + " with read range is: " + bitsRange, j, value); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readWriteNegativeBitsTest():void
		{
			byteArray.begin();
			
			trace(ByteArrayUtils.calculateBits( -50));
			trace("TTTTTT", ( -50).toString(2), uint( -50).toString(2), uint( -50));
			var value:int = -50;
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeBits(value + i, 32);
			}
			1001110
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 100; j++)
			{
				var readValue:int = byteArray.readBits(32);
				Assert.assertEquals("int8 value testing fail at: " + j, value + j, readValue); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readInt8Test():void
		{
			byteArray.begin();
			
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeInt8(i);
			}
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 100; j++)
			{
				var value:int = byteArray.readInt8();
				Assert.assertEquals("int8 value testing fail at: " + j, j, value); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readNegativeInt16Test():void
		{
			byteArray.begin();
			
			var value:int = -50;
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeInt16(value + i);
			}
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 100; j++)
			{
				var readValue:int = byteArray.readInt16();
				
				Assert.assertEquals("negativeInt16 value testing fail at: " + j, value + j, readValue); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readInt16Test():void
		{
			byteArray.begin();
			
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeInt16(i);
			}
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 100; j++)
			{
				var value:int = byteArray.readInt16();
				Assert.assertEquals("int16 value testing fail at: " + j, j, value); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function readInt32Test():void
		{
			byteArray.begin();
			
			for (var i:int = 0; i < 100; i++)
			{
				byteArray.writeInt32(i);
			}
			
			byteArray.end(false);
			
			byteArray.position = 0;
			
			for (var j:int = 0; j < 100; j++)
			{
				var value:int = byteArray.readInt32();
				Assert.assertEquals("int32 value testing fail at: " + j, j, value); 
			}
			
			byteArray.end(true);
		}
		
		[Test]
		public function endAndBeginTest():void
		{
			byteArray.begin();
			
			Assert.assertEquals("after call begin domain memory should equals to byteArray.byteArray", ApplicationDomain.currentDomain.domainMemory, byteArray.byteArray);
			
			byteArray.end(false);
			
			Assert.assertEquals("after call end(false) - end write but not clean domain memory," +
								"domain memory should equals to byteArray.byteArray", ApplicationDomain.currentDomain.domainMemory, byteArray.byteArray);
								
			byteArray.end(true);
			
			Assert.assertNull("after call end(true) domain memory should be null", ApplicationDomain.currentDomain.domainMemory);
		}
	}

}