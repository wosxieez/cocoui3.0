package coco.layout
{
    import coco.core.UIComponent;
    import coco.core.coco;
    
    /**
     * Tile Layout
     * 
     * @author Coco
     */	
    public class TileLayout extends LayoutBase
    {
        public function TileLayout()
        {
            super();
        }
        
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
        
        /**
         *
         * left center right justify
         *  
         * @return 
         * 
         */        
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
        
        /**
         * top middle bottom justify 
         * @return 
         * 
         */        
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
        
        //--------------------------------
        // 列数
        //--------------------------------
        private var _columns:int = 0;
        
        /**
         * 列数 
         */
        public function get columns():int
        {
            return _columns;
        }
        
        /**
         * @private
         */
        public function set columns(value:int):void
        {
            if (_columns == value)
                return;
            
            _columns = value;
            if (target)
                target.invalidateDisplayList();
        }
        
        // rows
        private var _rows:int = 0;
        
        public function get rows():int
        {
            return _rows;
        }
        
        public function set rows(value:int):void
        {
            if (_rows == value)
                return;
            
            _rows = value;
            if (target)
                target.invalidateDisplayList();
        }
        
        private var useRow:Boolean;
        
        override protected function updateLayout():void
        {
            if (!target) return;
            
            if (columns > 0)
                useRow = false;
            else if (rows > 0)
                useRow = true;
            else
            {
                // not set columns rows , default set columns 1
                columns = 1;
                useRow = false;
            }
            
            var obj:Object = getTotalAndMaxWidthHeight();
            var maxWidth:Number = obj.maxWidth;
            var maxHeight:Number = obj.maxHeight;
            var totalWidth:Number = obj.totalWidth;
            var totalHeight:Number = obj.totalHeight;
            var realColumns:int = obj.realColumns;
            var realRows:int = obj.realRows;
            var ui:UIComponent;
            var sx:Number = 0;
            var sy:Number = 0;
            var itemColumn:int;
            var itemRow:int;
            
            layoutWidth = paddingLeft + paddingRight + totalWidth;
            layoutHeight = paddingTop + paddingBottom + totalHeight;
            
            // set sx
            if (horizontalAlgin == "center")
                sx = (target.width - totalWidth) / 2;
            else if (horizontalAlgin == "right")
                sx = target.width - paddingRight - totalWidth;
            else
                sx = paddingLeft;
            
            // set sy
            if (verticalAlgin == "middle")
                sy = (target.height - totalHeight) / 2;
            else if (verticalAlgin == "bottom")
                sy = target.height - paddingBottom - totalHeight;
            else
                sy = paddingTop;
            
            // set x y
            for (var i:int = 0; i < target.numChildren; i++)
            {
                ui = target.getChildAt(i) as UIComponent;
                if (ui)
                {
                    itemColumn = useRow ? Math.floor(i / realRows) : i % realColumns;
                    itemRow = useRow ? i % realRows : Math.floor(i / realColumns);
                    ui.x = sx + itemColumn  * (maxWidth + gap);
                    ui.y = sy + itemRow * (maxHeight + gap);
                    
                    if (horizontalAlgin == "justify")
					{
						ui.coco::_width = maxWidth;
						ui.invalidateSize();
						ui.invalidateDisplayList();
					}
                    if (verticalAlgin == "justify")
					{
						ui.coco::_height = maxHeight;
						ui.invalidateSize();
						ui.invalidateDisplayList();
					}
                }
            }
        }
        
        private function getTotalAndMaxWidthHeight():Object
        {
            var ui:UIComponent;
            var maxWidth:Number = 0;
            var maxHeight:Number = 0;
            var totalWidth:Number = 0;
            var totalHeight:Number = 0;
            var realColumns:int;
            var realRows:int;
            for (var i:int = 0; i < target.numChildren; i++)
            {
                ui = target.getChildAt(i) as UIComponent;
                if (ui)
                {
                    maxWidth = Math.max(ui.width, maxWidth);
                    maxHeight = Math.max(ui.height, maxHeight);
                }
            }
            
            if (useRow)
            {
                realColumns = Math.ceil(target.numChildren / rows);
                realRows = rows;
            }
            else
            {
                realColumns = columns;
                realRows = Math.ceil(target.numChildren / columns);
            }
            
            totalWidth = maxWidth * realColumns + (realColumns - 1) * gap;
            totalHeight = maxHeight * realRows + (realRows - 1) * gap;
            
            if (horizontalAlgin == "justify")
            {
                totalWidth = target.width - paddingLeft - paddingRight;
                maxWidth = (totalWidth - (realColumns - 1) * gap) / realColumns;
            }
            
            if (verticalAlgin == "justify")
            {
                totalHeight = target.height - paddingTop - paddingBottom;
                maxHeight = (totalHeight - (realRows - 1) * gap) / realRows;
            }
            
            return {maxWidth:maxWidth, maxHeight:maxHeight, 
                totalWidth:totalWidth, totalHeight:totalHeight,
                realColumns:realColumns, realRows:realRows};
        }
        
    }
}