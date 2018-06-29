package coco.component
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    
    import coco.core.UIComponent;
    import coco.manager.CacheManager;
    import coco.util.CocoUI;
    import coco.util.debug;
    
    /**
     * 缓存图片  
     * 使用此组件加载的bitmapdata将会自动被缓存
     * 在下一次使用的时候 将自动从缓存里读取
     * 
     * @author Coco
     */	
    public class Image extends UIComponent
    {
        public function Image()
        {
            super();
        }
        
        
        //--------------------------------------------------------------------------------------------------
        //
        //  Vars
        //
        //--------------------------------------------------------------------------------------------------
        
        private var _source:Object;
        
        /**
         * 图片源
         * 
         * @return 
         */		
        public function get source():Object
        {
            return _source;
        }
        
        public function set source(value:Object):void
        {
            if (_source == value)
                return;
            
            _source = value;
            invalidateProperties();
        }
        
        private var _bitmapdata:BitmapData;
        
        public function get bitmapdata():BitmapData
        {
            return _bitmapdata;
        }
        
        public function set bitmapdata(value:BitmapData):void
        {
            if (_bitmapdata == value)
                return;
			
            _bitmapdata = value;
            invalidateSize();
            invalidateDisplayList();
        }
        
        private var _scaleGrid:Array = null; 
        
        /**
         * [left, top, right, bottom]
         * 
         * @return 
         */	
        public function get scaleGrid():Array
        {
            return _scaleGrid;
        }
        
        public function set scaleGrid(value:Array):void
        {
            if (_scaleGrid == value)
                return;
            _scaleGrid = value;
            invalidateDisplayList();
        }
        
        private var _fillMode:String = "scale";
        
        /**
         * <p>填充模式</p>
         * <p>clip 剪切</p>
         * <p>repeat 重复</p>
         * <p>scale 缩放</p>
         * 
         * @defualt scale
         * @return 
         */        
        public function get fillMode():String
        {
            return _fillMode;
        }
        
        public function set fillMode(value:String):void
        {
            if (_fillMode == value)
                return;
            _fillMode = value;
            invalidateDisplayList();
        }
        
        
        //--------------------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------------------------------
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            
            if (_source)
            {
                if (_source is BitmapData)
                    bitmapdata = _source as BitmapData;
                else if (_source is String)
                    loadBMD();
                else if (_source is Bitmap)
                    bitmapdata = Bitmap(_source).bitmapData;
                else if (_source is Class)
                    bitmapdata = new _source().bitmapData;
            }
			else
				bitmapdata = null;
        }
        
        override protected function measure():void
        {
            if (_bitmapdata)
            {
                measuredWidth = _bitmapdata.width;
                measuredHeight = _bitmapdata.height;
            }
            else
                super.measure();
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
            graphics.clear();
            
            if (bitmapdata)
            {
                var drawWidth:Number = width;
                var drawHeight:Number = height;
                if (scaleGrid)
                    drawScaleGridBitmapdata();
                else
                    drawBitmapdata(bitmapdata, drawWidth, drawHeight, 0, 0);
            }
        }
        
        private function loadBMD():void
        {
            var loadBitmapdata:BitmapData;
            
            // 如果使用图片缓存，将从缓存中读取图片数据
            if (CocoUI.useImageCache)
                loadBitmapdata = CacheManager.getBitmapdata(source as String);
            
            if (loadBitmapdata)
                bitmapdata = loadBitmapdata;
            else
            {
                var loader:Loader = new Loader();
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBMDOk);
                loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadBMDError);
                loader.load(new URLRequest(source as String));
            }
        }
        
        protected function loadBMDOk(event:Event):void
        {
            var loadBitmapdata:BitmapData = Bitmap(event.currentTarget.content).bitmapData;
            bitmapdata = loadBitmapdata;
            
            //  如果使用图片缓存，将自动存储图片数据
            if (CocoUI.useImageCache)
                CacheManager.setBitmapdata(source as String, loadBitmapdata);
        }
        
        protected function loadBMDError(event:IOErrorEvent):void
        {
            debug("[" + name + "]" + event.text);
            bitmapdata = null;
        }
        
        private function drawScaleGridBitmapdata():void
        {
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(0, 0, scaleGrid[0], scaleGrid[1])), 
                scaleGrid[0], scaleGrid[1]); // left top
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(0, scaleGrid[1], scaleGrid[0], bitmapdata.height - scaleGrid[1] - scaleGrid[3])), 
                scaleGrid[0], height - scaleGrid[1] - scaleGrid[3], 0, scaleGrid[1]); // left middle
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(0, bitmapdata.height - scaleGrid[3], scaleGrid[0], scaleGrid[3])), 
                scaleGrid[0], scaleGrid[3], 0, height - scaleGrid[3]); // left bottom
            
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(scaleGrid[0], 0, bitmapdata.width - scaleGrid[0] - scaleGrid[2], scaleGrid[1])), 
                width - scaleGrid[0] -scaleGrid[2], scaleGrid[1], scaleGrid[0]); // center top
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(scaleGrid[0], scaleGrid[1], bitmapdata.width - scaleGrid[0] - scaleGrid[2], bitmapdata.height - scaleGrid[1] - scaleGrid[3])), 
                width - scaleGrid[0] - scaleGrid[2], height - scaleGrid[1] - scaleGrid[3], scaleGrid[0], scaleGrid[1]); // center middle
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(scaleGrid[0], bitmapdata.height- scaleGrid[3], bitmapdata.width - scaleGrid[0] - scaleGrid[2] , scaleGrid[3])), 
                width - scaleGrid[0] - scaleGrid[2], scaleGrid[3], scaleGrid[0], height - scaleGrid[3]); // center bottom
            
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(bitmapdata.width - scaleGrid[2], 0, scaleGrid[2], scaleGrid[1])), 
                scaleGrid[2], scaleGrid[1], width - scaleGrid[2]); // right top
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(bitmapdata.width - scaleGrid[2], scaleGrid[1], scaleGrid[2], bitmapdata.height - scaleGrid[1] - scaleGrid[3])), 
                scaleGrid[2], height - scaleGrid[1] - scaleGrid[3], width - scaleGrid[2], scaleGrid[1]); // right middle
            drawBitmapdata(getRectBitmapdata(bitmapdata, new Rectangle(bitmapdata.width - scaleGrid[2], bitmapdata.height - scaleGrid[3], scaleGrid[2], scaleGrid[3])), 
                scaleGrid[2], scaleGrid[3], width - scaleGrid[2], height - scaleGrid[3]); // right bottom
        }
        
        private function getRectBitmapdata(source:BitmapData, rect:Rectangle):BitmapData
        {
            var data:BitmapData = new BitmapData(rect.width, rect.height);
            data.copyPixels(source, rect, new Point(0, 0));
            return data;
        }
        
        /**
         * 绘制bitmpdata
         * 
         * @param toDrawBitmapdata 将要绘制的bitmapdata
         * @param toDrawWidth   绘制的宽地
         * @param toDrawHeight	绘制的高度
         * @param toDrawX	绘制的x坐标
         * @param toDrawY	绘制的y坐标
         */		
        protected function drawBitmapdata(toDrawBitmapdata:BitmapData, 
                                          toDrawWidth:Number, 
                                          toDrawHeight:Number,  
                                          toDrawX:Number = 0, 
                                          toDrawY:Number = 0):void
        {
            var fillWidth:Number = fillMode == "clip" ? Math.min(toDrawWidth, toDrawBitmapdata.width) : toDrawWidth;
            var fillHeight:Number = fillMode == "clip" ? Math.min(toDrawHeight, toDrawBitmapdata.height) : toDrawHeight;
            var matrix:Matrix = new Matrix();
            if (fillMode == "scale")
                matrix.scale(toDrawWidth/toDrawBitmapdata.width, toDrawHeight/toDrawBitmapdata.height);
            matrix.translate(toDrawX, toDrawY);
            graphics.beginBitmapFill(toDrawBitmapdata, matrix, fillMode == "repeat" ? true : false, true);
            graphics.drawRect(toDrawX, toDrawY, fillWidth, fillHeight);
            graphics.endFill();
        }
    }
}