package coco.component
{
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	import coco.util.CocoUI;
	
	import flash.events.MouseEvent;
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 * ---|----------
	 * 
	 * 滑块组件
	 * 
	 * @author Coco
	 */	
	public class Slider extends UIComponent
	{
		public function Slider()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Vars
		//
		//----------------------------------------------------------------------------------------------------------------
		
		protected var thumbButton:Button;
		private var thumbMaxX:Number = 0;
		
		private var oldMouseX:Number;
		private var oldThumbX:Number = 0;
		private var valuePerX:Number = 0;
		
		private var _minValue:Number = 0;
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		public function set minValue(value:Number):void
		{
			_minValue = value;
			
			invalidateDisplayList();
		}
		
		private var _maxValue:Number = 0;
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			
			invalidateDisplayList();
		}
		
		private var _value:Number = 0;
		
		public function get value():Number
		{
			if (_value < minValue)
				return minValue;
			else if (_value > maxValue)
				return maxValue;
			else
				return _value;
		}
		
		public function set value(value:Number):void
		{
			_value = value;
			
			invalidateDisplayList();
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			thumbButton = new Button();
			thumbButton.width = height;
			thumbButton.height = height;
			thumbButton.addEventListener(MouseEvent.MOUSE_DOWN, thumbButton_mouseDownHandler);
			addChild(thumbButton);
		}
        
        override protected function measure():void
        {
            measuredWidth = 100;
            measuredHeight = 40;
        }
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			graphics.clear();
			graphics.beginFill(CocoUI.themeSelectedColor);
			graphics.drawRect(thumbButton.width / 2, 3, width - thumbButton.width, height - 6);
			graphics.endFill();
			
			thumbMaxX = width - thumbButton.width;
			valuePerX = (maxValue - minValue) / thumbMaxX;
			thumbButton.x = (value - minValue) / valuePerX;
		}
		
		protected function thumbButton_mouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
			oldMouseX = mouseX;
			oldThumbX = thumbButton.x;
		}
		
		protected function this_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, this_mouseUpHandler);
		}
		
		protected function this_mouseMoveHandler(event:MouseEvent):void
		{
			var newThumbX:Number = oldThumbX + mouseX - oldMouseX;
			if (newThumbX < 0)
				newThumbX = 0;
			else if (newThumbX > thumbMaxX)
				newThumbX = thumbMaxX;
			thumbButton.x = newThumbX;
			_value = newThumbX * valuePerX + minValue;
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
	}
}