package coco.component
{
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	
	/**
	 * 发生改变的时候派发此事件
	 * 
	 * @author Coco
	 * 
	 */	
	[Event(name="ui_chagne", type="coco.event.UIEvent")]
	/**
	 * 
	 * @author Coco
	 * 
	 */	
	public class ColorPicker extends UIComponent
	{
		public function ColorPicker()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var list:PageList;
		
		private var _selectedColor:uint;

		/**
		 * 选中的颜色值  
		 * 
		 * @return 
		 * 
		 */		
		public function get selectedColor():uint
		{
			return _selectedColor;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			list = new PageList();
			list.columns = 20;
			list.rows = 12;
			list.itemRendererClass = ColorRenderer;
			list.dataProvider = getList();
			list.addEventListener(UIEvent.CHANGE, list_indexChangeHandler);
			addChild(list);
		}
		
		override protected function measure():void
		{
			measuredWidth = 220; // 20 * 11
			measuredHeight = 132; // 11 * 12
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			list.width = width;
			list.height = height;
		}
		
		protected function list_indexChangeHandler(event:UIEvent):void
		{
			if (event.newIndex == -1) return;
			_selectedColor = list.selectedItem as uint;
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		/**
		 * 
		 * From Adobe Method
		 * 
		 * @return 
		 * 
		 */		
		private function getList():Array
		{
			var dp:Array = [];
			
			var n:Number = 0;
			
			var spacer:Number = 0x000000;
			
			var c1:Array = [ 0x000000, 0x333333, 0x666666, 0x999999,
				0xCCCCCC, 0xFFFFFF, 0xFF0000, 0x00FF00,
				0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF ];
			
			var ra:Array = [ "00", "00", "00", "00", "00", "00",
				"33", "33", "33", "33", "33", "33",
				"66", "66", "66", "66", "66", "66" ];
			
			var rb:Array = [ "99", "99", "99", "99", "99", "99",
				"CC", "CC", "CC", "CC", "CC", "CC",
				"FF", "FF", "FF", "FF", "FF", "FF" ];
			
			var g:Array = [ "00", "33", "66", "99", "CC", "FF",
				"00", "33", "66", "99", "CC", "FF",
				"00", "33", "66", "99", "CC", "FF" ];
			
			var b:Array = [ "00", "33", "66", "99", "CC", "FF",
				"00", "33", "66", "99", "CC", "FF" ];
			
			for (var x:int = 0; x < 12; x++)
			{
				for (var j:int = 0; j < 20; j++)
				{
					var item:Number;
					
					if (j == 0)
					{
						item = c1[x];
						
					}
					else if (j == 1)
					{
						item = spacer;
					}
					else
					{
						var r:String;
						if (x < 6)
							r = ra[j - 2];
						else
							r = rb[j - 2];
						item = Number("0x" + r + g[j - 2] + b[x]);
					}
					
					dp.push(item);
					n++;
				}
			}
			
			return dp;
		}
		
	}
}
import coco.component.ItemRenderer;


class ColorRenderer extends ItemRenderer
{
	public function ColorRenderer()
	{
		mouseChildren = false;
//		addEventListener(MouseEvent.ROLL_OVER, this_rollOverHandler);
//		addEventListener(MouseEvent.ROLL_OUT, this_rollOutHandler);
	}
	
//	private var _isOver:Boolean = false;
//
//	public function get isOver():Boolean
//	{
//		return _isOver;
//	}
//
//	public function set isOver(value:Boolean):void
//	{
//		if (_isOver == value) return;
//		_isOver = value;
//		invalidateDisplayList();
//	}
	
	override public function set data(value:Object):void
	{
		if (super.data == value) return;
		super.data = value;
		invalidateDisplayList();
	}
	
	override protected function updateDisplayList():void
	{
		super.updateDisplayList();
		
		graphics.clear();
		graphics.lineStyle(1, 0);
		graphics.beginFill(uint(data));
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
	
//	protected function this_rollOutHandler(event:MouseEvent):void
//	{
//		isOver = false;
//	}
//	
//	protected function this_rollOverHandler(event:MouseEvent):void
//	{
//		isOver = true;
//	}
}