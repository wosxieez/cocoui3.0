package coco.layout
{
	import coco.core.UIComponent;
	
	/**
	 * Vertical Layout
	 * 
	 * @author Coco
	 */	
	public class VerticalLayout extends LayoutBase
	{
		public function VerticalLayout()
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
        // horizontalAlgin
        //-------------------------------
		private var _horizontalAlgin:String = "left";
		
        /**
         * left center right
         * 
         * @return 
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
		
        //-------------------------------
        // verticalAlgin
        //-------------------------------
		private var _verticalAlgin:String = "top";
		
        /**
         * top middle bottom
         * @return 
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
            layoutWidth = paddingLeft + paddingRight; // layout width
            layoutHeight = paddingTop + paddingBottom;// layout height
			if (target)
			{
				var ui:UIComponent;
				var startY:Number = 0;
                var totalHeight:Number = getTotalHeight();
                var maxWidth:Number = 0;
                
				// set startY
				if (verticalAlgin == "middle")
					startY = (target.height - totalHeight) / 2;
				else if (verticalAlgin == "bottom")
					startY = target.height - paddingBottom - totalHeight;
				else
					startY = paddingTop;
				
				// set x y
				for (var i:int = 0; i < target.numChildren; i++)
				{
					ui = target.getChildAt(i) as UIComponent;
					if (ui)
					{
						if (horizontalAlgin == "center")
							ui.x = (target.width - ui.width) / 2;
						else if (horizontalAlgin == "right")
							ui.x = target.width - ui.width - paddingRight;
						else
							ui.x = paddingLeft;
						
						ui.y = startY;
						startY += ui.height + gap;
                        
                        maxWidth = Math.max(maxWidth, ui.width);
					}
				}
                
                // set layout width height
                layoutWidth += maxWidth;
                layoutHeight += totalHeight;
			}
		}
		
		private function getTotalHeight():Number
		{
			var ui:UIComponent;
			var totalHeight:Number = 0;
			for (var i:int = 0; i < target.numChildren; i++)
			{
				ui = target.getChildAt(i) as UIComponent;
				if (ui)
				{
                    if (i == 0)
                        totalHeight += ui.height;
                    else
					    totalHeight += gap + ui.height;
				}
			}
			
			return totalHeight;
		}
		
	}
}