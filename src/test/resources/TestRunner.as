package 
{
	import fastByteArray.FastByteArrayTest;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	public class TestRunner extends Sprite
	{
		private var core:FlexUnitCore;
		
		public function TestRunner() 
		{
			core = new FlexUnitCore();
			
			if (stage)
				startUp();
			else
				addEventListener(Event.ADDED_TO_STAGE, startUp);
		}
		
		private function startUp(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, startUp);
			
			core.addListener(new TraceListener());
			
			core.run(currentRunTestSuite());
		}
		
		public function currentRunTestSuite():Array {
            var testsToRun:Array = new Array();
			
            
            testsToRun.push(fastByteArray.FastByteArrayTest);
            
			
            return testsToRun;
        }
	}
}