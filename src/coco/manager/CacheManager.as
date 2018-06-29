package coco.manager
{
	import flash.display.BitmapData;
	
	import coco.util.debug;
	
	/**
	 * Cache Manager
	 * 
	 * Use Cache Assets
	 * 
	 * @author Coco
	 */	
	public class CacheManager
	{
		public function CacheManager()
		{
		}
		
		//------------------------------------------------------------------------
		//
		//	Bitmapdata Cache Code
		//
		//------------------------------------------------------------------------
		
		private static var bitmapdataCaches:Vector.<BitmapdataCache> = new Vector.<BitmapdataCache>();
		
		public static function getBitmapdata(name:String):BitmapData
		{
			for each (var item:BitmapdataCache in bitmapdataCaches)
			{
				if (item.name == name)
				{
					debug("[CacheManager] Get Cache: " + name);
					return item.bitmapdata;
				}
			}
			
			return null;
		}
		
		public static function setBitmapdata(name:String, bitmapdata:BitmapData):void
		{
            debug("[CacheManager] Set Cache: " + name);
			for each (var item:BitmapdataCache in bitmapdataCaches)
			{
				if (item.name == name)
				{
					item.bitmapdata = bitmapdata;
					return;
				}
			}
			
			bitmapdataCaches.push(new BitmapdataCache(name, bitmapdata));
		}
	}
}
