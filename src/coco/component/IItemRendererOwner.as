package coco.component
{
	import flash.events.IEventDispatcher;

	
	/**
	 * IItemRendererOwner Interface
	 * 
	 * @author Coco
	 * 
	 */	
	public interface IItemRendererOwner extends IEventDispatcher
	{
		function set requestSelection(value:Boolean):void;
		function get requestSelection():Boolean;
		
		function set allowMultipleSelection(value:Boolean):void;
		function get allowMultipleSelection():Boolean;
		
		function set selectedIndex(value:int):void;
		function get selectedIndex():int;
		
		function set selectedIndices(value:Vector.<int>):void;
		function get selectedIndices():Vector.<int>;
        
        function get name():String;
		
	}
}