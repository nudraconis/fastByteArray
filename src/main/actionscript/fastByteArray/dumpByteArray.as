package fastByteArray 
{
	import flash.utils.ByteArray;
	
	public function dumpByteArray(byteArray:ByteArray, from:int, length:int, asBits:Boolean = false):String
	{
		var returnValue:String = "";
		
		for (var i:int = from; i < length; i++)
		{
			if (byteArray[i] == undefined)
			{
				returnValue += "null|";
				continue;
			}
				
			if (asBits)
			{
				returnValue += byteArray[i].toString(2) + "|";
			}
			else
				returnValue += byteArray[i] + "|";
		}
		
		return returnValue;
	}
}