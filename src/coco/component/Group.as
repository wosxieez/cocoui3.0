package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.core.IUIComponent;
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	import coco.layout.BasicLayout;
	import coco.layout.LayoutBase;
	
    /**
     * 
     * Group uicomponent with layout properties
     * 
     * @author Coco
     * 
     */    
	public class Group extends UIComponent
	{
		public function Group()
		{
			super();
		}
		
        //-------------------------------------------------------------------------------------
        //
        //  Properties
        //
        //-------------------------------------------------------------------------------------
        
        //-----------------------
        //  layout
        //-----------------------
		
		private var _layout:LayoutBase;
		
		public function get layout():LayoutBase
		{
			if (!_layout)
				_layout = new BasicLayout();
			
			return _layout;
		}
		
		public function set layout(value:LayoutBase):void
		{
			if (_layout == value)
				return;
			
			_layout = value;
            
            invalidateProperties();
			invalidateDisplayList();
		}
        
        //-------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //-------------------------------------------------------------------------------------
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            layout.target = this;
        }
		
        override protected function measure():void
        {
            measuredWidth = layout.getLayoutWidth();
            measuredHeight = layout.getLayoutHeight();
        }
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			layout.updateDisplayList();
		}
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			// listen resize event
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent)
				uicomponent.addEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			// add
			super.addChild(child);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			// listen resize event
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent)
				uicomponent.addEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			// add
			super.addChildAt(child, index);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent)
				uicomponent.removeEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var removedChild:DisplayObject = super.removeChildAt(index);
			var uicomponent:IUIComponent = removedChild as IUIComponent;
			if (uicomponent)
				uicomponent.removeEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			return removedChild;
		}
		
		protected function uicomponent_resizeHandler(event:UIEvent):void
		{
			invalidateDisplayList();
		}
	}
}