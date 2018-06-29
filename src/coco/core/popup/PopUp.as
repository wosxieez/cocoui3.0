/**
 *
 * @auther Coco
 * @date 2015/5/13
 */
package coco.core.popup
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import coco.core.Application;
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	
	/**
	 * Pop Up uicomponent
	 */
	[ExcludeClass]
	public class PopUp extends UIComponent
	{
		
		public function PopUp()
		{
			super();
		}
		
		public var childParent:DisplayObject;
		public var child:DisplayObject;
		public var modal:Boolean;
		public var closeWhenMouseClickOutside:Boolean;
		public var backgroundColor:uint = 0x000000;
		public var backgroundAlpha:Number = .2;
		private var op:Point;
		private var _center:Boolean;
		
		public function set center(value:Boolean):void
		{
			_center = value;
			
			updateChildPositoin();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (child)
			{
				addChild(child);
				op = new Point(child.x, child.y);
				child.addEventListener(UIEvent.RESIZE, child_resizeHandler);
			}
		}
		
		private function child_resizeHandler(event:UIEvent):void
		{
			updateChildPositoin();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			graphics.clear();
			if (modal)
				graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			updateChildPositoin();
		}
		
		
		/**
		 * update child position
		 */
		private function updateChildPositoin():void
		{
			if (!child)
				return;
			
			var sp:Point;
			if (childParent)
				sp = childParent.localToGlobal(new Point(0, 0));
			else
				sp = Application.topApplication.localToGlobal(new Point(0, 0));
			
			sp = globalToLocal(sp);
			
			if (_center)
			{
				var np:Point = new Point();
				if (childParent)
				{
					np.x = (childParent.width - child.width) / 2;
					np.y = (childParent.height - child.height) / 2;
				}
				else
				{
					np.x = (width - child.width) / 2;
					np.y = (height - child.height) / 2;
				}
				
				child.x = sp.x + np.x;
				child.y = sp.y + np.y;
			}
			else
			{
				child.x = op.x + sp.x;
				child.y = op.y + sp.y;
			}
		}
		
	}
}
