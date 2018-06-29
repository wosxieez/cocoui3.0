package coco.component
{
	import coco.core.IUIComponent;

	
	/**
	 * ItemRenderer Interface
	 * 
	 * @author Coco
	 * 
	 */	
	public interface IItemRenderer extends IUIComponent
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get index():int;
		function set index(value:int):void;
		
		/**
		 * <pre>
		 * data {label:"test", index:1}
		 * if labelField is 'label' : will show test
		 * if labelField is 'index' : will show 1
		 * default is 'label'</pre>
		 * 
		 * @return 
		 */		
		function get labelField():String;
		function set labelField(value:String):void;
		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
	}
}