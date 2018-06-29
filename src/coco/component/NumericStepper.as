package coco.component
{
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	import coco.event.UIEvent;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	
	/**
	 * 
	 * Dispatched When value was changed
	 * 
	 * @author Coco
	 * 
	 */	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 * 
     * <pre><b>NumericStepper</b>
     * default width 120
     * default height 40</pre>
     * 
	 * @author Coco
	 * 
	 */	
	public class NumericStepper extends UIComponent
	{
		public function NumericStepper()
		{
			super();
		}
        
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//---------------------------------
		// maximum
		//--------------------------------- 
		
		private var maxChanged:Boolean = false;
		private var _maximum:int = 100;

		public function get maximum():int
		{
			return _maximum;
		}

		public function set maximum(value:int):void
		{
			if (_maximum == value) return;
			_maximum = value;
			maxChanged = true;
			invalidateProperties();
		}

		
		//---------------------------------
		// minimum
		//--------------------------------- 
		
		private var _minimum:int = 0;

		public function get minimum():int
		{
			return _minimum;
		}

		public function set minimum(value:int):void
		{
			if (_minimum == value) return;
			_minimum = value;
			invalidateProperties();
		}

		
		//---------------------------------
		// stepSize
		//--------------------------------- 
		
		private var _stepSize:int = 1;

		public function get stepSize():int
		{
			return _stepSize;
		}

		public function set stepSize(value:int):void
		{
			if (_stepSize == value) return;
			_stepSize = value;
		}

		
		//---------------------------------
		// value
		//--------------------------------- 
		
		private var _value:int = 0;

		public function get value():int
		{
			return _value;
		}

		public function set value(newValue:int):void
		{
			if (_value == newValue) return;
			_value = newValue;
			invalidateProperties();
		}
        
        //---------------------------------
        // editable
        //--------------------------------- 
        
        private var _editable:Boolean = true;

        public function get editable():Boolean
        {
            return _editable;
        }

        public function set editable(value:Boolean):void
        {
            if (_editable == value) return;
            _editable = value;
            invalidateProperties();
        }

		
		protected var decrementButton:Button;
		protected var textinput:TextInput;
		protected var incrementButton:Button;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			decrementButton = new Button();
			decrementButton.label = "-";
			decrementButton.addEventListener(MouseEvent.CLICK, decrementButton_clickHandler);
			addChild(decrementButton);
			
			textinput = new TextInput();
            textinput.textAlign = "center";
            textinput.restrict = "0-9";
            textinput.addEventListener(FocusEvent.FOCUS_OUT, this_focusOutHandler);
            textinput.addEventListener(UIEvent.ENTER, this_enterHandler);
            textinput.addEventListener(UIEvent.RESIZE, textinput_resizeHandler);
			addChild(textinput);
			
			incrementButton = new Button();
			incrementButton.label = "+";
			incrementButton.addEventListener(MouseEvent.CLICK, incrementButton_clickHandler);
			addChild(incrementButton);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
            
			// check min <= max
			if (minimum > maximum)
			{
				if (maxChanged)
					_maximum = _minimum;
				else
					_minimum = _maximum;
			}
            
            if (isNaN(value))
                _value = minimum;
            
            _value = _value - _value % stepSize
            
			// check min <= value <= max
			if (value < minimum)
				_value = _minimum;
			else if (value > maximum)
				_value = _maximum;
			
            textinput.editable = editable;
            textinput.text = value.toString();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredHeight = 40;
            measuredWidth = 3 * measuredHeight;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			decrementButton.width = decrementButton.height =
				incrementButton.width = incrementButton.height = height;
            textinput.x = height;
            textinput.width = width - height * 2;
			incrementButton.x = width - height;
		}
		
		protected function textinput_resizeHandler(event:UIEvent):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		protected function incrementButton_clickHandler(event:MouseEvent):void
		{
			changeValue(value + stepSize);
		}
		
		protected function decrementButton_clickHandler(event:MouseEvent):void
		{
			changeValue(value - stepSize);
		}
		
		private function changeValue(newValue:int):void
		{
			if (newValue < minimum ||
			    newValue > maximum) return;
			
			value = newValue;
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
        
        protected function this_focusOutHandler(event:FocusEvent):void
        {
            value = int(textinput.text);
            invalidateProperties();
        }
        
        protected function this_enterHandler(event:UIEvent):void
        {
            value = int(textinput.text);
            invalidateProperties();
        }
		
	}
}