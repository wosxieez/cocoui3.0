package coco.animation
{
    import flash.display.Shape;
    import flash.events.Event;
    import flash.utils.getTimer;
    
    import coco.util.debug;
    
    /**
     * Juggler
     * 
     * @author Coco
     */	
    public class Juggler
    {
        public function Juggler()
        {
        }
        
        private static var timer:Shape = new Shape();
        private static var animatables:Vector.<IAnimatable> = new Vector.<IAnimatable>();
        private static var playing:Boolean = false;
        private static var curTimer:Number;
        
        /**
         * add animatable
         * 
         * @param timeLine
         */		
        public static function add(animatable:IAnimatable):void
        {
            if (animatable && animatables.indexOf(animatable) == -1)
                animatables.push(animatable);
            
            if (!playing)
            {
                debug("[Juggler] Start");
                startTimer();
                playing = true;
            }
        }
        
        /**
         * contains
         * @param object
         * @return 
         */        
        public function contains(animatable:IAnimatable):Boolean
        {
            return animatables.indexOf(animatable) != -1;
        }
        
        /**
         * remove animatable
         * 
         * @param timeLine
         */		
        public static function remove(animatable:IAnimatable):void
        {
            if (animatable == null) return;
            
            for (var i:int = animatables.length - 1; i >= 0; i--)
            {
                if (animatables[i] == animatable)
                    animatables.splice(i, 1);
            }
        }
        
        private static function startTimer():void
        {
            curTimer = getTimer();
            timer.addEventListener(Event.ENTER_FRAME, render);
        }
        
        private static function stopTimer():void
        {
            timer.removeEventListener(Event.ENTER_FRAME, render);
        }
        
        protected static function render(event:Event):void
        {
            var oldTimer:Number = curTimer;
            curTimer = getTimer();
            var timerGap:Number = curTimer - oldTimer;
            
            var animatable:IAnimatable;
            for (var i:int = animatables.length - 1; i >= 0; i--)
            {
                animatable = animatables[i] as IAnimatable;
                if (animatable)
                {
                    if (animatable.currentTime +  timerGap < animatable.totalTime)
                        animatable.currentTime += timerGap;
                    else
                    {
                        animatable.currentTime = animatable.totalTime;
                        remove(animatable); // remove animatable
                    }
                }
            }
            
            if (animatables.length == 0)
            {
                debug("[Juggler] Stop");
                stopTimer();
                playing = false;
            }
        }
        
    }
}