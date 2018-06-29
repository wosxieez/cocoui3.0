package coco.manager
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	import coco.core.Application;
	
	/**
	 *
	 * 焦点管理器
	 * 
	 * @author coco
	 * 
	 */	
	public class FocusManager
	{
		public function FocusManager()
		{
		}
		
		public static var currentFocus:InteractiveObject;
		
		private static var _application:Application;
		
		public static function set application(value:Application):void
		{
			if (_application) throw Error("FocusManager must be singleton");
			
			_application = value;
			
			if (_application)
				_application.addEventListener(Event.ADDED_TO_STAGE, application_addedToStageHandler);
		}
		
		protected static function application_addedToStageHandler(event:Event):void
		{
			_application.stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_focusChangeHandler, true);
			_application.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler, true);
			_application.stage.addEventListener(Event.ACTIVATE, stage_activateHandler);
		}
		
		protected static function stage_activateHandler(event:Event):void
		{
			if (!currentFocus) return;
			
			if (currentFocus is TextField)
				_application.stage.focus = currentFocus;
			else if (currentFocus is IFocusComponent)
				IFocusComponent(currentFocus).setFocus();
		}
		
		protected static function stage_keyFocusChangeHandler(event:FocusEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
		}
		
		protected static function stage_focusChangeHandler(event:FocusEvent):void
		{
			var curInterativeObject:InteractiveObject = _application.stage.focus;
			var interactiveObject:InteractiveObject = event.relatedObject;
			
			if (interactiveObject is TextField)
			{
				// textField do nothings
				currentFocus = interactiveObject;
			}
			else if (interactiveObject is IFocusComponent &&
				IFocusComponent(interactiveObject).focusEnabled)
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				
				currentFocus = interactiveObject;
				IFocusComponent(interactiveObject).setFocus();
			}
			else
			{
				event.preventDefault();
				event.stopImmediatePropagation();
			}
		}
		
	}
}