package coco.manager
{
	import flash.display.BitmapData;

	[ExcludeClass]
	public class BitmapdataCache
	{
		public function BitmapdataCache(name:String, bitmapdata:BitmapData)
		{
			this.name = name;
			this.bitmapdata = bitmapdata;
		}
		
		public var name:String;
		public var bitmapdata:BitmapData;
	}
}