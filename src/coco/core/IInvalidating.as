package coco.core
{
	
	/**
     * 失效接口
	 * @author Coco
	 * 
	 */	
	public interface IInvalidating
	{
		
        /**
         * 属性失效，将在下一帧调用<code>commitProperties()</code>方法
         */        
		function invalidateProperties():void;
        /**
         * 属性生效，立即调用<code>commitProperties()</code>方法
         */ 
		function validateProperties():void;
		
        /**
         * 尺寸失效，将在下一帧调用<code>measure()</code>方法
         */        
		function invalidateSize():void;
        /**
         * 尺寸生效，立即调用<code>measure()</code>方法
         */ 
		function validateSize():void;
		
        /**
         * 显示列表失效，将在下一帧调用<code>updateDisplayList()</code>方法
         */        
		function invalidateDisplayList():void;
        /**
         * 显示列表生效，立即调用<code>updateDisplayList()</code>方法
         */ 
		function validateDisplayList():void;
		
		/**
		 * 同时调用validateProperties validateSize validateDisplayList 
		 * 
		 */		
		function validateNow():void;
	}
}