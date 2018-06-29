package coco.component
{
	import flash.geom.Rectangle;
	
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	[Event(name="ui_selected", type="coco.event.UIEvent")]
	
	
	/**
	 * List Component
	 * 
	 * Not Support Layout
	 * 
	 * @author Coco
	 */	
	public class List extends Scroller implements IItemRendererOwner
	{
		public function List()
		{
			super();
			
			itemRendererOwnerHelper = new ItemRendererOwnerHelper(this);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  变量
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var itemRendererOwnerHelper:ItemRendererOwnerHelper;
		private var dataViewPort:UIComponent;
		private var useRow:Boolean = false;
		private var itemRendererHeight:Number = 0;
		private var itemRendererWidth:Number = 0;
		
		//--------------------------------
		// 数据源
		//--------------------------------
		private var _dataProvider:Array = null;
		
		/**
		 * 数据源
		 * 
		 * @return 
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
		
		//--------------------------------
		// 渲染器类
		//--------------------------------
		private var _itemRendererClass:Class = DefaultItemRenderer;
		
		/**
		 * 渲染器类
		 * 
		 * @return 
		 */		
		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}
		
		public function set itemRendererClass(value:Class):void
		{
			if (_itemRendererClass == value)
				return;
			
			_itemRendererClass = value;
			
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 行 列间距
		//--------------------------------
		private var _gap:Number = 0;
		
		/**
		 * 行行之间  列列之间间距
		 * @return 
		 */		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if (_gap == value)
				return;
			
			_gap = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 左边距
		//--------------------------------	
		private var _paddingLeft:Number = 0;
		
		/**
		 * 左边距
		 * @return 
		 */		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 上边距
		//--------------------------------	
		private var _paddingTop:Number = 0;
		
		/**
		 * 上边距
		 * @return 
		 */		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 右边距
		//--------------------------------		
		private var _paddingRight:Number = 0;
		
		/**
		 * 右边距
		 * @return 
		 */		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 下边距
		//--------------------------------
		private var _paddingBottom:Number = 0;
		
		/**
		 * 下边距
		 * @return 
		 */		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 列数
		//--------------------------------
		private var _columns:int = 0;
		
		/**
		 * 列数 
		 */
		public function get columns():int
		{
			return _columns;
		}
		
		/**
		 * @private
		 */
		public function set columns(value:int):void
		{
			if (_columns == value)
				return;
			
			_columns = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 行数
		//--------------------------------
		
		// rows
		private var _rows:int = 0;
		
		public function get rows():int
		{
			return _rows;
		}
		
		public function set rows(value:int):void
		{
			if (_rows == value)
				return;
			
			_rows = value;
			invalidateDisplayList();
		}
		
		//--------------------------------
		// label Field
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
			invalidateDisplayList();
		}
		
		//--------------------------------
		// request selection
		//--------------------------------
		
		private var _requestSelection:Boolean = false;
		
		public function get requestSelection():Boolean
		{
			return _requestSelection;
		}
		
		public function set requestSelection(value:Boolean):void
		{
			if (_requestSelection == value) return;
			_requestSelection = value;
			callLater(updateSelected).descript = "updateSelected()";
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
			if (_selectedIndex == value) return;
			_selectedIndex = value;
			callLater(updateSelected).descript = "updateSelected()";
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
		
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			if (_allowMultipleSelection == value) return;
			_allowMultipleSelection = value;
			callLater(updateSelected).descript = "updateSelected()";
		}
		
		
		//--------------------------------
		// 选中的索引
		//--------------------------------
		
		private var _selectedIndices:Vector.<int> = new Vector.<int>();
		
		public function get selectedIndices():Vector.<int>
		{
			return _selectedIndices;
		}
		
		public function set selectedIndices(value:Vector.<int>):void
		{
			if (_selectedIndices == value) return;
			_selectedIndices = value;
			callLater(updateSelected).descript = "updateSelected()";
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
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Invalidate Validate Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var invalidateItemRendererDisplayListFlag:Boolean = false;
		
		private function invalidateItemRendererDisplayList():void
		{
			if (!invalidateItemRendererDisplayListFlag)
			{
				invalidateItemRendererDisplayListFlag = true;
				callLater(validateItemRendererDisplayList).descript = "updateItemRendererDisplayList()";
			}
		}
		
		private function validateItemRendererDisplayList():void
		{
			if (invalidateItemRendererDisplayListFlag)
			{
				invalidateItemRendererDisplayListFlag = false;
				updateItemRendererDisplayList();
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			dataViewPort = new UIComponent();
			addChild(dataViewPort);
		}
		
		private function updateSelected():void
		{
			// set selected index
			if (selectedIndex == -1 && requestSelection)
				selectedIndex = 0;
			
			if (selectedIndex != -1 && selectedIndices.indexOf(selectedIndex) == -1)
				selectedIndices.unshift(selectedIndex);
			
			itemRendererOwnerHelper.updateSelected();
		}
		
		override protected function updateDisplayList():void
		{
            updateItemRenderer();
			super.updateDisplayList();
			invalidateItemRendererDisplayList();
		}
		
		/**
		 * 更新窗口视图
		 */		
		override protected function updateViewport():void
		{
			if (columns > 0)
				useRow = false;
			else if (rows > 0)
				useRow = true;
			else
			{
				// not set columns rows , default set columns 1
				columns = 1;
				useRow = false;
			}
			
			if (useRow)
			{
				verticalScrollEnabled = false;
				horizontalScrollEnabled = true;
				horizontalScrollPosition = minHorizontalScrollPosition = width - paddingLeft - paddingRight;
				maxHorizontalScrollPosition = dataProvider ? Math.ceil(dataProvider.length / rows) * (itemRendererWidth + gap) - gap : 0;
				maxHorizontalScrollPosition = maxHorizontalScrollPosition < minHorizontalScrollPosition ? minHorizontalScrollPosition : maxHorizontalScrollPosition; 
				itemRendererHeight = (height - paddingTop - paddingBottom - (rows - 1) * gap) / rows;
			}
			else
			{
				horizontalScrollEnabled = false;
				verticalScrollEnabled = true;
				verticalScrollPosition = minVerticalScrollPosition = height - paddingTop - paddingBottom;
				maxVerticalScrollPosition = dataProvider ? Math.ceil(dataProvider.length / columns) * (itemRendererHeight + gap) - gap : 0;
				maxVerticalScrollPosition = maxVerticalScrollPosition < minVerticalScrollPosition ? minVerticalScrollPosition : maxVerticalScrollPosition;
				itemRendererWidth = (width - paddingLeft - paddingRight - (columns - 1) * gap) / columns;
			}
			
			dataViewPort.x = paddingLeft;
			dataViewPort.y = paddingTop;
			dataViewPort.width = width - paddingLeft - paddingRight;
			dataViewPort.height = height - paddingTop - paddingBottom;
			dataViewPort.scrollRect = new Rectangle(0, 0, dataViewPort.width, dataViewPort.height);
		}
		
		override protected function updateViewportPosition():void
		{
			invalidateItemRendererDisplayList();
		}
		
		/**
		 * 更新渲染器
		 */		
		private function updateItemRenderer():void
		{
			if (dataViewPort)
				dataViewPort.removeAllChild();
			itemRendererOwnerHelper.usedItemRenderers = new Vector.<IItemRenderer>();
			itemRendererOwnerHelper.unusedItemRenderers = new Vector.<IItemRenderer>();
			
			// get itemRenderer height
			if (itemRendererClass)
			{
				var item:IItemRenderer = new itemRendererClass();
				itemRendererHeight = item.height == 0 ? 40 : item.height;
				itemRendererWidth = item.width == 0 ? 40 : item.width;
				item = null;
			}
			else
				itemRendererHeight = itemRendererWidth = 0;
		}
		
		/**
		 * 更新渲染器显示列表
		 */		
		private function updateItemRendererDisplayList():void
		{
			if (!itemRendererClass ||
				(!dataProvider || dataProvider.length == 0)) 
				return;
			var visibleItemRendererIndexPositions:Vector.<ItemRendererIndexPosition> = getVisibleItemRendererIndices();
			setUnusedItemRenderers(visibleItemRendererIndexPositions);
			setUsedItemRenderer(visibleItemRendererIndexPositions);
			
			updateSelected();
		}
		
		/**
		 * 获取所有可视渲染器的索引位置
		 * @return 
		 */		
		private function getVisibleItemRendererIndices():Vector.<ItemRendererIndexPosition>
		{
			var visibleItemRendererIndexPositions:Vector.<ItemRendererIndexPosition> =  new Vector.<ItemRendererIndexPosition>();
			if (!dataProvider)
				return visibleItemRendererIndexPositions;
			
			var max:Number;
			var min:Number;
			if (useRow)
			{
				max = horizontalScrollPosition;
				min = max - minHorizontalScrollPosition;
			}
			else
			{
				max = verticalScrollPosition;
				min = max - minVerticalScrollPosition;
			}
			
			var itemLenght:int = dataProvider.length; // just for speed
			for (var i:int = 0; i < itemLenght; i++)
			{
				var itemIndexPosition:ItemRendererIndexPosition = getItemRendererIndexPosition(i);
				var itemMin:Number;
				var itemMax:Number;
				if (useRow)
				{
					itemMin = itemIndexPosition.x;
					itemMax = itemMin + itemRendererWidth + gap;
				}
				else
				{
					itemMin = itemIndexPosition.y;
					itemMax = itemMin + itemRendererHeight + gap;
				}
				
				if (itemMax > min && itemMin < max)
					visibleItemRendererIndexPositions.push(itemIndexPosition);
			}
			
			return visibleItemRendererIndexPositions;
		}
		
		/**
		 * 根据索引获取 索引位置
		 * 
		 * @param index
		 * @return 
		 */		
		private function getItemRendererIndexPosition(index:int):ItemRendererIndexPosition
		{
			if (useRow)
				return new ItemRendererIndexPosition(index, 
					Math.floor(index / rows) * (itemRendererWidth + gap), 
					index % rows * (itemRendererHeight + gap));
			else
				return new ItemRendererIndexPosition(index, 
					index % columns * (itemRendererWidth + gap), 
					Math.floor(index / columns) * (itemRendererHeight + gap));
		}
		
		/**
		 * 设置未使用的渲染器
		 */		
		private function setUnusedItemRenderers(visibleItemRendererIndexPositions:Vector.<ItemRendererIndexPosition>):void
		{
			var itemRenderer:IItemRenderer;
			for (var i:int = itemRendererOwnerHelper.usedItemRenderers.length - 1; i >= 0; i--)
			{
				itemRenderer = itemRendererOwnerHelper.usedItemRenderers[i];
				if (!hasIndex(itemRenderer.index))
				{
					itemRendererOwnerHelper.usedItemRenderers.splice(i, 1);
					itemRendererOwnerHelper.remove(itemRenderer);
				}
			}
			
			function hasIndex(index:int):Boolean
			{
				for each (var itemRendererIndexPosition:ItemRendererIndexPosition in visibleItemRendererIndexPositions)
				{
					if (itemRendererIndexPosition.index == index)
						return true;
				}
				
				return false;
			}
		}
		
		/**
		 * 设置渲染器
		 * 
		 * @param newItemRendererIndices
		 */		
		private function setUsedItemRenderer(visibleItemRendererIndexPositions:Vector.<ItemRendererIndexPosition>):void
		{
			for each (var itemRendererIndexPosition:ItemRendererIndexPosition in visibleItemRendererIndexPositions)
			{
				var item:IItemRenderer = getItemRenderer(itemRendererIndexPosition.index);
				if (useRow)
				{
					item.y = itemRendererIndexPosition.y;
					item.x = itemRendererIndexPosition.x - horizontalScrollPosition + minHorizontalScrollPosition;
				}
				else
				{
					item.y = itemRendererIndexPosition.y - verticalScrollPosition + minVerticalScrollPosition;
					item.x = itemRendererIndexPosition.x;
				}
				item.width = itemRendererWidth;
				item.height = itemRendererHeight;
			}
		}
		
		/**
		 * 根据索引获取渲染器
		 * 
		 * @param index
		 * @return 
		 */		
		private function getItemRenderer(index:int):IItemRenderer
		{
			var usedItem:IItemRenderer = getItemRendererFromUsedItemRenderers(index);
			if (usedItem)
				return usedItem;
			else
			{
				var unusedItem:IItemRenderer = getItemRendererFromUnusedItemRenderersOrNew();
				if (unusedItem)
				{
					unusedItem.data = dataProvider[index];
					unusedItem.index = index;
					unusedItem.labelField = labelField;
					itemRendererOwnerHelper.add(unusedItem);
				}
				return unusedItem;
			}
		}
		
		/**
		 * 在使用的渲染器队列中找到指定索引的渲染器
		 * 
		 * @param index
		 * @return 
		 * 
		 */		
		private function getItemRendererFromUsedItemRenderers(index:int):IItemRenderer
		{
			for each (var item:IItemRenderer in itemRendererOwnerHelper.usedItemRenderers)
			{
				if (item.index == index)
					return item;
			}
			
			return null;
		}
		
		/**
		 * 获取未使用的渲染器，如果没有未使用的渲染器则将生成新的渲染器
		 * 
		 * @return 
		 */		
		private var i:int = 1;
		private function getItemRendererFromUnusedItemRenderersOrNew():IItemRenderer
		{
			if (itemRendererOwnerHelper.unusedItemRenderers.length > 0)
				return itemRendererOwnerHelper.unusedItemRenderers.shift();
			else
			{
				var item:IItemRenderer = new itemRendererClass() as IItemRenderer;
				dataViewPort.addChild(item as UIComponent);
				return item;
			}
		}
		
	}
}

/**
 * 索引位置
 * 
 * 指示渲染器的索引跟位置信息
 * 
 * @author Coco
 */
class ItemRendererIndexPosition
{
	public function ItemRendererIndexPosition(index:int, x:Number, y:Number)
	{
		this.index = index;
		this.x = x;
		this.y = y;
	}
	
	public var index:int;
	public var x:Number;
	public var y:Number;
}