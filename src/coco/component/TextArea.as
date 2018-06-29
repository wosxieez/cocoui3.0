package coco.component
{
	import flash.text.TextFormatAlign;
	
	import coco.util.CocoUI;

	public class TextArea extends TextInput
	{
		public function TextArea()
		{
			super();
			
			textAlign = TextFormatAlign.LEFT;
			wordWrap = true;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			textField.multiline = true;
		}
        
        override protected function measure():void
        {
            measuredWidth = measuredHeight = 200;
        }
		
		override protected function updateDisplayList():void
		{
			textField.width = width - 10;
			textField.height = height - 10;
			textField.x = 5;
			textField.y = 5;
			
			// draw bg skin
			graphics.clear();
			graphics.lineStyle(1, CocoUI.themeBorderColor);
			graphics.beginFill(CocoUI.themeBackgroundColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
	}
}