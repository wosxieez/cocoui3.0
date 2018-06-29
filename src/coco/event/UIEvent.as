package coco.event
{
	import flash.events.Event;
	
	import coco.component.IItemRenderer;
	
	public class UIEvent extends Event
	{
		
		/**
		 * 组件预初始化的时候派发 
		 */		
		public static const PREINITIALIZE:String = "ui_preinitialize";
		
		/**
		 * 组件创建完成的时候派发 
		 */		
		public static const CREATION_COMPLETE:String = "ui_creationComplete";
		
		/**
		 * 回车键按下的时候派发 
		 */		
		public static const ENTER:String = "ui_enter";
        
        /**
         * 组件更新完毕时候派发 
         */        
        public static const UPDATE_COMPLETE:String = "ui_updateComplete";
        
        /**
         * 组件大小发生改变的时候派发 
         */		
        public static const RESIZE:String = "ui_resize";
        
        /**
         * PopUp组件关闭的时候派发
         */        
        public static const CLOSE:String = "ui_close";
        
        /**
         * 渲染器被选中的时候派发
         */		
        public static const SELECTED:String = "ui_selected";
        
        /**
        * 界面发生改变的时候派发
         */
        public static const CHANGE:String = "ui_change";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
        
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        
        /**
         * CLOSE 的时候使用 
         */        
        public var detail:int;
        
        //----------------------------------
        //  newIndex
        //----------------------------------
        
        /**
         * CHANGE 的时候使用 
         */        
        public var newIndex:int;
        
        //----------------------------------
        //  oldIndex
        //----------------------------------
        /**
         * CHANGE 的时候使用 
         */ 
        public var oldIndex:int;
        
        /**
         * SELECTED 的时候使用 一般有渲染器派发 
         */        
        public var renderer:IItemRenderer;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new UIEvent(type, bubbles, cancelable);
		}
		
	}
}