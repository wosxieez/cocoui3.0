package coco.animation
{
    import flash.events.EventDispatcher;
	
	/**
	 * Animation
	 * 
	 * @author Coco
	 */	
	public class Tween extends EventDispatcher implements IAnimatable
	{
		
		private var animationTarget:Object;
		private var animationProperties:Vector.<AnimationProperty> = new Vector.<AnimationProperty>();
		private var animationEase:IEase;
		
		public function Tween(target:Object, duration:Number, ease:IEase = null)
		{
			super();
			
			animationTarget = target;
			totalTime = duration;
			if (ease)
				animationEase = ease;
			else
				animationEase = new Ease();
		}
        
        private var _totalTime:Number = 0;
        
        /**
         * totalTime 
         * ms
         * 
         * @return 
         */		
        public function get totalTime():Number
        {
            return _totalTime;
        }
        
        public function set totalTime(value:Number):void
        {
            _totalTime = value;
        }
        
        private var _currentTime:Number = 0;
        
        /**
         * currentTime
         * ms
         * 
         * @return 
         */	
        public function get currentTime():Number
        {
            return _currentTime;
        }
        
		public function set currentTime(value:Number):void
		{
            if (_currentTime == value)
                return;
            
			_currentTime = value;
			
			doAnimation();
			
			if (currentTime == totalTime && onComplete != null) onComplete.call();
		}
        
        private var _onComplete:Function = null;

        /**
         * 动画结束函数
         * @return 
         */        
        public function get onComplete():Function
        {
            return _onComplete;
        }

        public function set onComplete(value:Function):void
        {
            _onComplete = value;
        }
		
		private function doAnimation():void
		{
			if (!animationTarget || animationProperties.length == 0) return;
			
			for each (var animationProperty:AnimationProperty in animationProperties)
			{
                if (isNaN(animationProperty.from))
                    animationProperty.from = animationTarget[animationProperty.name] as Number;
                
				animationTarget[animationProperty.name] = (animationProperty.to - animationProperty.from) * animationEase.getRatio(currentTime / totalTime) +
					animationProperty.from;
			}
		}
		
        public function animate(property:String, endValue:Number):void
        {
            if (animationTarget == null) return; // tweening null just does nothing.
            
            animationProperties.push(new AnimationProperty(property, NaN, endValue));
        }
	}
}

class AnimationProperty
{
	public function AnimationProperty(proName:String, proFrom:Number, proTo:Number)
	{
		name = proName;
		from = proFrom;
		to = proTo;
	}
	
	public var from:Number;
	public var to:Number;
	public var name:String;
}