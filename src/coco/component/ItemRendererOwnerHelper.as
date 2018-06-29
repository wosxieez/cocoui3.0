package coco.component
{
	import flash.events.MouseEvent;
	
	import coco.event.UIEvent;
	import coco.event.UIEvent;
	import coco.util.debug;
	
	/**
	 * ItemRendererOwnerHelper
	 * 
	 * @author Coco 
	 * 
	 */	
	public class ItemRendererOwnerHelper
	{
		public function ItemRendererOwnerHelper(target:IItemRendererOwner)
		{
			owner = target;
			owner.addEventListener(UIEvent.SELECTED, renderer_selectingHandler);
			usedItemRenderers = new Vector.<IItemRenderer>();
			unusedItemRenderers = new Vector.<IItemRenderer>();
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private var isMouseDownOnRenderer:Boolean = false;
		private var isMouseOverOnRenderer:Boolean = false;
		private var mouseDownRenderer:IItemRenderer;
		private var owner:IItemRendererOwner;
		public var usedItemRenderers:Vector.<IItemRenderer>;
		public var unusedItemRenderers:Vector.<IItemRenderer>;
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		public function add(renderer:IItemRenderer):void
		{
			if (!renderer) return;
			
			debug('[ItemRendererOwnerHelper] [' + owner.name + '] Add ItemRenderer Index: ' + renderer.index);
			
			renderer.visible = true;
			renderer.addEventListener(MouseEvent.MOUSE_DOWN, renderer_mouseDownHandler);
			renderer.addEventListener(MouseEvent.MOUSE_UP, renderer_mouseUpHandler);
			renderer.addEventListener(MouseEvent.ROLL_OVER, renderer_rollOverHandler);
			renderer.addEventListener(MouseEvent.ROLL_OUT, renderer_rollOutHandler);
			
			usedItemRenderers.push(renderer);
		}
		
		public function remove(renderer:IItemRenderer):void
		{
			if (!renderer) return;
			
			debug('[ItemRendererOwnerHelper] [' + owner.name +'] Remove ItemRenderer Index: ' + renderer.index);
			
			renderer.visible = false;
			renderer.removeEventListener(MouseEvent.MOUSE_DOWN, renderer_mouseDownHandler);
			renderer.removeEventListener(MouseEvent.MOUSE_UP, renderer_mouseUpHandler);
			renderer.removeEventListener(MouseEvent.ROLL_OVER, renderer_rollOverHandler);
			renderer.removeEventListener(MouseEvent.ROLL_OUT, renderer_rollOutHandler);
			
			unusedItemRenderers.push(renderer);
		}
		
		public function updateSelected():void
		{
			debug('[ItemRendererOwnerHelper] [' + owner.name + '] Selected Indices: ' + owner.selectedIndices);
			for each (var itemRenderer:IItemRenderer in usedItemRenderers)
			{
				itemRenderer.selected = isSelected(itemRenderer);
			}
		}
		
		private function isSelected(renderer:IItemRenderer):Boolean
		{
			if (owner.allowMultipleSelection)
				return owner.selectedIndices.indexOf(renderer.index) != -1;
			else
				return renderer.index == owner.selectedIndex;
		}
		
		
		/**
		 * select item renderer
		 * 
		 * @param renderer
		 * 
		 */		
		private function select(renderer:IItemRenderer):void
		{
			if (!renderer)
				return;
			
			if (owner.allowMultipleSelection)
				selectedMultipleItemRenderer(renderer);
			else
				selectedItemRenderer(renderer);
		}
		
		// 单选
		private function selectedItemRenderer(renderer:IItemRenderer):void
		{
			var newIndex:int;
			var newIndices:Vector.<int> = owner.selectedIndices;
			newIndices.splice(0, owner.selectedIndices.length); // clear
			
			if (renderer.index == owner.selectedIndex && !owner.requestSelection)
				newIndex = -1;
			else
				newIndex = renderer.index;
			
			if (newIndex != -1)
				newIndices.push(newIndex);
			finalSelected(newIndex, newIndices);
		}
		
		// 多选
		private function selectedMultipleItemRenderer(renderer:IItemRenderer):void
		{
			var newIndex:int;
			var newIndices:Vector.<int>;
			
			// bug here
			var rendererIndex:int = owner.selectedIndices.indexOf(renderer.index);
			if (rendererIndex != -1)
			{
				// 已经选中状态
				if (owner.selectedIndices.length == 1 && owner.requestSelection)
				{
					newIndex = renderer.index;
					newIndices = owner.selectedIndices;
				}
				else
				{
					newIndices = owner.selectedIndices.concat();
					newIndices.splice(rendererIndex, 1);
					newIndex = newIndices.length > 0 ? newIndices[0] : -1;
				}
			}
			else
			{
				newIndex = renderer.index;
				newIndices = owner.selectedIndices.concat();
				newIndices.push(renderer.index);
			}
			
			finalSelected(newIndex, newIndices);
		}
		
		
		private function finalSelected(newIndex:int, newIndices:Vector.<int>):void
		{
			var event:UIEvent = new UIEvent(UIEvent.CHANGE);
			event.oldIndex = owner.selectedIndex;
			event.newIndex = newIndex;
			owner.selectedIndex = newIndex;
			owner.selectedIndices = newIndices;
			
			// bug repair 
			// must dispatch event after selectedIndex was setted
			owner.dispatchEvent(event);
		}
		
		
		private function renderer_mouseDownHandler(e:MouseEvent):void
		{
			isMouseDownOnRenderer = isMouseOverOnRenderer = true;
			mouseDownRenderer = e.currentTarget as IItemRenderer;
		}
		
		private function renderer_rollOverHandler(e:MouseEvent):void
		{
			isMouseOverOnRenderer = true;
		}
		
		
		private function renderer_rollOutHandler(e:MouseEvent):void
		{
			isMouseOverOnRenderer = false;
		}
		
		
		private function renderer_mouseUpHandler(e:MouseEvent):void
		{
			var mouseUpRenderer:IItemRenderer = e.currentTarget as IItemRenderer;
			
			if (isMouseDownOnRenderer && 
				isMouseOverOnRenderer &&
				mouseUpRenderer == mouseDownRenderer &&
				!isNaN(mouseUpRenderer.index))
			{
				var event:UIEvent = new UIEvent(UIEvent.SELECTED, true, true);
				event.renderer = mouseDownRenderer;
				mouseDownRenderer.dispatchEvent(event);
			}
		}
		
		private function renderer_selectingHandler(e:UIEvent):void
		{
			if (!e.isDefaultPrevented())
				select(mouseDownRenderer);
		}
		
		
	}
}