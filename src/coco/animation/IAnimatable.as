package coco.animation
{
	/**
	 * TimeLine Interface
	 * 
	 * @author Coco
	 */	
	public interface IAnimatable
	{
		function get totalTime():Number;
		function set totalTime(value:Number):void;
		
		function get currentTime():Number;
		function set currentTime(value:Number):void;
	}
}