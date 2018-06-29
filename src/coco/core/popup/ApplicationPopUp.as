/**
 *
 * @auther Coco
 * @date 2015/5/13
 */
package coco.core.popup
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import coco.core.IUIComponent;
	import coco.core.UIComponent;
	import coco.util.debug;
	
	[ExcludeClass]
	public class ApplicationPopUp extends UIComponent
	{
		public function ApplicationPopUp()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, this_addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, this_removedFromStageHandler);
		}
		
		/**
		 * Add PopUp Component 
		 * 
		 * @param child
		 * @param childParent
		 * @param modal
		 * @param backgroundColor
		 * @param backgroundAlpha
		 * @return 
		 * 
		 */        
		public function addPopUp(child:DisplayObject, 
								 childParent:DisplayObject, 
								 modal:Boolean, 
								 closeWhenMouseClickOutside:Boolean,
								 backgroundColor:uint, 
								 backgroundAlpha:Number):DisplayObject
		{
			// if already has this child's pop, remove item
			removePopUp(child);
			
			var popUp:PopUp = new PopUp();
			popUp.child = child;
			popUp.childParent = childParent;
			popUp.modal = modal;
			popUp.closeWhenMouseClickOutside = closeWhenMouseClickOutside;
			popUp.backgroundColor = backgroundColor;
			popUp.backgroundAlpha = backgroundAlpha;
			popUp.width = width;
			popUp.height = height;
			addChild(popUp);
			
			// set UIComponent isPopUp property
			if (child is IUIComponent)
				IUIComponent(child).isPopUp = true;
			
			debug("[ApplicationPopUp] addPopUpUI [" + child.name + "] PopUpUI Num: " + numChildren);
			
			return child;
		}
		
		public function centerPopUp(child:DisplayObject):DisplayObject
		{
			var popUp:PopUp;
			for (var index:int = 0; index < numChildren; index++)
			{
				popUp = getChildAt(index) as PopUp;
				if (popUp && popUp.child == child)
				{
					popUp.center = true;
					debug("[ApplicationPopUp] centerPopUpUI [" + child.name + "] PopUpUI Num: " + numChildren);
					return child;
				}
			}
			return child;
		}
		
		public function removePopUp(child:DisplayObject):DisplayObject
		{
			var popUp:PopUp;
			for (var index:int = 0; index < numChildren; index++)
			{
				popUp = getChildAt(index) as PopUp;
				if (popUp && popUp.child == child)
				{
					// clean pop up
					popUp.removeAllChild();
					removeChild(popUp);
					popUp = null;
					
					// set UIComponent isPopUp property
					if (child is IUIComponent)
						IUIComponent(child).isPopUp = false;
					
					debug("[ApplicationPopUp] removePopUpUI [" + child.name + "] PopUpUI Num: " + numChildren);
					return child;
				}
			}
			return child;
		}
		
		override protected function updateDisplayList():void
		{
			// all popup width height was same with this width height
			var child:DisplayObject;
			for (var index:int = 0; index < numChildren; index++)
			{
				child = getChildAt(index);
				child.width = width;
				child.height = height;
			}
		}
		
		protected function this_addedToStageHandler(event:Event):void
		{
			// In this we shoud listen mouse click event useCapture
			
			//  stage ---------------capture phase---------------target  
			//														|
			//                                              -> target phase <-
			//														|
			//  stage ---------------bubbles phase---------------target
			//  mousedown close       -> bug here <-          mousedown  open 
			// In this case : we will can't open popup
			stage.addEventListener(MouseEvent.CLICK, stage_mouseClickHandler, true);
		}
		
		protected function this_removedFromStageHandler(event:Event):void
		{
			stage.removeEventListener(MouseEvent.CLICK, stage_mouseClickHandler, true);
		}
		
		private function stage_mouseClickHandler(e:MouseEvent):void
		{
			// 1 舞台被点击
			// 2 判断popup层的最顶层是否支持自动关闭
			if (numChildren == 0) return;
			
			var topPopUp:PopUp = getChildAt(numChildren - 1) as PopUp;
			if (topPopUp && topPopUp.closeWhenMouseClickOutside)
			{
				var clickTarget:DisplayObject = e.target as DisplayObject;
				if (!containsTarget(clickTarget))
					removePopUp(topPopUp.child);
			}
			
			
			function containsTarget(target:DisplayObject):Boolean
			{
				if (!target) return false;
				
				if (DisplayObjectContainer(topPopUp.child).contains(target))
					return true;
				
				return false;
			}
		}
		
	}
}
