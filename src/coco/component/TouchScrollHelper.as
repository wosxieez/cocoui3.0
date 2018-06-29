package coco.component
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;
    
    import coco.core.UIComponent;
    
    /**
     * Scroll Helper
     * 
     * @author Coco
     * 
     */ 
    [ExcludeClass]
    public class TouchScrollHelper
    {
        public function TouchScrollHelper()
        {
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Static const
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private static const VELOCITY_WEIGHT:Number = 2.33;
        private static const VELOCITY_WEIGHTS:Vector.<Number> = Vector.<Number>([1, 1.33, 1.66, 2]);

        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Variables
        //
        //----------------------------------------------------------------------------------------------------------------
        
        public var target:UIComponent;
        public var dragMinDistance:Number = 5;
        public var dragHorizontalFunction:Function;
        public var dragVerticalFunction:Function;
        public var throwHorizontalFunction:Function;
        public var throwVerticelFunction:Function;
        
        private var isDraging:Boolean = false;
        private var scrollListenersInstalled:Boolean = false;
        private var mousePointTimes:Vector.<MousePointTime>;
        private var mouseXOld:Number;
        private var mouseYOld:Number;
        private var mouseXNew:Number; 
        private var mouseYNew:Number; 
        
        
        //----------------------------------------------------------------------------------------------------------------
        //
        //  Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        public function startScrollWatch(event:MouseEvent):void
        {
            if (event is MouseEvent && event.type == MouseEvent.MOUSE_DOWN)
            {
                mouseXOld = event.stageX;
                mouseYOld = event.stageY;
                installScrollListeners();
                mouseDownHandler(event);
            }
        }
        
        public function stopScrollWatch():void
        {
            uninstallScrollListeners();
        }
        
        private function installScrollListeners():void
        {
            if (!target || !target.stage)
                return;
            
            target.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
            target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            
            scrollListenersInstalled = true;
        }
        
        private function uninstallScrollListeners():void
        {
            if (!target || !target.stage)
                return;
            
            target.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
            target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
            target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
            
            scrollListenersInstalled = false;
        }
        
        protected function mouseDownHandler(event:MouseEvent):void
        {
            mousePointTimes = new Vector.<MousePointTime>();
            mouseXNew = event.stageX;
            mouseYNew = event.stageY;
            addMousePointTime();
        }
        
        protected function mouseMoveHandler(event:MouseEvent):void
        {
            mouseXNew = event.stageX;
            mouseYNew = event.stageY;
            
            var dx:Number = mouseXNew - mouseXOld;
            var dy:Number = mouseYNew - mouseYOld;
            
            // drag horizontal
            if (Math.abs(dx) > dragMinDistance && dragHorizontalFunction != null)
            {
                isDraging = true;
                dragHorizontalFunction(dx > 0 ? dx - dragMinDistance : dx + dragMinDistance);
            }
            
            // drag vertical
            if (Math.abs(dy) > dragMinDistance && dragVerticalFunction != null)
            {
                isDraging = true;
                dragVerticalFunction(dy > 0 ? dy - dragMinDistance : dy + dragMinDistance);
            }
            
            // Note... just for smooth
            event.updateAfterEvent();
        }
        
        protected function enterFrameHandler(event:Event):void
        {
            if (!scrollListenersInstalled)
                return;
            
            addMousePointTime();
        }
        
        protected function mouseUpHandler(event:MouseEvent):void
        {
            if (!scrollListenersInstalled)
                return;
            
            if (isDraging)
            {
                isDraging = false;
                event.stopPropagation();
            }
            
            mouseXNew = event.stageX;
            mouseYNew = event.stageY;
            addMousePointTime();
            
            uninstallScrollListeners();
            
            calculateThrowVelocity();
        }
        
        private function addMousePointTime():void
        {
            mousePointTimes.push(new MousePointTime(mouseXNew, mouseYNew, getTimer()));
            if (mousePointTimes.length > 5)
                mousePointTimes.shift();
        }
        
        private function calculateThrowVelocity():void
        {
            var dt:Number;
            var dx:Number;
            var dy:Number;
            var vx:Number;
            var vy:Number;
            
            var weight:Number;
            var weightX:Number = NaN;
            var weightY:Number = NaN;
            var weightTotal:Number = VELOCITY_WEIGHT;
            
            var mousePointTimeOld:MousePointTime;
            var mousePointTimeNew:MousePointTime = mousePointTimes.pop();
            
            while (mousePointTimes.length > 0)
            {
                mousePointTimeOld = mousePointTimes.pop();
                
                dt = mousePointTimeNew.time - mousePointTimeOld.time;
                dx = mousePointTimeNew.x - mousePointTimeOld.x;
                dy = mousePointTimeNew.y - mousePointTimeOld.y;
                
                vx = dx / dt;
                vy = dy / dt;
                
                if (isNaN(weightX)) weightX = vx * VELOCITY_WEIGHT;
                if (isNaN(weightY)) weightY = vy * VELOCITY_WEIGHT;
                
                weight = VELOCITY_WEIGHTS[mousePointTimes.length];
                weightX += vx * weight;
                weightY += vy * weight;
                weightTotal += weight;
            }
            
            var velocityX:Number = weightX / weightTotal;
            var veloictyY:Number = weightY / weightTotal;
            
            // throw horizontal
            if (throwHorizontalFunction != null)
                throwHorizontalFunction(velocityX);
            
            // throw vertical
            if (throwVerticelFunction != null)
                throwVerticelFunction(veloictyY);
        }
        
        
    }
}


class MousePointTime
{
    public function MousePointTime(x:Number, y:Number, time:int)
    {
        this.x = x;
        this.y = y;
        this.time = time;
    }
    
    public var x:Number;
    public var y:Number;
    public var time:int;
}