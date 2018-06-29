package coco.animation
{
	public class CubicInOut extends Ease
	{
		public function CubicInOut()
		{
			super();
		}
		
		override public function getRatio(p:Number):Number 
		{
			var r:Number = (p < 0.5) ? p * 2 : (1 - p) * 2;
			r *= r * r;
			return (p < 0.5) ? r / 2 : 1 - (r / 2);
		}
		
	}
}