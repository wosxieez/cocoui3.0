package coco.component
{
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import coco.core.UIComponent;
	import coco.util.CocoUI;
	
	/**
	 * 文本组件
	 * 
	 * @author Coco
	 */	
	public class Label extends UIComponent 
	{
		
		public function Label() 
		{
			super();
			
			mouseChildren = false;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Vars
		//
		//----------------------------------------------------------------------------------------------------------------
		
		// 提高性能 
		private var useHtmlText:Boolean = false;
		private var textChanged:Boolean = true;
		private var formatChanged:Boolean = true;
		private var textFieldChanged:Boolean = true;
		
		protected var textField:TextField;
		
		//--------------------------------
		// 文本内容
		//--------------------------------
		private var _text:String;
		
		/**
		 * 文本内容
		 * @return 
		 */		
		public function get text():String
		{
			if (textField && !textChanged)
			{
				if (useHtmlText)
					return textField.htmlText;
				else
					return textField.text;
			}
			else
			{
				if (useHtmlText)
					return _htmlText ? _htmlText : "";
				else
					return _text ? _text : "";
			}
			
		}
		
		public function set text(value:String):void
		{
			if (text == value)
				return;
			useHtmlText = false;
			_text = value;
			textChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// 字符间的距离
		//--------------------------------
		private var _letterSpacing:Number = CocoUI.fontLetterSpacing;
		
		public function get letterSpacing():Number
		{
			return _letterSpacing;
		}
		
		public function set letterSpacing(value:Number):void
		{
			if (_letterSpacing == value)
				return;
			
			_letterSpacing = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
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
			
			useHtmlText = true;
			_htmlText = value;
			textChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// embedFonts
		//--------------------------------
		
		private var _embedFonts:Boolean = false;
		
		/**
		 * 指定是否使用嵌入字体轮廓进行呈现 
		 */
		public function get embedFonts():Boolean
		{
			return _embedFonts;
		}
		
		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			if (_embedFonts == value) return;
			_embedFonts = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// alwaysShowSelection
		//--------------------------------
		
		private var _alwaysShowSelection:Boolean = false;
		
		/**
		 * 如果设置为 true 且文本字段没有焦点，Flash Player 将以灰色突出显示文本字段中的所选内容 
		 */
		public function get alwaysShowSelection():Boolean
		{
			return _alwaysShowSelection;
		}
		
		/**
		 * @private
		 */
		public function set alwaysShowSelection(value:Boolean):void
		{
			if (_alwaysShowSelection == value) return;
			_alwaysShowSelection = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// antiAliasType
		//--------------------------------
		
		private var _antiAliasType:String = AntiAliasType.NORMAL;
		
		/**
		 * 用于此文本字段的消除锯齿类型。将 flash.text.AntiAliasType 常数用于此属性。
		 * 仅在字体为嵌入（即 embedFonts 属性设置为 true）时可以控制此设置。
		 * 默认设置为 flash.text.AntiAliasType.NORMAL。 
		 */
		public function get antiAliasType():String
		{
			return _antiAliasType;
		}
		
		/**
		 * @private
		 */
		public function set antiAliasType(value:String):void
		{
			if (_antiAliasType == value) return;
			_antiAliasType = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// gridFitType
		//--------------------------------
		
		private var _gridFitType:String = GridFitType.PIXEL;
		
		/**
		 *
		 * 用于此文本字段的网格固定类型。
		 * 仅在文本字段的 flash.text.AntiAliasType 属性设置为 flash.text.AntiAliasType.ADVANCED 时才应用此属性。
		 * 使用的网格固定类型确定了 Flash Player 是否强制让粗水平线和垂直线适合像素网格或子像素网格。
		 *  
		 * @return 
		 * 
		 */        
		public function get gridFitType():String
		{
			return _gridFitType;
		}
		
		public function set gridFitType(value:String):void
		{
			if (_gridFitType == value) return;
			_gridFitType = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// condenseWhite
		//--------------------------------
		
		private var _condenseWhite:Boolean = false;
		
		/**
		 * 一个布尔值，指定是否删除具有 HTML 文本的文本字段中的额外空白（空格、换行符等等）。
		 * 默认值为 false。
		 * condenseWhite 属性只影响使用 htmlText 属性（而非 text 属性）设置的文本。
		 * 如果使用 text 属性设置文本，则忽略 condenseWhite。 
		 */
		public function get condenseWhite():Boolean
		{
			return _condenseWhite;
		}
		
		/**
		 * @private
		 */
		public function set condenseWhite(value:Boolean):void
		{
			if (_condenseWhite == value) return;
			_condenseWhite = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// maxChars
		//--------------------------------
		
		private var _maxChars:int = 0;
		
		/**
		 * 文本字段中最多可包含的字符数 
		 * 默认值 0
		 */
		public function get maxChars():int
		{
			if (_maxChars < 0)
				return 0;
			else
				return _maxChars;
		}
		
		/**
		 * @private
		 */
		public function set maxChars(value:int):void
		{
			if (_maxChars == value) return;
			_maxChars = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// mouseWheelEnabled
		//--------------------------------
		
		private var _mouseWheelEnabled:Boolean = true;
		
		/**
		 * 一个布尔值，表示当用户单击某个文本字段并滚动鼠标滚轮时，Flash Player 是否自动滚动多行文本字段
		 * 默认值 true 
		 */
		public function get mouseWheelEnabled():Boolean
		{
			return _mouseWheelEnabled;
		}
		
		/**
		 * @private
		 */
		public function set mouseWheelEnabled(value:Boolean):void
		{
			if (_mouseWheelEnabled == value) return;
			_mouseWheelEnabled = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// selectable
		//--------------------------------
		
		private var _selectable:Boolean = false;
		
		/**
		 * 一个布尔值，表示文本字段是否可选。
		 * 默认值 false 
		 */
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		/**
		 * @private
		 */
		public function set selectable(value:Boolean):void
		{
			if (_selectable == value) return;
			_selectable = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//--------------------------------
		// wordWrap
		//--------------------------------
		
		private var _wordWrap:Boolean = false;

		/**
		 * 是否自动换行 如果宽度被设定  长度长于宽的时候会自动换行
		 * 
		 * @return 
		 */		
		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			if (_wordWrap == value) return;
			_wordWrap = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// selectionBeginIndex
		//--------------------------------
		
		/**
		 *
		 * 当前选中开始索引 
		 * @return 
		 * 
		 */		
		public function get selectionBeginIndex():int
		{
			if (textField)
				return textField.selectionBeginIndex;
			else
				return -1;
		}
		
		
		//--------------------------------
		// selectionEndIndex
		//--------------------------------
		
		/**
		 *
		 * 当前选中结束索引 
		 * @return 
		 * 
		 */		
		public function get selectionEndIndex():int
		{
			if (textField)
				return textField.selectionEndIndex;
			else
				return -1;
		}
		
		
		//--------------------------------
		// sharpness
		//--------------------------------
		
		private var _sharpness:Number = 0;
		
		/**
		 * 此文本字段中字型边缘的清晰度。
		 * 仅在文本字段的 flash.text.AntiAliasType 属性设置为 flash.text.AntiAliasType.ADVANCED 时才应用此属性。
		 * sharpness 的范围是从 -400 到 400 的一个数字。
		 * 如果尝试将 sharpness 设置为该范围外的值，
		 * 则 Flash 会将该属性设置为范围内最接近的值（-400 或 400）。 
		 */
		public function get sharpness():Number
		{
			return _sharpness;
		}
		
		/**
		 * @private
		 */
		public function set sharpness(value:Number):void
		{
			if (_sharpness == value) return;
			_sharpness = value;
			textFieldChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//--------------------------------
		// thickness
		//--------------------------------
		
		private var _thickness:Number = 0;
		
		/**
		 * 此文本字段中字型边缘的粗细。仅在 flash.text.AntiAliasType 设置为 flash.text.AntiAliasType.ADVANCED 时才可应用此属性。
		 * thickness 的范围是从 -200 到 200 的一个数字。如果要尝试将 thickness 设置为该范围外的值，则该属性会设置为范围内最接近的值（-200 或 200）。
		 * 默认值为 0。 
		 */
		public function get thickness():Number
		{
			return _thickness;
		}
		
		/**
		 * @private
		 */
		public function set thickness(value:Number):void
		{
			if (_thickness == value) return;
			_thickness = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _blockIndent:Number = CocoUI.fontBlockIndent;
		
		/**
		 * 指示块缩进，以像素为单位。 
		 * 块缩进应用于整个文本块，即文本的所有行。 
		 * 而普通缩进 (TextFormat.indent) 只影响各段的第一行。 
		 * 如果此属性为 null，则 TextFormat 对象不指定块缩进（块缩进为 0）。 
		 */
		public function get blockIndent():Number
		{
			return _blockIndent;
		}
		
		/**
		 * @private
		 */
		public function set blockIndent(value:Number):void
		{
			if (_blockIndent == value) return;
			_blockIndent = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _bullet:Boolean = CocoUI.fontBullet;
		
		/**
		 * 表示文本为带项目符号的列表的一部分。
		 * 在带项目符号的列表中，文本的各段都是缩进的。
		 * 项目符号显示在各段第一行的左侧。
		 * 默认值为 null，这意味着不使用带项目符号的列表。
		 */
		public function get bullet():Boolean
		{
			return _bullet;
		}
		
		/**
		 * @private
		 */
		public function set bullet(value:Boolean):void
		{
			if (_bullet == value) return;
			_bullet = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _indent:Number = CocoUI.fontIndent;
		
		/**
		 * 表示从左边距到段落中第一个字符的缩进。
		 * 默认值为 null，它表示不使用缩进。
		 */
		public function get indent():Number
		{
			return _indent;
		}
		
		/**
		 * @private
		 */
		public function set indent(value:Number):void
		{
			if (_indent == value) return;
			_indent = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _italic:Boolean = CocoUI.fontItalic;
		
		/**
		 * 表示使用此文本格式的文本是否为斜体。
		 * 默认值为 null，这意味着不使用斜体。 
		 */
		public function get italic():Boolean
		{
			return _italic;
		}
		
		/**
		 * @private
		 */
		public function set italic(value:Boolean):void
		{
			if (_italic == value) return;
			_italic = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _kerning:Boolean = CocoUI.fontKerning;
		
		/**
		 * 一个布尔值，表示是启用 (true) 还是禁用 (false) 字距调整。
		 * 通过字距调整可为了提高可读性而调整某些字符对之间的像素，并且只在需要时（如使用大字体标题时）使用字距调整。
		 * 仅嵌入字体支持字距调整。
		 * 某些字体（如宋体）和等宽字体（如 Courier New）不支持字距调整。
		 * 默认值为 null，这意味着没有启用字距调整。 
		 */
		public function get kerning():Boolean
		{
			return _kerning;
		}
		
		/**
		 * @private
		 */
		public function set kerning(value:Boolean):void
		{
			if (_kerning == value) return;
			_kerning = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _leftMargin:Number = CocoUI.fontLeftMargin;
		
		/**
		 * 段落的左边距，以像素为单位。
		 * 默认值为 null，它表示左边距为 0 像素。 
		 */
		public function get leftMargin():Number
		{
			return _leftMargin;
		}
		
		/**
		 * @private
		 */
		public function set leftMargin(value:Number):void
		{
			if (_leftMargin == value) return;
			_leftMargin = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _rightMargin:Number = CocoUI.fontRightMargin;
		
		/**
		 * 段落的右边距，以像素为单位。
		 * 默认值为 null，它表示右边距为 0 像素。 
		 */
		public function get rightMargin():Number
		{
			return _rightMargin;
		}
		
		/**
		 * @private
		 */
		public function set rightMargin(value:Number):void
		{
			if (_rightMargin == value) return;
			_rightMargin = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _underline:Boolean = CocoUI.fontUnderline;
		
		/**
		 * 表示使用此文本格式的文本是带下划线 (true) 还是不带下划线 (false)。
		 * 默认值为 null，它表示不使用下划线。 
		 */
		public function get underline():Boolean
		{
			return _underline;
		}
		
		/**
		 * @private
		 */
		public function set underline(value:Boolean):void
		{
			if (_underline == value) return;
			_underline = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _tabStops:Array = null;
		
		/**
		 * 将自定义 Tab 停靠位指定为一个非负整数的数组。
		 * 指定每个 Tab 停靠位，以像素为单位。
		 * 如果没有指定自定义 Tab 停靠位 (null)，则默认的 Tab 停靠位为 4（平均字符宽度）。 
		 */
		public function get tabStops():Array
		{
			return _tabStops;
		}
		
		/**
		 * @private
		 */
		public function set tabStops(value:Array):void
		{
			if (_tabStops == value) return;
			_tabStops = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _target:String = "";
		
		/**
		 * 表示显示超链接的目标窗口。
		 * 如果目标窗口为空字符串，则文本显示在默认目标窗口 _self 中。
		 * 可以选择自定义名称或以下四种名称中的一个：_self 指定当前窗口中的当前帧，_blank 指定一个新窗口，_parent 指定当前帧的父级，_top 指定当前窗口中的顶级帧。
		 * 如果 TextFormat.url 属性是空字符串或 null，则虽然您可以获取或设置此属性，但该属性不起作用。 
		 */
		public function get target():String
		{
			return _target;
		}
		
		/**
		 * @private
		 */
		public function set target(value:String):void
		{
			if (_target == value) return;
			_target = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		private var _url:String = "";
		
		/**
		 * 表示使用此文本格式的文本的目标 URL。
		 * 如果 url 属性为空字符串，则文本没有超链接。
		 * 默认值为 null，它表示文本没有超链接。
		 * 意：必须使用 htmlText 属性对具有指定文本格式的文本进行设置以使超链接起作用。 
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			if (_url == value) return;
			_url = value;
			formatChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * 将 newText 参数指定的字符串追加到文本字段的文本的末尾。
		 * 此方法要比对 text 属性的加法赋值 (+=)（如 someTextField.text += moreText）更有效，对于包含大量内容的文本字段尤其有效。
		 * @param newText 要追加到现有文本末尾的字符串。
		 * 
		 */        
		public function appendText(newText:String):void
		{
			callLater(doAppendText, newText).descript = "appendText(" + newText + ")";
		}
		
		private function doAppendText(newText:String):void
		{
			textField.appendText(newText);
		}
		
		/**
		 * 将 beginIndex 和 endIndex 参数指定的字符范围替换为 newText 参数的内容。
		 * 正如所设计的一样，将替换从 beginIndex 到 endIndex-1 的文本。
		 * @param beginIndex 替换范围开始位置的从零开始的索引值
		 * @param endIndex 所需文本范围后面的第一个字符的从零开始的索引位置
		 * @param newText 要用来替换指定范围字符的文本
		 * 
		 */        
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
			callLater(doReplaceText, beginIndex, endIndex, newText).descript = "replaceText("+ beginIndex + "," + endIndex + "," + newText +")";
		}
		
		private function doReplaceText(indexBegin:int, indexEnd:int, newText:String):void
		{
			textField.replaceText(indexBegin, indexEnd, newText);
		}
		
		/**
		 * 替换选中的文本
		 *  
		 * @param value
		 * 
		 */        
		public function replaceSelectedText(newText:String):void
		{
			callLater(doReplaceSelectedText, newText).descript = "replaceSelectedText(" + newText + ")";
		}
		
		private function doReplaceSelectedText(newText:String):void
		{
			textField.replaceSelectedText(newText);
		}
		
		/**
		 * 选中操作
		 * 
		 * @param beginIndex 选中起始索引
		 * @param endIndex 选中结束索引
		 */		
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			callLater(doSetSelection, beginIndex, endIndex).descript = "setSelection(" + beginIndex + "," + endIndex + ")";
		}
		
		private function doSetSelection(beginIndex:int, endIndex:int):void
		{
			textField.setSelection(beginIndex, endIndex);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Override Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			textField = new TextField();
			textField.multiline = true;
			addChild(textField);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			// set textFormat
			if (formatChanged && !useHtmlText)
			{
				var format:TextFormat = textField.defaultTextFormat;
				format.size = fontSize * CocoUI.fontScale  // 增加全局的字体缩放功能
				format.color = color;
				format.align = textAlign;
				format.font = fontFamily;
				format.bold = bold;
				format.leading = leading;
				format.letterSpacing = letterSpacing;
				format.blockIndent = blockIndent;
				format.bullet = bullet;
				format.indent = indent;
				format.italic = italic;
				format.kerning = kerning;
				format.leftMargin = leftMargin;
				format.rightMargin = rightMargin;
				format.underline = underline;
				format.tabStops = tabStops;
				format.target = target;
				format.url = url;
				textField.defaultTextFormat = format;
			}
			
			// set textField
			if (textFieldChanged && !useHtmlText)
			{
				textField.displayAsPassword = displayAsPassword;
				textField.autoSize = TextFieldAutoSize.NONE;
				textField.embedFonts = embedFonts;
				textField.alwaysShowSelection = alwaysShowSelection;
				textField.antiAliasType = antiAliasType;
				textField.gridFitType = gridFitType;
				textField.condenseWhite = condenseWhite;
				textField.maxChars = maxChars;
				textField.mouseWheelEnabled = mouseWheelEnabled;
				textField.selectable = selectable;
				textField.sharpness = sharpness;
				textField.wordWrap = wordWrap;
			}
			
			if (useHtmlText)
			{
				textField.htmlText = text;
			}
			else
			{
				var newText:String = text;
				if (!textField.multiline)
				{
					newText = newText.replace(/\r/g, "\\r");
					newText = newText.replace(/\n/g, "\\n");
				}
				
				if (maxChars > 0 && newText.length > maxChars)
					newText = newText.substr(0, maxChars);
				
				textField.text = newText;
			}
			
			textChanged = false;
			formatChanged = false;
			textFieldChanged = false;
		}
		
		override protected function measure():void
		{
			if (textField)
			{
				measuredWidth = textField.textWidth + leftMargin + 
					rightMargin + blockIndent + indent + 4;
				measuredHeight = textField.textHeight + 4;
			}
			else
				super.measure();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
//			graphics.clear();
//			graphics.beginFill(0xFF0000);
//			graphics.drawRect(0, 0, width, height);
//			graphics.endFill();
			
			textField.width = width;
			textField.height = Math.min(height, textField.textHeight + 4);
			textField.y = (height - textField.height) / 2;
		}
		
	}
}