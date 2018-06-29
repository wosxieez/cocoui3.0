package coco.animation
{
    public class Power extends Ease
    {
        public function Power()
        {
            super();
        }
        
        override public function getRatio(p:Number):Number 
        {
            return 1 - Math.pow((1 - p), 3);
        }
    }
}