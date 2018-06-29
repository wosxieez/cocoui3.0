package coco.component
{
    import coco.core.UIComponent;
    import coco.core.coco;
    import coco.layout.LayoutBase;
    import coco.util.CocoUI;
    
    import flash.display.DisplayObject;
    
	use namespace coco;
    
    /**
     * 
     * Panel
     * 
     * ------------------
     * |      title     |
     * ------------------
     * |                |
     * |     content    |
     * |                |
     * |                |
     * ------------------
     * 
     * @author Coco
     * 
     */    
    public class Panel extends UIComponent
    {
        public function Panel()
        {
            super();
            
            contentDisplay = new Group();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //----------------------------------------------------------------------------------------------------------------
        
        protected var headerDisplay:Label;
        protected var contentDisplay:Group;
        
        private var _headerHeight:Number = 40;
        
        /**
         *
         * HeaderHeight
         *  
         * @return 
         * 
         */
        public function get headerHeight():Number
        {
            return _headerHeight;
        }
        
        public function set headerHeight(value:Number):void
        {
            if (_headerHeight == value)
                return;
            _headerHeight = value;
            invalidateSize();
            invalidateDisplayList();
        }
        
        
        private var _title:String;
        
        /**
         *
         * title
         *  
         * @return 
         * 
         */        
        public function get title():String
        {
            return _title;
        }
        
        public function set title(value:String):void
        {
            if (_title == value) 
                return;
            _title = value;
            invalidateProperties();
        }
        
        public function get layout():LayoutBase
        {
            return contentDisplay.layout;
        }

        public function set layout(value:LayoutBase):void
        {
            contentDisplay.layout = value;
        }
		
		
		public function get contentWidth():Number
		{
			if (contentDisplay)
				return contentDisplay.width;
			else
				return NaN;
		}
		
		public function get contentHeight():Number
		{
			if (contentDisplay)
				return contentDisplay.height;
			else
				return NaN;
		}

        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            // header display
            headerDisplay = new Label();
            headerDisplay.textAlign = "center";
            super.addChild(headerDisplay);
            
            // content display
            contentDisplay.y = headerHeight;
            super.addChildAt(contentDisplay, 1);
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (headerDisplay)
                headerDisplay.text = title;
        }
        
        override protected function measure():void
        {
            measuredWidth = 120;
            measuredHeight = headerHeight + 100;  // 160
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            graphics.clear();
            graphics.lineStyle(1, CocoUI.themeBorderColor);
            graphics.beginFill(CocoUI.themeBackgroundColor);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            graphics.beginFill(CocoUI.themeBorderColor);
            graphics.drawRect(0, 0, width, headerHeight);
            graphics.endFill();
            
            headerDisplay.width = contentDisplay.width = width;
            headerDisplay.height = headerHeight;
            contentDisplay.height = height - contentDisplay.y;
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Override for child
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override coco function setChildrenApplication():void
        {
            headerDisplay.application = contentDisplay.application = application;
        }
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            return contentDisplay.addChild(child);
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            return contentDisplay.addChildAt(child, index);
        }
        
        override public function removeChild(child:DisplayObject):DisplayObject
        {
            return contentDisplay.removeChild(child);
        }
        
        override public function removeChildAt(index:int):DisplayObject
        {
            return contentDisplay.removeChildAt(index);
        }
        
        override public function get numChildren():int
        {
            return contentDisplay.numChildren;
        }
        
        override public function getChildAt(index:int):DisplayObject
        {
            return contentDisplay.getChildAt(index);
        }
        
        override public function getChildByName(name:String):DisplayObject
        {
            return contentDisplay.getChildByName(name);
        }
        
        override public function getChildIndex(child:DisplayObject):int
        {
            return contentDisplay.getChildIndex(child);
        }
        
        
    }
}