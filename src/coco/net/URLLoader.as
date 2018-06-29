package coco.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import coco.util.debug;
	
	/**
	 *  URLLoader
	 *  支持超时处理
	 * 
	 * @author Coco
	 */	
	public class URLLoader extends flash.net.URLLoader
	{
		public var timeout:Number;
		
		private var timeoutTimer:Timer;
		private var timeoutEnable:Boolean = false;
		private var loadRequest:URLRequest;
		
        /**
         * 
         * @param timeout   ms
         * 
         */        
		public function URLLoader(timeout:Number =-1):void
		{
			super(null);
			
			this.timeout = timeout;
			
			if (timeout > 0)
			{
				timeoutTimer = new Timer(timeout);
				timeoutTimer.addEventListener(TimerEvent.TIMER, handleTimeout);
				timeoutEnable = true;
			}
			else
				timeoutEnable = false;
		}
		
		override public function load(request:URLRequest):void
		{
			loadRequest = request;
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(Event.COMPLETE, completeHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			realLoad();
		}
		
		/**
		 *  真实的加载方法
		 */		
		private function realLoad():void
		{
            debug("[URLLoader] Url:" + loadRequest.url + " TimeoutEnable:" + (timeout  > 0 ? "true " : "false ") + timeout);
			if (timeoutEnable)
			{
				timeoutTimer.delay = timeout;
				timeoutTimer.start();
			}
			
			super.load(loadRequest);
		}
		
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			if (timeoutEnable)
				timeoutTimer.reset();
		}
		
		protected function completeHandler(event:Event):void
		{
			if (timeoutEnable)
				timeoutTimer.reset();
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			if (timeoutEnable)
				timeoutTimer.reset();
		}
		
		override public function close():void
		{
			if (timeoutEnable)
				timeoutTimer.reset();
			
			try
			{
				super.close();
			} 
			catch(error:Error) 
			{
				// 异常错误
			}
		}
		
		private function handleTimeout(event:TimerEvent):void
		{
			close();
			
            debug("[URLLoader]加载:" + loadRequest.url + "超时");
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
	}
}