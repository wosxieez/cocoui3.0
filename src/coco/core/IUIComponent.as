package coco.core
{
    import flash.events.IEventDispatcher;
    
    
    /**
     *UIComponent组件接口
     * @author Coco
     * 
     */	
    public interface IUIComponent extends IEventDispatcher, IInvalidating
    {
        
		/**
		 * 组件名称 
		 * @return 
		 * 
		 */		
		function get name():String;
		function set name(value:String):void;
		
        /**
         * x坐标位置
         * 
         * @return 
         * 
         */		
        function get x():Number;
        function set x(value:Number):void;
        
        /**
         * y坐标位置
         *  
         * @return 
         * 
         */		
        function get y():Number;
        function set y(value:Number):void;
        
        /**
         * width 组件宽度
         *  
         * @return 
         * 
         */		
        function get width():Number;
        function set width(value:Number):void;
        
        /**
         * 组件测量宽度，如果组件width没有被赋值，请在测量方法<code>measure()</code>方法中，计算组件的测量宽度
         * @return 
         * 
         */		
        function get measuredWidth():Number;
        function set measuredWidth(value:Number):void;
        
        /**
         * height 组件高度
         *  
         * @return 
         * 
         */		
        function get height():Number;
        function set height(value:Number):void;
        
        /**
         * 组件测量高度，如果组件height没有被赋值，请在测量方法<code>measure()</code>方法中，计算组件的测量高度
         *  
         * @return 
         * 
         */		
        function get measuredHeight():Number;
        function set measuredHeight(value:Number):void;
        
        /**
         * 组件的Application
         *  
         * @return 
         * 
         */		
        function get application():Application;
        function set application(value:Application):void;
        
        /**
         *组件是否可见
         *  
         * @return 
         * 
         */		
        function get visible():Boolean;
        function set visible(value:Boolean):void;
        
        /**
         *isPopUp</br>
         *是否是弹出状态
         *@return 
         * 
         */		
        function get isPopUp():Boolean;
        function set isPopUp(value:Boolean):void;
		
		/**
		 *mouseChildren</br>
		 *显示列表子项是否可以鼠标交互
		 *@return 
		 * 
		 */		
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void; 
		
		/**
		 *mouseEnabled</br>
		 *是否可以鼠标交互
		 *@return 
		 * 
		 */		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void; 
        
        /**
         *组件初始化方法
         */        
        function initialize():void;
        
    }
}