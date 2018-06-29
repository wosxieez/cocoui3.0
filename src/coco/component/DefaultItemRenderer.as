package coco.component
{
    import coco.util.CocoUI;
	
    
    /**
     * DefaultItemRenderer
     *
     * <p>默认的渲染器</p>
     *
     * @author Coco
     */
    public class DefaultItemRenderer extends ItemRenderer
    {
        public function DefaultItemRenderer()
        {
            super();
        }
		
		
        //----------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //----------------------------------------------------------------------------------------------------------------
        
        protected var labelDisplay:Label;
        
        override public function set data(value:Object):void
        {
            if (super.data == value) return;
            super.data = value;
			invalidateProperties();
        }
		
		override public function set selected(value:Boolean):void
		{
            if (super.selected == value) return;
			super.selected = value;
			invalidateDisplayList();
		}
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            labelDisplay = new Label();
            addChild(labelDisplay);
        }
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (data)
			{
				if (data.hasOwnProperty(labelField))
					labelDisplay.text = data[labelField];
				else
					labelDisplay.text = data.toString();
			}
			else
				labelDisplay.text = "";
		}
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            labelDisplay.width = width;
            labelDisplay.height = height;
			
			graphics.clear();
			graphics.lineStyle(1, CocoUI.themeBorderColor);
			graphics.beginFill(selected ? CocoUI.themeSelectedColor : CocoUI.themeBackgroundColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
        }
    }
}
