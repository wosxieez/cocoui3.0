package coco.animation
{
	public class CircOut extends Ease
	{
		public function CircOut()
		{
			super();
		}
		
		override public function getRatio(p:Number):Number 
		{
			return Math.sqrt(1 - (p = p - 1) * p);
		}
		
	}
}