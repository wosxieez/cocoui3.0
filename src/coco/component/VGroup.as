package coco.component
{
	import coco.layout.VerticalLayout;
	
    
    /**
     *
     * VGroup
     * 
     * Group With VerticalLayout
     *  
     * @author Coco
     * 
     */    
	public class VGroup extends Group
	{
		public function VGroup()
		{
			super();
			
			layout = new VerticalLayout();
		}
        
        //-------------------------------------------------------------------------------------
        //
        //  Properties
        //
        //-------------------------------------------------------------------------------------
		
		private var _paddingLeft:Number = 10;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).paddingLeft = paddingLeft;
		}
		
		private var _paddingTop:Number = 10;
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).paddingTop = paddingTop;
		}
		
		private var _paddingRight:Number = 10;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).paddingRight = paddingRight;
		}
		
		private var _paddingBottom:Number =  10;
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).paddingBottom = paddingBottom;
		}
		
		private var _horizontalAlgin:String = "left";
		
		public function get horizontalAlgin():String
		{
			return _horizontalAlgin;
		}
		
		public function set horizontalAlgin(value:String):void
		{
			_horizontalAlgin = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).horizontalAlgin = horizontalAlgin;
		}
		
		private var _verticalAlgin:String = "top";
		
		public function get verticalAlgin():String
		{
			return _verticalAlgin;
		}
		
		public function set verticalAlgin(value:String):void
		{
			_verticalAlgin = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).verticalAlgin = verticalAlgin;
		}
		
		private var _gap:Number = 10;
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
			
			if (layout && layout is VerticalLayout)
				VerticalLayout(layout).gap = gap;
		}
		
	}
}