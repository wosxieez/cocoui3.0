package coco.component
{
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    import coco.animation.EaseOut;
    import coco.animation.IEase;
    import coco.animation.Juggler;
    import coco.animation.Tween;
    import coco.core.UIComponent;
    import coco.core.coco;
    import coco.event.UIEvent;
    
    use namespace coco;
    
    /**
     * 支持滚动的组件
     * 
     * @author Coco
     */	
    public class Scroller extends UIComponent
    {
        public function Scroller()
        {
            super();
            
            touchScrollHelper = new TouchScrollHelper();
            touchScrollHelper.target = this;
            touchScrollHelper.dragHorizontalFunction = dragHorizontal;
            touchScrollHelper.dragVerticalFunction = dragVertical;
            touchScrollHelper.throwHorizontalFunction = throwHorizontal;
            touchScrollHelper.throwVerticelFunction = throwVertical;
            installScrollListeners();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Static const
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private static const LOG_DECELERATION_RATE:Number = -0.0020020026706730793;
        private static const MIN_VELOCITY:Number = 0.2; // piexls per ms
        private static const ELASTICITY_RATIO:Number = 0.7;
        private static const ELASTICITY_DURATION:Number = 500; // ms
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Variables
        //
        //----------------------------------------------------------------------------------------------------------------
        
        public var horizontalScrollEnabled:Boolean = true;
        public var verticalScrollEnabled:Boolean = true;
        
        private var viewport:UIComponent;
        private var touchScrollHelper:TouchScrollHelper;
        
        private var horizontalScrollPositionOld:Number;
        private var verticalScrollPositionOld:Number;
        
        private var horizontalScrollThrowTween:Tween;
        private var horizontalScrollFinishTween:Tween;
        private var verticalScrollThrowTween:Tween;
        private var verticalScrollFinishTween:Tween;
        
        private var throwEase:IEase = new EaseOut();
        
        private var _minVerticalScrollPosition:Number = 0;
        
        /**
         * 纵向最小滚动位置 
         */
        public function get minVerticalScrollPosition():Number
        {
            return _minVerticalScrollPosition;
        }
        
        /**
         * @private
         */
        public function set minVerticalScrollPosition(value:Number):void
        {
            _minVerticalScrollPosition = value;
        }
        
        
        private var _maxVerticalScrollPosition:Number = 0;
        
        /**
         * 纵向最大滚动位置 
         */
        public function get maxVerticalScrollPosition():Number
        {
            return _maxVerticalScrollPosition;
        }
        
        /**
         * @private
         */
        public function set maxVerticalScrollPosition(value:Number):void
        {
            _maxVerticalScrollPosition = value;
        }
        
        
        private var _verticalScrollPosition:Number = 0;
        
        /**
         * 当前滚动位置 
         */
        public function get verticalScrollPosition():Number
        {
            return _verticalScrollPosition;
        }
        
        /**
         * @private
         */
        public function set verticalScrollPosition(value:Number):void
        {
            var valueAbs:Number = Math.round(value);
            if (_verticalScrollPosition == valueAbs)
                return;
            
            _verticalScrollPosition = valueAbs;
            invalidateViewportPosition();
        }
        
        private var _minHorizontalScrollPosition:Number = 0;
        
        public function get minHorizontalScrollPosition():Number
        {
            return _minHorizontalScrollPosition;
        }
        
        public function set minHorizontalScrollPosition(value:Number):void
        {
            _minHorizontalScrollPosition = value;
        }
        
        private var _maxHorizontalScrollPosition:Number = 0;
        
        public function get maxHorizontalScrollPosition():Number
        {
            return _maxHorizontalScrollPosition;
        }
        
        public function set maxHorizontalScrollPosition(value:Number):void
        {
            _maxHorizontalScrollPosition = value;
        }
        
        private var _horizontalScrollPosition:Number = 0;
        
        public function get horizontalScrollPosition():Number
        {
            return _horizontalScrollPosition;
        }
        
        public function set horizontalScrollPosition(value:Number):void
        {
            var valueAbs:Number = Math.round(value);
            if (_horizontalScrollPosition == valueAbs)
                return;
            
            _horizontalScrollPosition = valueAbs;
            invalidateViewportPosition();
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        override public function addChild(child:DisplayObject):DisplayObject
        {
            uninstallViewPort();
            viewport = child as UIComponent;
            installViewPort();
            return super.addChild(child);
        }
        
        override public function addChildAt(child:DisplayObject, index:int):DisplayObject
        {
            uninstallViewPort();
            viewport = child as UIComponent;
            installViewPort();
            return super.addChildAt(child, index);
        }
        
        private function installViewPort():void
        {
            if (viewport)
            {
                viewport.addEventListener(UIEvent.RESIZE, viewport_resizeHandler);
                invalidateDisplayList();
            }
        }
        
        private function uninstallViewPort():void
        {
            if (viewport)
            {
                viewport.removeEventListener(UIEvent.RESIZE, viewport_resizeHandler);
                removeChild(viewport);
            }
        }
        
        private function viewport_resizeHandler(event:UIEvent):void
        {
            invalidateDisplayList();
        }
        
        override protected function measure():void
        {
            measuredHeight = measuredWidth = 200;
        }
        
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
            
//            graphics.clear();
//            graphics.beginFill(0xFFFFFF, 0);
//            graphics.drawRect(0, 0, width, height);
//            graphics.endFill();
            
            scrollRect = new Rectangle(0, 0, width, height);
            
            updateViewport();
        }
        
        private var invalidateViewportPositionFlag:Boolean = false;
        
        private function invalidateViewportPosition():void
        {
            if (!invalidateViewportPositionFlag)
            {
                invalidateViewportPositionFlag = true;
                callLater(validateViewportPosition).descript = "updateViewportPosition()";
            }
        }
        
        private function validateViewportPosition():void
        {
            if (invalidateViewportPositionFlag)
            {
                invalidateViewportPositionFlag = false;
                updateViewportPosition();
            }
        }
        
        protected function updateViewportPosition():void
        {
            if (viewport)
            {
                viewport.x = minHorizontalScrollPosition - horizontalScrollPosition;
                viewport.y = minVerticalScrollPosition - verticalScrollPosition;
            }
        }
        
        protected function updateViewport():void
        {
            if (!viewport)
            {
                minHorizontalScrollPosition = maxHorizontalScrollPosition = horizontalScrollPosition = width;
                minVerticalScrollPosition = maxVerticalScrollPosition = verticalScrollPosition = height;
            }
            else
            {
                if (viewport.width > width)
                {
                    horizontalScrollPosition = minHorizontalScrollPosition = width;
                    maxHorizontalScrollPosition = viewport.width;
                }
                else
                    minHorizontalScrollPosition = maxHorizontalScrollPosition = horizontalScrollPosition = width;
                
                if (viewport.height > height)
                {
                    verticalScrollPosition = minVerticalScrollPosition = height;
                    maxVerticalScrollPosition = viewport.height;
                    verticalScrollEnabled = true;
                }
                else
                    minVerticalScrollPosition = maxVerticalScrollPosition = verticalScrollPosition = height;
            }
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Scroll Code
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private function installScrollListeners():void
        {
            if (!hasEventListener(MouseEvent.MOUSE_DOWN))
                addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
        
        private function uninstallScrollListeners():void
        {
            if (hasEventListener(MouseEvent.MOUSE_DOWN))
                removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
        
        private function mouseDownHandler(event:MouseEvent):void
        {
            finishScrollPosition();
            
            horizontalScrollPositionOld = horizontalScrollPosition;
            verticalScrollPositionOld = verticalScrollPosition;
            
            touchScrollHelper.startScrollWatch(event);
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Horizontal Drag Scroll 
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private function dragHorizontal(horizontalDistance:Number):void
        {
			var scale:Number = application ? application.scaleX : 1; 
            horizontalDistance = horizontalDistance / scale; // application was scale
            dragHorizontalScrollPosition(horizontalScrollPositionOld - horizontalDistance);
        }
        
        private function throwHorizontal(horizontalVelocity:Number):void
        {
			var scale:Number = application ? application.scaleX : 1; // application was scale
            horizontalVelocity = horizontalVelocity / scale; 
            horizontalScrollPositionOld = horizontalScrollPosition;
            
            if (horizontalScrollEnabled && Math.abs(horizontalVelocity) > MIN_VELOCITY)
                throwHorizontalScrollPosition(horizontalScrollPositionOld + calculateThrowDistance(horizontalVelocity), 
                    calculateThrowDuration(horizontalVelocity));
            else
                finishHorizontalScrollPosition();
        }
        
        private function dragHorizontalScrollPosition(newHorizontalScrollPositon:Number):void
        {
            if (newHorizontalScrollPositon < minHorizontalScrollPosition)
                newHorizontalScrollPositon -= (newHorizontalScrollPositon - minHorizontalScrollPosition) * ELASTICITY_RATIO;
            else if (newHorizontalScrollPositon > maxHorizontalScrollPosition)
                newHorizontalScrollPositon -= (newHorizontalScrollPositon - maxHorizontalScrollPosition) * ELASTICITY_RATIO;
            horizontalScrollPosition = newHorizontalScrollPositon;
        }
        
        private function throwHorizontalScrollPosition(newHorizontalScrollPositon:Number, duration:Number):void
        {
            if (horizontalScrollPosition < minHorizontalScrollPosition ||
                horizontalScrollPosition > maxHorizontalScrollPosition)
                finishHorizontalScrollPosition();
            else
            {
                if (newHorizontalScrollPositon < minHorizontalScrollPosition)
                {
                    newHorizontalScrollPositon = minHorizontalScrollPosition;
                    duration = ELASTICITY_DURATION;
                }
                else if (newHorizontalScrollPositon > maxHorizontalScrollPosition)
                {
                    newHorizontalScrollPositon = maxHorizontalScrollPosition;
                    duration = ELASTICITY_DURATION;
                }
                
                if (horizontalScrollThrowTween)
                    Juggler.remove(horizontalScrollThrowTween);
                
                horizontalScrollThrowTween = new Tween(this, duration, throwEase);
                horizontalScrollThrowTween.animate("horizontalScrollPosition", newHorizontalScrollPositon);
                horizontalScrollThrowTween.onComplete = finishThrowHorizontalScrollPosition;
                Juggler.add(horizontalScrollThrowTween);
            }
        }
        
        private function finishThrowHorizontalScrollPosition():void
        {
            finishHorizontalScrollPosition();
        }
        
        private function finishHorizontalScrollPosition():void
        {
            var finishHorizontalScrollPosition:Number = NaN;
            if (horizontalScrollPosition < minHorizontalScrollPosition)
                finishHorizontalScrollPosition = minHorizontalScrollPosition;
            else if (horizontalScrollPosition > maxHorizontalScrollPosition)
                finishHorizontalScrollPosition = maxHorizontalScrollPosition;
            
            if (!isNaN(finishHorizontalScrollPosition))
            {
                if (horizontalScrollFinishTween)
                    Juggler.remove(horizontalScrollFinishTween);
                
                horizontalScrollFinishTween = new Tween(this, ELASTICITY_DURATION, throwEase);
                horizontalScrollFinishTween.animate("horizontalScrollPosition", finishHorizontalScrollPosition);
                Juggler.add(horizontalScrollFinishTween);
            }
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Vertical Drag Scroll 
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private function dragVertical(verticalDistance:Number):void
        {
			var scale:Number = application ? application.scaleY : 1;
            verticalDistance = verticalDistance / scale; // application was scale
            dragVerticalScrollPosition(verticalScrollPositionOld - verticalDistance);
        }
        
        private function throwVertical(verticalVelocity:Number):void
        {
			var scale:Number = application ? application.scaleY : 1;
            verticalVelocity = verticalVelocity / scale; // application was scale
            verticalScrollPositionOld = verticalScrollPosition;
            
            if (verticalScrollEnabled && Math.abs(verticalVelocity) > MIN_VELOCITY)
                throwVerticalScrollPosition(verticalScrollPositionOld + calculateThrowDistance(verticalVelocity), 
                    calculateThrowDuration(verticalVelocity));
            else
                finishVerticalScrollPosition();
        }
        
        private function dragVerticalScrollPosition(newVerticalScrollPosition:Number):void
        {
            if (newVerticalScrollPosition < minVerticalScrollPosition)
                newVerticalScrollPosition -= (newVerticalScrollPosition - minVerticalScrollPosition) * ELASTICITY_RATIO;
            else if (newVerticalScrollPosition > maxVerticalScrollPosition)
                newVerticalScrollPosition -= (newVerticalScrollPosition - maxVerticalScrollPosition) * ELASTICITY_RATIO;
            verticalScrollPosition = newVerticalScrollPosition;
        }
        
        private function throwVerticalScrollPosition(newVerticalScrollPositon:Number, duration:Number):void
        {
            if (verticalScrollPosition < minVerticalScrollPosition ||
                verticalScrollPosition > maxVerticalScrollPosition)
                finishVerticalScrollPosition();
            else
            {
                if (newVerticalScrollPositon < minVerticalScrollPosition)
                {
                    newVerticalScrollPositon = minVerticalScrollPosition;
                    duration = ELASTICITY_DURATION;
                }
                else if (newVerticalScrollPositon > maxVerticalScrollPosition)
                {
                    newVerticalScrollPositon = maxVerticalScrollPosition;
                    duration = ELASTICITY_DURATION;
                }
                
                if (verticalScrollThrowTween)
                    Juggler.remove(verticalScrollThrowTween);
                
                verticalScrollThrowTween = new Tween(this, duration, throwEase);
                verticalScrollThrowTween.animate("verticalScrollPosition", newVerticalScrollPositon);
                verticalScrollThrowTween.onComplete = finishThrowVerticalScrollPosition;
                Juggler.add(verticalScrollThrowTween);
            }
        }
        
        private function finishThrowVerticalScrollPosition():void
        {
            finishVerticalScrollPosition();
        }
        
        private function finishVerticalScrollPosition():void
        {
            var finishVerticalScrollPosition:Number = NaN;
            if (verticalScrollPosition < minVerticalScrollPosition)
                finishVerticalScrollPosition = minVerticalScrollPosition;
            else if (verticalScrollPosition > maxVerticalScrollPosition)
                finishVerticalScrollPosition = maxVerticalScrollPosition;
            
            if (!isNaN(finishVerticalScrollPosition))
            {
                if (verticalScrollFinishTween)
                    Juggler.remove(verticalScrollFinishTween);
                
                verticalScrollFinishTween = new Tween(this, ELASTICITY_DURATION, throwEase);
                verticalScrollFinishTween.animate("verticalScrollPosition", finishVerticalScrollPosition);
                Juggler.add(verticalScrollFinishTween);
            }
        }
        
        private function finishScrollPosition():void
        {
            if (touchScrollHelper)
                touchScrollHelper.stopScrollWatch();
            if (horizontalScrollFinishTween)
                Juggler.remove(horizontalScrollFinishTween);
            if (horizontalScrollThrowTween)
                Juggler.remove(horizontalScrollThrowTween);
            if (verticalScrollFinishTween)
                Juggler.remove(verticalScrollFinishTween);
            if (verticalScrollThrowTween)
                Juggler.remove(verticalScrollThrowTween);
        }
        
        protected function calculateThrowDuration(velocity:Number):Number
        {
            return Math.log(MIN_VELOCITY / Math.abs(velocity)) / LOG_DECELERATION_RATE;
        }
        
        protected function calculateThrowDistance(velocity:Number):Number
        {
            return (velocity - MIN_VELOCITY) / LOG_DECELERATION_RATE;
        }
        
    }
}