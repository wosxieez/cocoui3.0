package coco.core
{
	
	/**
	 *
	 * 延迟调用方法实体
	 *  
	 * @author coco
	 * 
	 */	
	public class CallLaterMethod
	{
		public function CallLaterMethod()
		{
		}
		
		/**
		 * 延时调用的方法 
		 */		
		public var method:Function;
		
		/**
		 * 描述 
		 */
		public var descript:String;
		
		/**
		 * 调用者 
		 */		
		public var caller:String;
		
		/**
		 * 调用附加参数 
		 */		
		public var args:Array;
		
	}
}