package coco.component
{
    import coco.core.UIComponent;
    import coco.event.UIEvent;
    import coco.util.CocoUI;

	
	/**
	 * 此事件正常由ItemRendererOwnerHelper派发</br>
	 * 如果手动终止渲染器的选中事件， 监听到此事件的时候阻止默认派发即可</br>
	 * <code>addEventListener(UIEvent.SELECTED, this_selectedHandler)</code>
	 * <code>e.preventDefault()</code></br>
	 * 
	 * @author Coco 
	 * 
	 */	
	[Event(name="ui_selected", type="coco.event.UIEvent")]
    /**
     * ItemRenderer渲染器
     *
     * <p>默认的渲染器</p>
     *
     * @author Coco
     */
    public class ItemRenderer extends UIComponent implements IItemRenderer
    {
        public function ItemRenderer()
        {
            super();
        }

        //----------------------------------------------------------------------------------------------------------------
        //
        // Properties
        //
        //----------------------------------------------------------------------------------------------------------------

        private var _data:Object;

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            _data = value;
        }

        private var _index:int;

        public function get index():int
        {
            return _index;
        }

        public function set index(value:int):void
        {
            _index = value;
        }

        private var _labelField:String = "label";

        public function get labelField():String
        {
            return _labelField;
        }

        public function set labelField(value:String):void
        {
            _labelField = value;
        }

        private var _selected:Boolean = false;

        public function get selected():Boolean
        {
            return _selected;
        }

        public function set selected(value:Boolean):void
        {
            _selected = value;
        }

        //----------------------------------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override protected function measure():void
        {
            measuredWidth = 100;
            measuredHeight = 40;
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();

            graphics.clear();
            graphics.lineStyle(1, CocoUI.themeBorderColor);
            graphics.beginFill(CocoUI.themeBackgroundColor);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
        }
    }
}