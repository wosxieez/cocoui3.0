package coco.component
{
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import coco.event.UIEvent;
	import coco.util.CocoUI;
	
	
	[Event(name="ui_enter", type="coco.event.UIEvent")]
	
	/**
	 * 文本输入组件
	 * 
	 * @author Coco
	 */	
	public class TextInput extends Label
	{
		public function TextInput()
		{
			super();
			mouseChildren = true;
			selectable = true;
			focusEnabled = true;
			textAlign = TextFormatAlign.LEFT;
			addEventListener(KeyboardEvent.KEY_DOWN, this_keyDownHandler);
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		//--------------------------------
		// 是否可编辑
		//--------------------------------
		private var _editable:Boolean = true;
		
		/**
		 * TextField editable
		 * 
		 * @return 
		 */        
		public function get editable():Boolean
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void
		{
			if (_editable == value) return;
			_editable = value;
			invalidateProperties();
		}
		
		//--------------------------------
		// 限制输入
		//--------------------------------
		private var _restrict:String = null;
		
		/**
		 * 限制输入
		 *  
		 * @return 
		 * 
		 */        
		public function get restrict():String
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void
		{
			if (_restrict == value) return;
			_restrict = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function setFocusLater():void
		{
			if (stage && stage.focus != textField)
				stage.focus = textField;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			textField.multiline = false; // textinput 不支持 enter 回车键
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			textField.type = editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.restrict = restrict;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var defaultWidth:Number = 200;
			var defaultHeight:Number = 40;
			
			measuredWidth = Math.max(defaultWidth, measuredWidth + 10);
			measuredHeight = Math.max(defaultHeight, measuredHeight);
		}
		
		override protected function updateDisplayList():void
		{
			textField.width = width  - 10;
			textField.height = textField.textHeight + 4;
			textField.x = 5;
			textField.y = (height - textField.height) / 2;
			
			// draw bg skin
			graphics.clear();
			graphics.lineStyle(1, CocoUI.themeBorderColor);
			graphics.beginFill(CocoUI.themeBackgroundColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		protected function this_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.charCode == Keyboard.ENTER)
			{
				if (textField && !textField.multiline)
				{
					dispatchEvent(new UIEvent(UIEvent.ENTER));
					event.preventDefault();
				}
			}
		}
		
	}
}


