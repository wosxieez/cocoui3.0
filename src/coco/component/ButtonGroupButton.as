package coco.component
{
    import coco.util.CocoUI;
	

    /**
     * 
     * ButtonGroupButton used for ButtonGroup
     * 
     * @author Coco
     * 
     */    
    public class ButtonGroupButton extends Button implements IItemRenderer
    {
        public function ButtonGroupButton()
        {
            super();
        }
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
        
		//--------------------------------
		// data
		//--------------------------------
        private var _data:Object;

        public function get data():Object
        {
            return _data;
        }
        
        public function set data(value:Object):void
        {
            if (_data == value) return;
            _data = value;
            invalidateProperties();
        }
		
		
		//--------------------------------
		// labelField
		//--------------------------------
		private var _labelField:String;
		
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField == value) return;
			_labelField = value;
			invalidateProperties();
		}

		
		//--------------------------------
		// index
		//--------------------------------
        private var _index:int;

        public function get index():int
        {
            return _index;
        }

        public function set index(value:int):void
        {
			if (_index == value) return;
            _index = value;
        }
		
		
		//--------------------------------
		// selected
		//--------------------------------
		private var _selected:Boolean = false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value) return;
			_selected = value;
			invalidateDisplayList();
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (_data && _data.hasOwnProperty(_labelField)) 
                label = _data[_labelField];
            else
                label = _data as String;
        }
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (selected)
			{
				graphics.beginFill(CocoUI.themeSelectedColor);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}
        
    }
}