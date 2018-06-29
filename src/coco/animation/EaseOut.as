package coco.animation
{
    public class EaseOut extends Ease
    {
        public function EaseOut()
        {
            super();
        }
        
        override public function getRatio(p:Number):Number 
        {
            var invRatio:Number = p - 1.0;
            return invRatio * invRatio * invRatio + 1;
        }
        
    }
}