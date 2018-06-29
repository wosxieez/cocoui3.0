package coco.manager
{
	public interface IFocusComponent
	{
		/**
		 *
		 * 是否支持焦点 
		 * @return 
		 * 
		 */		
		function get focusEnabled():Boolean;
		function set focusEnabled(value:Boolean):void;
		
		/**
		 * 设置焦点
		 */		
		function setFocus():void;
	}
}