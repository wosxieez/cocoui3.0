package coco.component
{
    import coco.event.UIEvent;
    import coco.util.CocoUI;
    
    import flash.events.MouseEvent;
    
    
    [Event(name="ui_change", type="coco.event.UIEvent")]
    
    /**
     *
     * ToggleButton
     *  
     * @author Coco
     * 
     */    
    public class ToggleButton extends Button
    {
        public function ToggleButton()
        {
            super();
            
            mouseChildren = false;
            addEventListener(MouseEvent.CLICK, this_clickHandler);
        }
        
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Properties
        //
        //----------------------------------------------------------------------------------------------------------------
        
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
        
        protected function this_clickHandler(event:MouseEvent):void
        {
            selected = !selected;
            dispatchEvent(new UIEvent(UIEvent.CHANGE));
        }
        
    }
}