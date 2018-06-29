package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	
	[Event(name="ui_updateComplete", type="coco.event.UIEvent")]
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	[Event(name="ui_selected", type="coco.event.UIEvent")]
	
	/**
	 * 
	 *<pre>PageList
	 *页面列表组件
	 *不支持布局
	 *Not Support Layout
	 *</pre>
	 * @author Coco
	 */    
	public class PageList extends UIComponent implements IItemRendererOwner
	{
		public function PageList()
		{
			super();
			
			itemRendererOwnerHelper = new ItemRendererOwnerHelper(this);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		
		private var itemRendererOwnerHelper:ItemRendererOwnerHelper;
		private var dataViewPort:UIComponent;
		
		private var _dataProvider:Array;
		
		/**
		 *数据源 
		 * @return 
		 * 
		 */        
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			invalidateDisplayList();
		}
		
		private var _currentPage:int = 1;
		
		/**
		 *当前页 
		 * @return 
		 * 
		 */        
		public function get currentPage():int
		{
			if (_currentPage < 1) return 1;
			if (_currentPage > totalPage) return totalPage;
			return _currentPage;
		}
		
		public function set currentPage(value:int):void
		{
			if (_currentPage == value) return;
			_currentPage = value;
			invalidateDataViewPort();
		}
		
		private var _totalPage:int = 0;
		
		/**
		 *总页数 
		 * @return 
		 * 
		 */        
		public function get totalPage():int
		{
			if (_totalPage < 0) return 0;
			return _totalPage;
		}
		
		private var _columns:int = 1;
		
		/**
		 *列数 
		 * @return 
		 * 
		 */        
		public function get columns():int
		{
			if (_columns < 1) return 1;
			return _columns;
		}
		
		public function set columns(value:int):void
		{
			if (_columns == value) return;
			_columns = value;
			invalidateDisplayList();
		}
		
		private var _rows:int = 5;
		
		/**
		 *行数
		 * @return 
		 * 
		 */        
		public function get rows():int
		{
			if (_rows < 1) return 1;
			return _rows;
		}
		
		public function set rows(value:int):void
		{
			if (_rows == value) return;
			_rows = value;
			invalidateDisplayList();
		}
		
		private var _paddingLeft:Number = 0;
		
		/**
		 *左边距 
		 * @return 
		 * 
		 */        
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value) return;
			_paddingLeft = value;
			invalidateDisplayList();
		}
		
		private var _paddingTop:Number = 0;
		
		/**
		 *上边距 
		 * @return 
		 * 
		 */        
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value) return;
			_paddingTop = value;
			invalidateDisplayList();
		}
		
		/**
		 *右边距 
		 */        
		private var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value) return;
			_paddingRight = value;
			invalidateDisplayList();
		}
		
		private var _paddingBottom:Number = 0;
		
		/**
		 *下边距 
		 * @return 
		 * 
		 */        
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value) return;
			_paddingBottom = value;
			invalidateDisplayList();
		}
		
		private var _gap:Number = 0;
		
		/**
		 *间隔缝隙 
		 * @return 
		 * 
		 */        
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if (_gap == value) return;
			_gap = value;
			invalidateDisplayList();
		}
		
		private var _itemRendererClass:Class = DefaultItemRenderer;
		
		/**
		 *渲染器 
		 * @return 
		 * 
		 */        
		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}
		
		public function set itemRendererClass(value:Class):void
		{
			if (_itemRendererClass == value) return;
			_itemRendererClass = value;
			
			itemRendererOwnerHelper.usedItemRenderers = new Vector.<IItemRenderer>();
			itemRendererOwnerHelper.unusedItemRenderers = new Vector.<IItemRenderer>();
			invalidateDataViewPort();
		}
		
		//--------------------------------
		// label Field
		//--------------------------------
		
		private var _labelField:String = "label";
		
		/**
		 *文本域 
		 * @return 
		 * 
		 */        
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField == value) return;
			_labelField = value;
			invalidateDataViewPort();
		}
		
		//--------------------------------
		// 选中的索引
		//--------------------------------
		private var _selectedIndex:int = -1;
		
		/**
		 * 选中的索引 
		 */	
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value)
				return;
			
			_selectedIndex = value;
			invalidateProperties();
		}
		
		//--------------------------------
		// 选中的对象
		//--------------------------------
		
		/**
		 * 选中的对象
		 */	
		public function get selectedItem():Object
		{
			if (!dataProvider || 
				dataProvider.length == 0 ||
				selectedIndex < 0 ||
				selectedIndex >= dataProvider.length)
				return null;
			else
				return dataProvider[selectedIndex];
		}
		
		//--------------------------------
		// 是否允许多选
		//--------------------------------
		
		private var _allowMultipleSelection:Boolean = false;
		
		/**
		 *是否支持多选 
		 * @return 
		 * 
		 */        
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			if (_allowMultipleSelection == value) return;
			_allowMultipleSelection = value;
			invalidateProperties();
		}
		
		//--------------------------------
		// 是否只是显示索引的渲染器
		//--------------------------------
		
		private var _displayItemRendererFull:Boolean = false;
		
		/**
		 * true 渲染器将铺满所有行跟列</br>
		 * false渲染器根据显示的索引进行显示</br>
		 * 默认为false
		 * @return 
		 */		
		public function get displayItemRendererFull():Boolean
		{
			return _displayItemRendererFull;
		}
		
		public function set displayItemRendererFull(value:Boolean):void
		{
			if (_displayItemRendererFull == value) return;
			_displayItemRendererFull = value;
			invalidateDataViewPort();
		}
		
		
		//--------------------------------
		// 选中的索引
		//--------------------------------
		
		private var _selectedIndices:Vector.<int> = new Vector.<int>();
		
		/**
		 *选中的索引 
		 * @return 
		 * 
		 */        
		public function get selectedIndices():Vector.<int>
		{
			return _selectedIndices;
		}
		
		public function set selectedIndices(value:Vector.<int>):void
		{
			if (_selectedIndices == value) return;
			_selectedIndices = value;
			invalidateProperties();
		}
		
		
		//--------------------------------
		// 选中的对象
		//--------------------------------
		
		/**
		 * 选中的对象
		 */	
		public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			
			if (selectedIndices)
			{
				var count:int = selectedIndices.length;
				
				for (var i:int = 0; i < count; i++)
					result[i] = dataProvider[selectedIndices[i]];  
			}
			
			return result;
		}
		
		//--------------------------------
		// request selection
		//--------------------------------
		
		private var _requestSelection:Boolean = false;
		
		/**
		 *是否必须选择 
		 * @return 
		 * 
		 */        
		public function get requestSelection():Boolean
		{
			return _requestSelection;
		}
		
		public function set requestSelection(value:Boolean):void
		{
			if (_requestSelection == value) return;
			_requestSelection = value;
			invalidateProperties();
		}
		
		private var itemRendererWidth:Number;
		private var itemRendererHeight:Number;
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			// set selected index
			if (selectedIndex == -1 && requestSelection)
				selectedIndex = 0;
			
			if (selectedIndex != -1 && selectedIndices.indexOf(selectedIndex) == -1)
				selectedIndices.unshift(selectedIndex);
			
			itemRendererOwnerHelper.updateSelected();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = 200 * columns;
			measuredHeight = 30 * rows;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if (!displayItemRendererFull && !dataProvider) return;
			_totalPage = dataProvider ? Math.ceil(dataProvider.length / (rows * columns)) : 1;
			
			itemRendererWidth = (width - paddingLeft - paddingRight - (columns - 1) * gap) / columns;
			itemRendererHeight = (height - paddingTop - paddingBottom - (rows - 1) * gap) / rows;
			
			invalidateDataViewPort();
		}
		
		private var invalidateDataViewPortFlag:Boolean = false;
		
		public function invalidateDataViewPort():void
		{
			if (!invalidateDataViewPortFlag && initialized)
			{
				invalidateDataViewPortFlag = true;
				callLater(validateDataViewPort).descript = "updateDataViewPort()";
			}
		}
		
		public function validateDataViewPort():void
		{
			if (invalidateDataViewPortFlag)
			{
				invalidateDataViewPortFlag = false;
				updateDataViewPort();
			}
		}
		
		private function updateDataViewPort():void
		{
			freeItemRenderers();
			var indicesVisibled:Vector.<int> = getVisibledItemRendererIndices();
			if (indicesVisibled.length <= 0 && !displayItemRendererFull) return;
			var itemRendererNum:int = displayItemRendererFull ? rows * columns : indicesVisibled.length;
			var itemRenderer:IItemRenderer;
			var latestIndex:int = 0;
			for (var i:int = 0; i < itemRendererNum; i++)
			{
				itemRenderer = getItemRenderer();
				itemRenderer.width = itemRendererWidth;
				itemRenderer.height = itemRendererHeight;
				if (i < indicesVisibled.length)
				{
					latestIndex = itemRenderer.index = indicesVisibled[i];
					itemRenderer.data = dataProvider[itemRenderer.index];
					itemRenderer.labelField = labelField;
					// may be bug here
					itemRenderer.mouseEnabled = true;
				}
				else
				{
					itemRenderer.index = latestIndex;
					itemRenderer.data = null;
					itemRenderer.mouseEnabled = false;
				}
				itemRenderer.x = paddingLeft + (itemRendererWidth + gap) * (i % columns);
				itemRenderer.y = paddingTop + (itemRendererHeight + gap) * Math.floor(i / columns);
				itemRendererOwnerHelper.add(itemRenderer);
				latestIndex++;
			}
			
			// set selected index
			if (selectedIndex == -1 && requestSelection)
				selectedIndex = 0;
			
			if (selectedIndex != -1 && selectedIndices.indexOf(selectedIndex) == -1)
				selectedIndices.unshift(selectedIndex);
			
			itemRendererOwnerHelper.updateSelected();
			
			dispatchUpdateCompleteEvent();
		}
		
		private function dispatchUpdateCompleteEvent():void
		{
			if (hasEventListener(UIEvent.UPDATE_COMPLETE))
				dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
		}
		
		private function freeItemRenderers():void
		{
			var itemRenderer:IItemRenderer;
			while (itemRendererOwnerHelper.usedItemRenderers.length > 0)
			{
				itemRenderer = itemRendererOwnerHelper.usedItemRenderers.shift();
				itemRendererOwnerHelper.remove(itemRenderer);
			}
		}
		
		private function getVisibledItemRendererIndices():Vector.<int>
		{
			var indices:Vector.<int> = new Vector.<int>();
			if (!dataProvider || dataProvider.length == 0) return indices;
			
			var indexTotal:int = columns * rows;
			var indexStart:int = (currentPage - 1) * indexTotal;
			var indexVisbile:int;
			for (var i:int = 0; i < indexTotal; i++)
			{
				indexVisbile = indexStart + i;
				if (indexVisbile < dataProvider.length)
					indices.push(indexVisbile);
			}
			
			return indices;
		}
		
		
		private function getItemRenderer():IItemRenderer
		{
			var itemRenderer:IItemRenderer;
			if (itemRendererOwnerHelper.unusedItemRenderers.length > 0)
			{
				itemRenderer = itemRendererOwnerHelper.unusedItemRenderers.shift();
			}
			else
			{
				itemRenderer = new itemRendererClass();
				addChild(itemRenderer as DisplayObject);
			}
			
			return itemRenderer;
		}
		
	}
}