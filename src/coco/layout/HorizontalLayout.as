package coco.layout
{
    import coco.core.UIComponent;
    
    /**
     * 横向布局
     * 
     * @author Coco
     */	
    public class HorizontalLayout extends LayoutBase
    {
        public function HorizontalLayout()
        {
            super();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Properties
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private var _paddingLeft:Number = 0;
        
        public function get paddingLeft():Number
        {
            return _paddingLeft;
        }
        
        public function set paddingLeft(value:Number):void
        {
            _paddingLeft = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _paddingTop:Number = 0;
        
        public function get paddingTop():Number
        {
            return _paddingTop;
        }
        
        public function set paddingTop(value:Number):void
        {
            _paddingTop = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _paddingRight:Number = 0;
        
        public function get paddingRight():Number
        {
            return _paddingRight;
        }
        
        public function set paddingRight(value:Number):void
        {
            _paddingRight = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _paddingBottom:Number =  0;
        
        public function get paddingBottom():Number
        {
            return _paddingBottom;
        }
        
        public function set paddingBottom(value:Number):void
        {
            _paddingBottom = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _horizontalAlgin:String = "left";
        
        public function get horizontalAlgin():String
        {
            return _horizontalAlgin;
        }
        
        public function set horizontalAlgin(value:String):void
        {
            _horizontalAlgin = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _verticalAlgin:String = "top";
        
        public function get verticalAlgin():String
        {
            return _verticalAlgin;
        }
        
        public function set verticalAlgin(value:String):void
        {
            _verticalAlgin = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        private var _gap:Number = 0;
        
        public function get gap():Number
        {
            return _gap;
        }
        
        public function set gap(value:Number):void
        {
            _gap = value;
            
            if (target)
                target.invalidateDisplayList();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override protected function updateLayout():void
        {
            layoutWidth = paddingLeft + paddingRight;
            layoutHeight = paddingTop + paddingBottom;
            if (target)
            {
                var ui:UIComponent;
                var startX:Number = 0;
                var totalWidth:Number = getTotalWidth();
                var maxHeight:Number = 0;
                
                // set startX
                if (horizontalAlgin == "center")
                    startX = (target.width - totalWidth) / 2;
                else if (horizontalAlgin == "right")
                    startX = target.width - paddingRight - totalWidth;
                else
                    startX = paddingLeft;
                
                // set x y
                for (var i:int = 0; i < target.numChildren; i++)
                {
                    ui = target.getChildAt(i) as UIComponent;
                    if (ui)
                    {
                        if (verticalAlgin == "middle")
                            ui.y = (target.height - ui.height) / 2;
                        else if (verticalAlgin == "bottom")
                            ui.y = target.height - ui.height - paddingBottom;
                        else
                            ui.y = paddingTop;
                        
                        ui.x = startX;
                        startX += ui.width + gap;
                        
                        maxHeight = Math.max(maxHeight, ui.height);
                    }
                }
                
                layoutWidth += totalWidth;
                layoutHeight += maxHeight;
            }
        }
        
        private function getTotalWidth():Number
        {
            var ui:UIComponent;
            var totalWidth:Number = 0;
            for (var i:int = 0; i < target.numChildren; i++)
            {
                ui = target.getChildAt(i) as UIComponent;
                if (ui)
                {
                    if (i == 0)
                        totalWidth += ui.width;
                    else
                        totalWidth += ui.width + gap;
                }
            }
            
            return totalWidth;
        }
    }
}