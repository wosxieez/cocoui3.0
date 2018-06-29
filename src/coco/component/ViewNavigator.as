package coco.component
{
    import flash.display.DisplayObject;
    
    import coco.core.UIComponent;
    import coco.event.UIEvent;
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
    
    /**
     * 
     * View Navigator
     * 
     * use <code>show(viewClass)</code> call
     * 
     * @author Coco
     * 
     */    
    public class ViewNavigator extends UIComponent
    {
        public function ViewNavigator()
        {
            super();
        }
        
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Properties
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private var _currentView:DisplayObject;
        
        public function get currentView():DisplayObject
        {
            return _currentView;
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        public function show(viewClass:Class):DisplayObject
        {
			if (_currentView && _currentView is viewClass)
				return _currentView;
			
            // content view already in this view
            var child:DisplayObject;
            for (var i:int = 0; i < numChildren; i++)
            {
                child = getChildAt(i);
                if(child is viewClass)
                {
                    initView(child);
                    return child;
                }
            }
            
            // content not in this view
            child = new viewClass() as DisplayObject;
            addChild(child);
            initView(child);
            return child;
        }
        
        private function initView(view:DisplayObject):void
        {
            // set current view
            _currentView = view;
            
            // width height 
            view.width = width;
            view.height = height;
            
            // set visible 
            var num:int = numChildren; // just for speed
            var child:DisplayObject;
            for (var index:int = 0; index < numChildren; index++)
            {
                child = getChildAt(index);
                if (child == view)
                    child.visible = true;
                else
                    child.visible = false;
            }
			
			// dispatch chagne event
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            // sync all child width height
            var child:DisplayObject;
            for (var i:int = 0; i < numChildren; i++)
            {
                child = getChildAt(i);
                child.width = width;
                child.height = height;
            }
        }
    }
}