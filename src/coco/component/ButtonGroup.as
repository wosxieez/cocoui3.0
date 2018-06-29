package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.event.UIEvent;
	import coco.layout.HorizontalLayout;
	
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	[Event(name="ui_selected", type="coco.event.UIEvent")]
	
	/**
	 * ButtonGroup </br>
	 * 
	 * Support Layout </br>
	 * 
	 * @author Coco
	 */    
	public class ButtonGroup extends Group implements IItemRendererOwner
	{
		public function ButtonGroup()
		{
			super();
			
			// button bar default use horizontal layout
			var hl:HorizontalLayout = new HorizontalLayout();
			hl.horizontalAlgin = "left";
			hl.verticalAlgin = "middle";
			layout = hl;
			
			itemRendererOwnerHelper = new ItemRendererOwnerHelper(this);
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Vars
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var itemRendererOwnerHelper:ItemRendererOwnerHelper;
		
		private var _dataProvider:Array;
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			invalidateProperties();
		}
		
		private var _itemRendererClass:Class = ButtonGroupButton;
		
		/**
		 *
		 * default is ButtonGroupButton
		 *  
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
			invalidateProperties();
		}
		
		private var _requestSelection:Boolean = false;

		public function get requestSelection():Boolean
		{
			return _requestSelection;
		}

		public function set requestSelection(value:Boolean):void
		{
			if (_requestSelection == value) return;
			_requestSelection = value;
			callLater(updateButtons).descript = "updateButtons()";
		}
		
		private var _selectedIndex:int = -1;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value) return;
			_selectedIndex = value;
			callLater(updateButtons).descript = "updateButtons()";
		}
		
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
			callLater(updateButtons).descript = "updateButtons()";
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
			callLater(updateButtons).descript = "updateButtons()";
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
		
		private var _labelField:String = "label";

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
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			createButtons();
			updateButtons();
		}
		
		private function createButtons():void
		{
			removeAllChild();
			if (!dataProvider || !itemRendererClass) return;
			
			itemRendererOwnerHelper.usedItemRenderers = new Vector.<IItemRenderer>();
			
			var itemRendererCount:int = dataProvider.length;
			var itemRenderer:IItemRenderer;
			for (var index:int = 0; index < itemRendererCount; index++)
			{
				itemRenderer = new itemRendererClass() as IItemRenderer;
				if (itemRenderer)
				{
					addChild(itemRenderer as DisplayObject);
					itemRendererOwnerHelper.add(itemRenderer);
				}
			}
		}
		
		private function updateButtons():void
		{
			// set selected index
			if (selectedIndex == -1 && requestSelection)
				selectedIndex = 0;
			
			if (selectedIndex != -1 && selectedIndices.indexOf(selectedIndex) == -1)
				selectedIndices.unshift(selectedIndex);
			
			var itemRendererCount:int = numChildren;
			var itemRenderer:IItemRenderer;
			for (var index:int = 0; index < itemRendererCount; index++)
			{
				itemRenderer = getChildAt(index) as IItemRenderer;
				if (itemRenderer)
				{
					itemRenderer.labelField = labelField;
					itemRenderer.data = dataProvider[index];
					itemRenderer.index = index;
				}
			}
			
			itemRendererOwnerHelper.updateSelected();
		}
		
		
	}
}