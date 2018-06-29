package coco.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import coco.event.UIEvent;
	import coco.manager.IFocusComponent;
	import coco.util.NameUtil;
	
	use namespace coco;
	
	/**
	 * 组件预初始化的时候派发
	 */	
	[Event(name="ui_preinitialize", type="coco.event.UIEvent")]
	
	/**
	 * 组件创建完成的时候派发 
	 */	
	[Event(name="ui_creationComplete", type="coco.event.UIEvent")]
	
	/**
	 * 组件大小发生改变的时候派发 
	 */	
	[Event(name="ui_resize", type="coco.event.UIEvent")]
	
	/**
	 * UIComponent</br>
	 * cocoui框架中，所有组件应该继承于UIComponent</br>
	 * 
	 * @author Coco
	 */	
	public class UIComponent extends Sprite implements IUIComponent, IInvalidating, IFocusComponent
	{
		include "Version.as";
		
		public function UIComponent()
		{
			super();
			
			tabEnabled = false;
			focusRect = false;
			
			try
			{
				// name
				name = NameUtil.createUniqueName(this);
			}
			catch(e:Error)
			{
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		//---------------------
		//	x
		//---------------------
		coco var _x:Number = 0;
		
		override public function get x():Number
		{
			return _x;
		}
		
		override public function set x(value:Number):void
		{
			if (_x == value)
				return;
			
			_x = value;
			super.x = value;
		}
		
		//---------------------
		//	y
		//---------------------
		coco var _y:Number = 0;
		
		override public function get y():Number
		{
			return _y;
		}
		
		override public function set y(value:Number):void
		{
			if (_y == value)
				return;
			
			_y = value;
			super.y = value;
		}
		
		//---------------------
		//	width
		//---------------------
		coco var _width:Number;
		
		override public function get width():Number
		{
			return isNaN(_width) ? measuredWidth : _width;
		}
		
		override public function set width(value:Number):void
		{
			if (_width == value)
				return;
			
			_width = value;
			
			invalidateSize();
			invalidateDisplayList();
			invalidateResizeEvent();
		}
		
		//---------------------
		//	measuredWidth
		//---------------------
		coco var _measuredWidth:Number = 0;
		
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		public function set measuredWidth(value:Number):void
		{
			if (_measuredWidth == value)
				return;
			
			_measuredWidth = value;
			invalidateResizeEvent();
		}
		
		
		//---------------------
		//	height
		//---------------------
		coco var _height:Number;
		
		override public function get height():Number
		{
			return isNaN(_height) ? measuredHeight : _height;
		}
		
		override public function set height(value:Number):void
		{
			if (_height == value)
				return;
			
			_height = value;
			
			invalidateSize();
			invalidateDisplayList();
			invalidateResizeEvent();
		}
		
		//---------------------
		//	measuredHeight
		//---------------------
		
		coco var _measuredHeight:Number = 0;
		
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		public function set measuredHeight(value:Number):void
		{
			if (_measuredHeight == value)
				return;
			
			_measuredHeight = value;
			invalidateResizeEvent();
		}
		
		//---------------------
		//	isPopUp
		//---------------------
		private var _isPopUp:Boolean = false;
		
		public function get isPopUp():Boolean
		{
			return _isPopUp;
		}
		
		public function set isPopUp(value:Boolean):void
		{
			_isPopUp = value;
		}
		
		
		//---------------------
		//	application
		//---------------------
		private var _application:Application;
		
		public function get application():Application
		{
			return _application;
		}
		
		public function set application(value:Application):void
		{
			if (_application == value)
				return;
			
			_application = value;
			
			pushCallLaterMethodsToApplicationCallLaterMethods();
			setChildrenApplication();
		}
		
		//---------------------
		//	focusEnabled
		//---------------------
		private var _focusEnabled:Boolean = false;
		
		/**
		 * 是否支持焦点 
		 */		
		public function get focusEnabled():Boolean
		{
			return _focusEnabled;
		}
		
		public function set focusEnabled(value:Boolean):void
		{
			_focusEnabled = value;
		}
		
		
		private var _initialized:Boolean = false;
		
		/**
		 * [Read only]
		 * @return 
		 */		
		public function get initialized():Boolean
		{
			return _initialized;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//	Life Cycle
		//
		//----------------------------------------------------------------------------------------------------------------
		
		public function initialize():void
		{
			if (initialized)
				return;
			
			dispatchEvent(new UIEvent(UIEvent.PREINITIALIZE));
			
			// Life Cycle
			createChildren();
			invalidatePropertiesInLifeCycle();
			invalidateSizeInLifeCycle();
			invalidateDisplayListInLifeCycle();
			_initialized = true;
			
			dispatchEvent(new UIEvent(UIEvent.CREATION_COMPLETE));
		}
		
		protected function createChildren():void
		{
			// override code
		}
		
		//----------------------------------------
		//	Invalidate Flags
		//----------------------------------------
		private var invalidatePropertiesFlag:Boolean = false;
		private var invalidateSizeFlag:Boolean = false;
		private var invalidateDisplayListFlag:Boolean = false;
		
		//----------------------------------------
		//	Invalidate Methods
		//----------------------------------------
		/**
		 * Only Call In Life Cycle 
		 */		
		private function invalidatePropertiesInLifeCycle():void
		{
			if (!invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = true;
				callLaterInLifeCycle(validateProperties, 0).descript = "[LifeCycle] validateProperties()";
			}
		}
		/**
		 * Only Call In Life Cycle 
		 */		
		private function invalidateSizeInLifeCycle():void
		{
			if (!invalidateSizeFlag)
			{
				invalidateSizeFlag = true;
				callLaterInLifeCycle(validateSize, 1).descript = "[LifeCycle] validateSize()";
			}
		}
		
		/**
		 * Only Call In Life Cycle 
		 */		
		private function invalidateDisplayListInLifeCycle():void
		{
			if (!invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = true;
				callLaterInLifeCycle(validateDisplayList, 2).descript = "[LifeCycle] validateDisplayList()";
			}
		}
		
		public function invalidateProperties():void
		{
			if (!invalidatePropertiesFlag && _initialized)
			{
				invalidatePropertiesFlag = true;
				callLater(validateProperties).descript = "validateProperties()";
			}
		}
		
		public function invalidateSize():void
		{
			if (!invalidateSizeFlag && _initialized)
			{
				invalidateSizeFlag = true;
				callLater(validateSize).descript = "validateSize()";
			}
		}
		
		public function invalidateDisplayList():void
		{
			if (!invalidateDisplayListFlag && _initialized)
			{
				invalidateDisplayListFlag = true;
				callLater(validateDisplayList).descript = "validateDisplayList()";
			}
		}
		
		//----------------------------------------
		//	Validate Methods
		//----------------------------------------
		
		/**
		 * 如果有失效方法，则立即生效方法</br>
		 * call commitProperties now</br>
		 * call measure now</br>
		 * call updateDisplayList now</br>
		 */        
		public function validateNow():void
		{
			validateProperties();
			validateSize();
			validateDisplayList();   
		}
		
		/**
		 * call commitProperties now
		 */        
		public function validateProperties():void
		{
			if (invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag = false;
				commitProperties();
			}
		}
		
		/**
		 * call measure now
		 */        
		public function validateSize():void
		{
			if (invalidateSizeFlag)
			{
				invalidateSizeFlag = false;
				
				// 如果高度或者宽度没有设置 才会执行measure
				if (isNaN(_width) || isNaN(_height))
					measure();
			}
		}
		
		/**
		 * call updateDisplayList now
		 */        
		public function validateDisplayList():void
		{
			if (invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag = false;
				updateDisplayList();
			}
		}
		
		//----------------------------------------
		//	Real Methods
		//----------------------------------------
		/**
		 * commitProperties
		 */        
		protected function commitProperties():void
		{
			// override code here
		}
		
		/**
		 * measure
		 */        
		protected function measure():void
		{
			measuredWidth = 0;
			measuredHeight = 0;
		}
		
		/**
		 * updateDisplayList 
		 */        
		protected function updateDisplayList():void
		{
			// overrdie code here
		}
		
		
		//----------------------------------------
		//	Invalidate Resize Event
		//----------------------------------------
		private var invalidateResizeEventFlag:Boolean = false;
		
		/**
		 * 稍后调用dispatchReszieEvent()方法
		 */		
		private function invalidateResizeEvent():void
		{
			if (!hasEventListener(UIEvent.RESIZE))
				return;
			
			if (!invalidateResizeEventFlag)
			{
				invalidateResizeEventFlag = true;
				callLater(validateResizeEvent).descript = "validateResizeEvent()";
			}
		}
		
		/**
		 * 立即调用dispatchReszieEvent()方法
		 */		
		private function validateResizeEvent():void
		{
			if (invalidateResizeEventFlag)
			{
				invalidateResizeEventFlag = false;
				dispatchReszieEvent();
			}
		}
		
		private function dispatchReszieEvent():void
		{
			if (hasEventListener(UIEvent.RESIZE))
				dispatchEvent(new UIEvent(UIEvent.RESIZE));
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//	Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * 设置组件为当前舞台焦点 
		 */		
		public function setFocus():void
		{
			if (focusEnabled)
				callLater(setFocusLater).descript = "setFocusLater()";
		}
		
		protected function setFocusLater():void
		{
			if (focusEnabled)
				stage.focus = this;
		}
		
		
		/**
		 * set each child 'application' 
		 */		
		coco function setChildrenApplication():void
		{
			var child:DisplayObject;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				if (child is UIComponent)
					UIComponent(child).application = application;
			}
		}
		
		override public function toString():String
		{
			return NameUtil.displayObjectToString(this);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Call Later
		//
		//----------------------------------------------------------------------------------------------------------------
		
		coco var callLaterMethods:Vector.<CallLaterMethod> = new Vector.<CallLaterMethod>();
		
		/**
		 * 
		 * 下一帧执行函数
		 * 
		 * @param method 函数
		 * @param flag 函数标记 callLater(test, 'test()')
		 * @param args 函数参数
		 * 
		 */        
		public function callLater(method:Function, ...args):CallLaterMethod 
		{
			var clm:CallLaterMethod = new CallLaterMethod();
			clm.method = method;
			clm.args = args;
			clm.caller = name;
			
			// if 'application' not null, push method to 'application'
			// if 'application' null, push to 'callLaterMethods', When 'application' not null, push to 'application'
			if (application)
				application.pushCallLaterMethodToApplicationCallLaterMethods(clm);
			else
				callLaterMethods.push(clm);
			
			return clm;
		}
		
		/**
		 * 延迟调用 在生命周期中
		 * 在生命周期中application总是为null, 所以保存到自己的callLaterMethods中去 
		 */		
		private function callLaterInLifeCycle(method:Function, index:int, ...args):CallLaterMethod
		{
			var clm:CallLaterMethod = new CallLaterMethod();
			clm.method = method;
			clm.args = args;
			clm.caller = name;
			callLaterMethods.splice(index, 0, clm);
			return clm;
		}
		
		/*coco function hasCallLaterMethod(method:Function):Boolean
		{
		for each (var callLaterMethod:Object in callLaterMethods)
		{
		if (callLaterMethod.method == method)
		return true;
		}
		
		return false;
		}*/
		
		/**
		 *  Push 'callLaterMethods' method to 'application' method
		 */		
		coco function pushCallLaterMethodsToApplicationCallLaterMethods():void
		{
			if (!application)
				return;
			
			while(callLaterMethods.length > 0)
			{
				application.pushCallLaterMethodToApplicationCallLaterMethods(callLaterMethods.shift());
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//	Added Removed Child
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * Add Child
		 * 
		 * @param child
		 * @return 
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var addedChild:DisplayObject = super.addChild(child);
			
			if (addedChild is IUIComponent)
			{
				IUIComponent(addedChild).initialize();
				IUIComponent(addedChild).application = application;
			}
			
			return addedChild;
		}
		
		/**
		 * Add Child At Index
		 * 
		 * @param child
		 * @param index
		 * @return 
		 */		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var addedChild:DisplayObject = super.addChildAt(child, index);
			
			if (addedChild is IUIComponent)
			{
				IUIComponent(addedChild).initialize();
				IUIComponent(addedChild).application = application;
			}
			
			return addedChild;
		}
		
		/**
		 * Remove Child
		 * 
		 * @param child
		 * @return 
		 */		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var removedChild:DisplayObject = super.removeChild(child);
			
			if (removedChild is IUIComponent)
				IUIComponent(removedChild).application = null;
			
			return removedChild;
		}
		
		/**
		 * Remove Child At Index
		 * 
		 * @param index
		 * @return 
		 */		
		override public function removeChildAt(index:int):DisplayObject
		{
			var removedChild:DisplayObject = super.removeChildAt(index);
			
			if (removedChild is IUIComponent)
				IUIComponent(removedChild).application = null;
			
			return removedChild;
		}
		
		/**
		 * Remove All Child
		 */		
		public function removeAllChild():void
		{
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				removeChildAt(i);
			}
		}
		
	}
}
