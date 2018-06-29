package coco.layout
{
    import coco.core.UIComponent;
    
    /**
     * 1
     * 2
     * 3
     *  
     * @author Coco
     * 
     */    
    public class HorizontalOrderLayout extends LayoutBase
    {
        public function HorizontalOrderLayout()
        {
            super();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //----------------------------------------------------------------------------------------------------------------
        
        //-------------------------------
        // paddingLeft
        //-------------------------------
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
        
        //-------------------------------
        // paddingTop
        //-------------------------------
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
        
        //-------------------------------
        // paddingRight
        //-------------------------------
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
        
        //-------------------------------
        // paddingBottom
        //-------------------------------
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
        
        //-------------------------------
        // gap
        //-------------------------------
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
            if (target)
            {
                var ui:UIComponent;
                var sx:Number = paddingLeft;
                var sy:Number = paddingTop;
                var maxHeight:Number = 0;
                layoutWidth = target.width;
                
                // set x y
                for (var i:int = 0; i < target.numChildren; i++)
                {
                    ui = target.getChildAt(i) as UIComponent;
                    if (ui)
                    {
                        if ((sx + ui.width + paddingRight) >= layoutWidth)
                        {
                            sx = paddingLeft;
                            sy += maxHeight + gap;
                            maxHeight = 0;
                        }
                        
                        ui.x = sx;
                        ui.y = sy;
                        maxHeight = Math.max(maxHeight, ui.height);
                        sx += ui.width + gap;
                    }
                }
                
                layoutHeight = sy + maxHeight + paddingBottom;
            }
        }
        
    }
}