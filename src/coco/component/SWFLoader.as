package coco.component
{
	import coco.core.UIComponent;
	import coco.core.coco;
	import coco.util.CocoUI;
	import coco.util.debug;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	import mx.utils.StringUtil;
	
	
	/**
	 * 
	 * SWF Loader Used For Load swf file / flex swf file</br>
	 * 
	 * If you want load swf file normally, Please don't use RSL
	 * 
	 * @author Coco
	 * 
	 */	
	public class SWFLoader extends UIComponent
	{
		public function SWFLoader()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var loader:Loader;
		private var content:DisplayObject;
		
		private var _url:String;
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			if (_url == value) return;
			_url = value;
			invalidateProperties();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			loader.unload();
			removeAllChild();
			
			if (url && StringUtil.trim(url) != "")
			{
				var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				loaderContext.allowCodeImport = true;
				loaderContext.securityDomain = SecurityDomain.currentDomain;
				loader.load(new URLRequest(url));
			}
		}
		
		override protected function measure():void
		{
			if (content)
			{
				measuredWidth = content.width;
				measuredHeight = content.height;
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
//			
//			graphics.clear();
//			graphics.lineStyle(2, 0xFF0000);
//			graphics.drawRect(0, 0, width, height);
//			graphics.endFill();
		}
		
		protected function loader_completeHandler(event:Event):void
		{
			content = LoaderInfo(event.currentTarget).content;
			if (content)
			{
				addChild(content);
				invalidateSize();
			}
		}
		
		protected function loader_errorHandler(event:IOErrorEvent):void
		{
			debug("[SWFLoader]" + event.text);
		}
		
		
	}
}