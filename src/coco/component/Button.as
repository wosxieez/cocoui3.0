package coco.component
{
    import coco.core.UIComponent;
    import coco.event.UIEvent;
    import coco.util.CocoUI;
    
    
    /**
     * 按钮组件
     * 
     * @author Coco
     */	
    public class Button extends UIComponent 
    {
        
        public function Button() 
        {
            super();
            
            mouseChildren = false;
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //----------------------------------------------------------------------------------------------------------------
        
        protected var labelDisplay:Label;
        
        //--------------------------------
        // 文本内容
        //--------------------------------
        private var _label:String;
        
        /**
         * 文本内容
         * @return 
         */		
        public function get label():String
        {
            return _label;
        }
        
        public function set label(value:String):void
        {
            if (_label == value)
                return;
            
            _label = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 字体大小
        //--------------------------------
        private var _fontSize:int = CocoUI.fontSize;
        
        /**
         * 字体大小
         * @return 
         */		
        public function get fontSize():int
        {
            return _fontSize;
        }
        
        public function set fontSize(value:int):void
        {
            if (_fontSize == value)
                return;
            
            _fontSize = value;
            
            invalidateText();
        }
        
        
        //--------------------------------
        // 字体颜色
        //--------------------------------
        private var _color:uint = CocoUI.fontColor;
        
        /**
         * 字体颜色 
         * @return 
         */		
        public function get color():uint
        {
            return _color;
        }
        
        public function set color(value:uint):void
        {
            if (_color == value)
                return;
            
            _color = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 密码格式显示
        //--------------------------------
        private var _displayAsPassword:Boolean = false;
        
        /**
         * 密码格式显示
         * @return 
         */		
        public function get displayAsPassword():Boolean
        {
            return _displayAsPassword;
        }
        
        public function set displayAsPassword(value:Boolean):void
        {
            if (_displayAsPassword == value)
                return;
            
            _displayAsPassword = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 文本水平对齐方式
        //--------------------------------		
        private var _textAlign:String = CocoUI.fontAlign;
        
        /**
         * 文本对齐方式
         * @return 
         */		
        public function get textAlign():String
        {
            return _textAlign;
        }
        
        public function set textAlign(value:String):void
        {
            if (_textAlign == value)
                return;
            
            _textAlign = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 厚度字体
        //--------------------------------
        private var _bold:Boolean = CocoUI.fontBold;
        
        /**
         * 是否粗体
         * @return 
         */		
        public function get bold():Boolean
        {
            return _bold;
        }
        
        public function set bold(value:Boolean):void
        {
            if (_bold == value)
                return;
            
            _bold = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 字体
        //--------------------------------
        private var _fontFamily:String = CocoUI.fontFamily;
        
        /**
         * 字体默认 微软雅黑 
         * @return 
         */		
        public function get fontFamily():String
        {
            return _fontFamily;
        }
        
        public function set fontFamily(value:String):void
        {
            if (_fontFamily == value)
                return;
            
            _fontFamily = value;
            
            invalidateText();
        }
        
        //--------------------------------
        // 行距
        //--------------------------------
        private var _leading:Number = CocoUI.fontLeading;
        
        /**
         * 行与行之间的距离
         * 
         * @return 
         */		
        public function get leading():Number
        {
            return _leading;
        }
        
        public function set leading(value:Number):void
        {
            if (_leading == value)
                return;
            
            _leading = value;
            
            invalidateText();
        }
        
        
        //--------------------------------
        // html内容
        //--------------------------------
        private var _htmlText:String = null;
        
        /**
         * html文本
         * @return 
         */		
        public function get htmlText():String
        {
            return _htmlText;
        }
        
        public function set htmlText(value:String):void
        {
            if (_htmlText == value)
                return;
            
            _htmlText = value;
            
            invalidateText();
        }
        
        /**
         * 文本是否失效 
         */		
        private var invalidateTextFlag:Boolean = false;
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private function invalidateText():void
        {
            if (!invalidateTextFlag)
            {
                invalidateTextFlag = true;
                callLater(validateText).descript = "updateText()";
            }
        }
        
        private function validateText():void
        {
            if (invalidateTextFlag)
            {
                invalidateTextFlag = false;
                updateText();
            }
        }
        
        private function updateText():void
        {
            labelDisplay.fontSize = fontSize;
            labelDisplay.color = color;
            labelDisplay.textAlign = textAlign;
            labelDisplay.fontFamily = fontFamily;
            labelDisplay.bold = bold;
            labelDisplay.leading = leading;
            
            // set Text
            if (_htmlText != null)
                labelDisplay.htmlText = _htmlText;
            else
                labelDisplay.text = _label;
        }
        
        override protected function createChildren():void 
        {
            super.createChildren();
            
            labelDisplay = new Label();
            labelDisplay.addEventListener(UIEvent.RESIZE, label_resizeHandler);
            addChild(labelDisplay);
        }
        
        protected function label_resizeHandler(event:UIEvent):void
        {
            invalidateSize();
            invalidateDisplayList();
        }
        
        override protected function measure():void
        {
            var defaultWidth:Number = 120;
            var defaultHeight:Number = 40;
            
            // width or height isNaN
            if (labelDisplay)
            {
                defaultWidth = Math.max(defaultWidth, labelDisplay.width + 10);
                defaultHeight = Math.max(defaultHeight, labelDisplay.height + 10);
            }
            
            measuredWidth = defaultWidth;
            measuredHeight = defaultHeight;
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            // draw bg skin
            graphics.clear();
            graphics.lineStyle(1, CocoUI.themeBorderColor);
            graphics.beginFill(CocoUI.themeBackgroundColor);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            
            labelDisplay.x = (width - labelDisplay.width) / 2;
            labelDisplay.y = (height - labelDisplay.height) / 2;
        }
        
    }
}


