package coco.component
{
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	import coco.util.CocoUI;
	import coco.util.DateUtil;
	
	import flash.events.MouseEvent;
	
	/**
	 * Dispatched when date was changed
	 */	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	
	/**
	 * Date Chooser Component
	 * 
	 * <pre>
	 * 1 2 3 4 5 6 7
	 * 1 2 3 4 5 6 7
	 * 1 2 3 4 5 6 7
	 * 1 2 3 4 5 6 7
	 * 1 2 3 4 5 6 7
	 * </pre>
	 * 
	 * @author Coco
	 * 
	 */	
	public class DateChooser extends UIComponent
	{
		public function DateChooser()
		{
			super();
			
			var todayDate:Date = new Date();
			_year = todayDate.fullYear;
			_month = todayDate.month;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var decrementButton:Button;
		protected var labelDisplay:Label;
		protected var incrementButton:Button;
		protected var dateList:PageList;
		
		//---------------------
		//	firstDayOfWeek
		//---------------------
		
		private var _firstDayOfWeek:int = 0;
		
		/**
		 *
		 * <pre>
		 * 0 => 日
		 * 1 => 一
		 * 2 => 二
		 * 3 => 三
		 * 4 => 四
		 * 5 => 五
		 * 6 => 六
		 *  </pre>
		 * @return 
		 * 
		 */		
		public function get firstDayOfWeek():int
		{
			return _firstDayOfWeek;
		}
		
		public function set firstDayOfWeek(value:int):void
		{
			if (_firstDayOfWeek == value) return;
			_firstDayOfWeek = value;
			invalidateProperties();
		}
		
		//---------------------
		//	Year
		//---------------------
		
		private var _year:int = 0;
		
		public function get year():int
		{
			return _year;
		}
		
		public function set year(value:int):void
		{
			if (_year == value) return;
			_year = value;
			invalidateProperties();
		}
		
		//---------------------
		//	Month
		//---------------------
		
		private var _month:int = 0;
		
		/**
		 * 0-11
		 *  
		 * @return 
		 * 
		 */		
		public function get month():int
		{
			return _month;
		}
		
		public function set month(value:int):void
		{
			if (_month == value) return;
			_month = value;
			invalidateProperties();
		}
		
		
		//---------------------
		//	itemRendererClass
		//---------------------
		
		private var _itemRendererClass:Class = DateItemRenderer;
		
		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}
		
		public function set itemRendererClass(value:Class):void
		{
			if (_itemRendererClass == value) return;
			_itemRendererClass = value;
			invalidateProperties();
		}
		
		
		//---------------------
		// selectedDate
		//---------------------
		
		private var _selectedDate:Date;
		
		public function get selectedDate():Date
		{
			return _selectedDate;
		}
		
		public function set selectedDate(value:Date):void
		{
			if (_selectedDate == value) return;
			_selectedDate = value;
			invalidateProperties();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			decrementButton = new Button();
			decrementButton.width = decrementButton.height = 40;
			decrementButton.addEventListener(MouseEvent.CLICK, decrementButton_clickHandler);
			decrementButton.label = "<";
			addChild(decrementButton);
			
			labelDisplay = new Label();
			labelDisplay.height = labelDisplay.x = 40;
			addChild(labelDisplay);
			
			incrementButton = new Button();
			incrementButton.width = incrementButton.height = 40;
			incrementButton.label = ">";
			incrementButton.addEventListener(MouseEvent.CLICK, incrementButton_clickHandler);
			addChild(incrementButton);
			
			dateList = new PageList();
			dateList.y = 40;
			dateList.addEventListener(UIEvent.CHANGE, dateList_indexChangedHandler);
			dateList.columns = 7;
			dateList.rows = 7;
			addChild(dateList);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			labelDisplay.text = _year + '-' + (_month + 1);
			dateList.selectedIndex = -1;
			
			var dateListData:Array = [];
			var dateItemData:DateItemData;
			var startDate:Date = new Date(_year, _month, 1);
			var i:int = 0;
			// fill day names
			for (i = 0; i < 7; i++)
			{
				dateItemData = new DateItemData();
				dateItemData.isName = true;
				dateItemData.isDisable = true;
				dateItemData.label = DateUtil.dayNames[(firstDayOfWeek + i) % 7];
				dateListData.push(dateItemData);
			}
			
			// fill pre month date
			var preMonthDays:int = getOffsetOfPreMonth(year, month);
			i = preMonthDays;
			while (i > 0)
			{
				dateItemData = new DateItemData();
				dateItemData.isDisable = true;
				dateItemData.label = DateUtil.addDay(startDate, -i).date.toString();
				dateListData.push(dateItemData);
				i--;
			}
			
			//fill this month date
			var thisMonthDays:int = DateUtil.getMonthDays(year, month);
			for (i = 0; i < thisMonthDays; i++)
			{
				dateItemData = new DateItemData();
				dateItemData.date = DateUtil.addDay(startDate, i);
				dateItemData.label = dateItemData.date.date.toString();
				dateListData.push(dateItemData);
				
				// set selected
				if (isSelected(dateItemData.date))
					dateList.selectedIndex = dateListData.length - 1;
			}
			
			// fill next month date
			var nextMonthDays:int = 42 - preMonthDays - thisMonthDays;
			for (i = 0; i < nextMonthDays; i++)
			{
				dateItemData = new DateItemData();
				dateItemData.isDisable = true;
				dateItemData.label = DateUtil.addDay(startDate, i + thisMonthDays).date.toString();
				dateListData.push(dateItemData);
			}
			
            dateList.itemRendererClass = itemRendererClass;
			dateList.dataProvider = dateListData;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = 300;
			measuredHeight = 250;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// draw bg skin
			graphics.clear();
			graphics.lineStyle(1, CocoUI.themeBorderColor);
			graphics.beginFill(CocoUI.themeBackgroundColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			incrementButton.x = width - incrementButton.height;
			labelDisplay.width = width - 80;
			dateList.width = width;
			dateList.height = height - dateList.y;
		}
		
		private function isSelected(date:Date):Boolean
		{
			if (selectedDate && 
				date &&
				selectedDate.fullYear == date.fullYear &&
				selectedDate.month == date.month &&
				selectedDate.date == date.date)
				return true;
			else
				return false;
		}
		
		/**
		 * 获取上个月偏移天数
		 * 
		 * @param year
		 * @param month 0-11
		 * @return 
		 */		
		private function getOffsetOfPreMonth(year:int, month:int):int
		{
			var first:Date = new Date(year, month, 1);
			var offset:int = first.getDay() - firstDayOfWeek;
			return offset < 0 ? offset + 7 : offset;
		}
		
		protected function incrementButton_clickHandler(event:MouseEvent):void
		{
			_month++;
			if (_month > 11)
			{
				_year += 1;
				_month = 0;
			}
			
			invalidateProperties();
		}
		
		protected function decrementButton_clickHandler(event:MouseEvent):void
		{
			_month--;
			if (_month < 0)
			{
				_year -= 1;
				_month = 11;
			}
			
			invalidateProperties();
		}
		
		protected function dateList_indexChangedHandler(event:UIEvent):void
		{
			if (event.newIndex == -1)
				_selectedDate = null;
			else
				_selectedDate = dateList.selectedItem.date;
			
			// dispatch date changed event
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
	}
}

import coco.component.DefaultItemRenderer;
import coco.event.UIEvent;
import coco.util.CocoUI;

/**
 * DateItemData
 * 
 * @author Coco
 * 
 */
class DateItemData
{
	public var isName:Boolean;
	public var isDisable:Boolean;
	public var label:String;
	public var date:Date;
}


/**
 * DateItemRenderer
 * 
 * @author Coco
 * 
 */
class DateItemRenderer extends DefaultItemRenderer
{
    public function DateItemRenderer()
    {
        super();
        addEventListener(UIEvent.SELECTED, this_selectedHandler);
    }
    
    override public function set data(value:Object):void
    {
        if (super.data == value) return;
        super.data = value;
        
        invalidateProperties();
    }
    
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (data && data is DateItemData && DateItemData(data).isDisable && !DateItemData(data).isName)
            labelDisplay.color = CocoUI.themeFontDisabledColor;
        else
            labelDisplay.color = CocoUI.themeFontEnabledColor;
    }
    
    private function this_selectedHandler(e:UIEvent):void
    {
        // prevent selected event
        if (data is DateItemData && DateItemData(data).isDisable)
            e.preventDefault();
    }
    
}
