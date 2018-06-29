package coco.component
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import mx.utils.StringUtil;
    
    import coco.core.UIComponent;
    import coco.core.coco;
    import coco.event.UIEvent;
    import coco.manager.PopUpManager;
    import coco.util.CocoUI;
	
	use namespace coco;
    
    
    [Event(name="ui_close", type="coco.event.UIEvent")]
    
    /**
     * 弹出 提示组件
     * 
     * @author Coco
     */    
    public class Alert extends UIComponent
    {
        public function Alert()
        {
            super();
        }
        
        public static const OK:uint = 0x0004;
        public static const CANCEL:uint= 0x0008;
        
        /**
         * 显示
         * 
         * @param text 提示信息
         * @param title 提示标题
         * @param flags 提示操作按钮Alert.OK|Alert.CANCEL, Alert.OK, Alert.CANCEL
         * @param parent 所属组件
         * @param closeHandler 提示窗口关闭响应事件
         * @param closeWhenMouseDownOutSide 点击外部区域是否自动关闭
         * @return 
         * 
         */        
        public static function show(text:String = "", 
                                    title:String = "",
                                    flags:uint = 0x4 /* Alert.OK */, 
                                    parent:Sprite = null, 
                                    closeHandler:Function = null,
                                    closeWhenMouseClickOutside:Boolean = false):Alert
        {
            
            var alert:Alert = new Alert();
            alert.buttonFlags = flags;
            alert.text = text;
            alert.title = title;
            
            if (closeHandler != null)
                alert.addEventListener(UIEvent.CLOSE, closeHandler);
            
            PopUpManager.addPopUp(alert, parent, true, closeWhenMouseClickOutside);
            PopUpManager.centerPopUp(alert);
            
            return alert;
        }
        
        private var _title:String;
        
        public function get title():String
        {
            return _title;
        }
        
        public function set title(value:String):void
        {
            if (_title == value) return;
            _title = value;
            invalidateProperties();
        }
        
        private var _text:String;
        
        public function get text():String
        {
            return _text;
        }
        
        public function set text(value:String):void
        {
            if (_text == value) return;
            _text = value;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
        }
        
        private var _cancelLabel:String = "取消";
        
        public function get cancelLabel():String
        {
            return _cancelLabel;
        }
        
        public function set cancelLabel(value:String):void
        {
            if (_cancelLabel == value) return;
            _cancelLabel = value;
            invalidateProperties();
        }
        
        private var _okLabel:String = "确定";
        
        public function get okLabel():String
        {
            return _okLabel;
        }
        
        public function set okLabel(value:String):void
        {
            if (_okLabel == value) return;
            _okLabel = value;
            invalidateProperties();
        }
        
        private var _headerHeight:Number = 30;
        
        public function get headerHeight():Number
        {
            return _headerHeight;
        }
        
        public function set headerHeight(value:Number):void
        {
            if (_headerHeight == value) return;
            _headerHeight = value;
            invalidateDisplayList();
        }
        
        
        private var _footHeight:Number = 30;
        
        public function get footHeight():Number
        {
            return _footHeight;
        }
        
        public function set footHeight(value:Number):void
        {
            if (_footHeight == value) return;
            _footHeight = value;
            invalidateDisplayList();
        }
        
        private var _textAlign:String = CocoUI.fontAlign;

        /**
         * Alert 的文本对齐方式 
         */
        public function get textAlign():String
        {
            return _textAlign;
        }

        /**
         * @private
         */
        public function set textAlign(value:String):void
        {
            if (_textAlign == value) return;
            _textAlign = value;
            invalidateProperties();
        }

        
        private var hasHeader:Boolean = false;
        private var hasFoot:Boolean = false;
        private var titleLabel:Label;
        private var textLabel:Label;
        private var cancelButton:Button;
        private var okButton:Button;
        public var buttonFlags:uint;
        
        override protected function createChildren():void
        {
            super.createChildren();
			
			if (buttonFlags & Alert.OK)
			{
				okButton = new Button();
				okButton.addEventListener(MouseEvent.CLICK, okButton_clickHandler);
				addChild(okButton);
				hasFoot = true;
			}
            
            if (buttonFlags & Alert.CANCEL)
            {
                cancelButton = new Button();
                cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
                addChild(cancelButton);
                hasFoot = true;
            }
            
            if (title && StringUtil.trim(title) != "")
            {
                titleLabel = new Label();
                addChild(titleLabel);
                hasHeader = true;
            }
            
            textLabel = new Label();
			textLabel.x = 10;
            textLabel.addEventListener(UIEvent.RESIZE, textLabel_resizeHandler);
            addChild(textLabel);
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (cancelButton)
                cancelButton.label = cancelLabel;
            
            if (okButton)
                okButton.label = okLabel;
            
            if (titleLabel)
                titleLabel.text = title;
            
            textLabel.text = text;
            textLabel.textAlign = textAlign;
        }
        
        override protected function measure():void
        {
            super.measure();
            
            var realHeaderHeight:Number = hasHeader ? headerHeight : 0;
            var realFootHeight:Number = hasFoot ? footHeight : 0;
            var minWidth:Number = 240;
            var minHeight:Number = 150;
            measuredWidth = Math.max(textLabel.width + 20, minWidth);
            measuredHeight = Math.max(textLabel.height + realHeaderHeight + realFootHeight + 20, minHeight);
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            var realHeaderHeight:Number = hasHeader ? headerHeight : 0;
            var realFootHeight:Number = hasFoot ? footHeight : 0;
            
            // draw bg
            graphics.clear();
            graphics.beginFill(CocoUI.themeBackgroundColor);
            graphics.drawRect(0, 0, width, height);
            
            // drag header line
            if (hasHeader)
            {
                graphics.lineStyle(1, CocoUI.themeBorderColor);
                graphics.moveTo(5, headerHeight);
                graphics.lineTo(width - 10, headerHeight);
                graphics.endFill();
            }
            
            if (titleLabel)
            {
                titleLabel.height = headerHeight;
                titleLabel.width = width;
            }
            
			if (!isNaN(_width)) // 宽度已经被设置
				textLabel.width = width - 20;
			else
			{
				textLabel.coco::_measuredWidth = width - 20;
				textLabel.invalidateDisplayList();
			}
			if (!isNaN(_height)) // 高度已经被设置
				textLabel.height = height - realFootHeight - realHeaderHeight - 20;
			else
			{
				textLabel.coco::_measuredHeight = height - realFootHeight - realHeaderHeight - 20;
				textLabel.invalidateDisplayList();
			}
			
			textLabel.y = realHeaderHeight + 10;
            
            if (cancelButton && okButton)
            {
				okButton.width = width / 2;
				okButton.height = footHeight;
				okButton.y = height - okButton.height;
                
                cancelButton.width = width / 2 - 1;
				cancelButton.height = footHeight;
				cancelButton.x = cancelButton.width;
				cancelButton.y = height - footHeight;
            }
            else if (cancelButton)
            {
                cancelButton.width = width - 1;
                cancelButton.height = footHeight;
                cancelButton.y = height - cancelButton.height;
            }
            else if (okButton)
            {
                okButton.width = width - 1;
                okButton.height = footHeight;
                okButton.y = height - okButton.height;
            }
        }
        
        
        protected function textLabel_resizeHandler(event:UIEvent):void
        {
            invalidateSize();
            invalidateDisplayList();
        }
        
        protected function cancelButton_clickHandler(event:MouseEvent):void
        {
            var ce:UIEvent = new UIEvent(UIEvent.CLOSE);
            ce.detail = Alert.CANCEL;
            dispatchEvent(ce);
            
            PopUpManager.removePopUp(this);
        }
        
        protected function okButton_clickHandler(event:MouseEvent):void
        {
            var ce:UIEvent = new UIEvent(UIEvent.CLOSE);
            ce.detail = Alert.OK;
            dispatchEvent(ce);
            
            PopUpManager.removePopUp(this);
        }
        
    }
}