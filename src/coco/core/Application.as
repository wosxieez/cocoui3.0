package coco.core
{
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import coco.core.popup.ApplicationContent;
	import coco.core.popup.ApplicationPopUp;
	import coco.manager.PopUpManager;
	import coco.util.CocoUI;
	import coco.util.DPIUtil;
	import coco.util.Platform;
	import coco.util.debug;
	
	use namespace coco;
	
	/**
	 *Applicatoin</br>
	 *cocoui框架中，所有组件应该被添加到Application上面</br>
	 *Application负责所有组件的失效机制,如果组件没有被添</br>
	 *加到Applicaotn上面,组件的生命周期方法,失效方法将不会执行</br>
	 * 
	 *Applicatoin层次结构：</br>
	 *  applicationContent：内容层</br>
	 *  applicationPopUp：弹窗层</br>
	 *
	 * @author Coco
	 */
	public class Application extends UIComponent
	{
		
		public function Application()
		{
			super();
			
			addListener();
			
			// init pop up manager
			PopUpManager.application = this;
			topApplication = this;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Variables
		//
		//----------------------------------------------------------------------------------------------------------------
		
		//-------------------------
		// topApplication
		//-------------------------
		
		public static var topApplication:Application;
		
		/**
		 * 程序帧频,默认为24帧每秒
		 * @default 24 
		 */        
		public var applicationFPS:int = 24;
		
		/**
		 * 程序DPI, 默认为160
		 * @default 160 
		 */        
		public var applicationDPI:Number = 160;
		
		private var _applicationContent:ApplicationContent;
		
		private function get applicationContent():ApplicationContent
		{
			if (!_applicationContent)
			{
				_applicationContent = new ApplicationContent();
				super.addChildAt(_applicationContent, 0);
			}
			
			return _applicationContent;
		}
		
		
		private var _applicationPopUp:ApplicationPopUp;
		
		/**
		 * 程序弹窗层,所有弹出的组件都将被添加到此曾上
		 */
		coco function get applicationPopUp():ApplicationPopUp
		{
			if (!_applicationPopUp)
			{
				_applicationPopUp = new ApplicationPopUp();
				super.addChild(_applicationPopUp);
			}
			
			return _applicationPopUp;
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private function addListener():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		override protected function measure():void
		{
			if (stage)
			{
				if (Platform.isDesktop)
				{
					measuredWidth = stage.stageWidth;
					measuredHeight = stage.stageHeight;
				}
				else
				{
					// 手机平台需要根据dpi进行缩放
					var scale:Number = DPIUtil.getDPIScale(DPIUtil.getDPI(applicationDPI), DPIUtil.getRuntimeDPI(stage));
					measuredWidth = stage.stageWidth / scale;
					measuredHeight = stage.stageHeight / scale;
					scaleX = scaleY = scale;
				}
			}
			else
				super.measure();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// test code
			//			graphics.clear();
			//			graphics.beginFill(0xFFFFFF);
			//			graphics.drawRect(0, 0, width, height);
			//			graphics.endFill();
			
			applicationContent.width = applicationPopUp.width = width;
			applicationContent.height = applicationPopUp.height = height;
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Override for child
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override coco function setChildrenApplication():void
		{
			applicationContent.application = applicationPopUp.application = application;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return applicationContent.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return applicationContent.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return applicationContent.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return applicationContent.removeChildAt(index);
		}
		
		override public function get numChildren():int
		{
			return applicationContent.numChildren;
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return applicationContent.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			return applicationContent.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return applicationContent.getChildIndex(child);
		}
		
		override public function removeAllChild():void
		{
			applicationContent.removeAllChild();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Call Later Code
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * 
		 * 下一帧执行函数
		 * 
		 * @param method 函数
		 * @param args 函数参数
		 * 
		 */              
		override public function callLater(method:Function, ...args):CallLaterMethod
		{
			var clm:CallLaterMethod = new CallLaterMethod();
			clm.method = method;
			clm.args = args;
			clm.caller = name;
			
			pushCallLaterMethodToApplicationCallLaterMethods(clm);
			return clm;
		}
		
		coco function pushCallLaterMethodToApplicationCallLaterMethods(callLaterMethod:CallLaterMethod):void
		{
			callLaterMethods.push(callLaterMethod);
			invalidateCallLater();
		}
		
		override coco function pushCallLaterMethodsToApplicationCallLaterMethods():void
		{
			//	UIComponent need push callLater methods to Application
			//	Application self not need
		}
		
		private var invalidateCallLaterFlag:Boolean = false;
		private var rendererTotalTime:int = 0;
		
		/**
		 * 延迟调用失效
		 */        
		public function invalidateCallLater():void
		{
			if (stage && !invalidateCallLaterFlag)
			{
				invalidateCallLaterFlag = true;
				stage.addEventListener(Event.ENTER_FRAME, validateCallLater);
				stage.addEventListener(Event.RENDER, validateCallLater);
				stage.invalidate();
			}
		}
		
		private function validateCallLater(event:Event):void
		{
			if (invalidateCallLaterFlag)
			{
				stage.removeEventListener(Event.ENTER_FRAME, validateCallLater);
				stage.removeEventListener(Event.RENDER, validateCallLater);
				updateCallLater();
			}
		}
		
		private function updateCallLater():void
		{
			var startTime:int = getTimer();
			var rendererCurrentTime:int;
			if (callLaterMethods.length == 0) return;
			var callLaterMethod:CallLaterMethod;
			while(callLaterMethods.length > 0)
			{
				callLaterMethod = callLaterMethods.shift();
				debug( "[" + callLaterMethod.caller + "] " + (callLaterMethod.descript ? callLaterMethod.descript : "call unknowMethod()"));
				callLaterMethod.method.apply(null, callLaterMethod.args);
			}
			rendererCurrentTime = getTimer() - startTime;
			rendererTotalTime += rendererCurrentTime;
			
			CocoUI.coco::montior("[RendererTime:" + rendererCurrentTime + 
				'ms] [TotalRendererTime:' + rendererTotalTime + 
				'ms] [TotalInstanceNum:' + CocoUI.coco::instanceCounter + 
				'] [TotalMemory:' + (System.totalMemory / 1024).toFixed()  + 
				'KB] [FreeMemory:' + (System.freeMemory / 1024).toFixed() + 'KB]');
			
			// now invalidate flag false
			invalidateCallLaterFlag = false;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Event Handlers
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * @param event
		 */
		private function addedToStageHandler(event:Event):void
		{
			// set stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = applicationFPS;
			
			// application initizlize
			initialize();
			application = this;
			stage.addEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			application = null;
			stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
		
		private function stage_resizeHandler(event:Event):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
	}
}

