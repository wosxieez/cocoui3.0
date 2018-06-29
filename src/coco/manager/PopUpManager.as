package coco.manager
{
	import flash.display.DisplayObject;
	
	import coco.core.Application;
	import coco.core.coco;
	
	use namespace coco;
	
	/**
	 *
	 * Pop Up Manager
	 *
	 * <p>Used For Add or Remove an pop up child(displayObject) on Application</p>
	 *
	 * @author Coco
	 */
	public class PopUpManager
	{
		public function PopUpManager()
		{
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		// Variables
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private static var _application:Application;
		
		coco static function set application(value:Application):void
		{
			if (_application) throw Error("PopUpManager must be singleton");
			// if App has mutiple Application Component
			// We only use the first Application Component for PopUpManager
			_application = value;
		}
		
		/**
		 * Add an pop up child to Application
		 * 
		 * <p>20120519 Support modal properties</br>
		 * <code>backgroundColor</code></br>
		 * <code>backgroundAlpah</code></p> 
		 *
		 * @param child
		 * @param parent
		 * @param modal
		 * @param backgroundColor   used in modal
		 * @param backgroundAlpha   used in modal
		 * @return 
		 */
		public static function addPopUp(child:DisplayObject, 
										parent:DisplayObject = null, 
										modal:Boolean = false,
                                        closeWhenMouseClickOutside:Boolean = false,
										backgroundColor:uint = 0x000000,
										backgroundAlpha:Number = .1):DisplayObject
		{
			if (_application)
				_application.applicationPopUp.addPopUp(child, parent, modal, closeWhenMouseClickOutside, backgroundColor, backgroundAlpha);
			return child;
		}
		
		/**
		 * remove an pop up child from Appliation
		 *
		 * @param child
		 * @return
		 *
		 */
		public static function removePopUp(child:DisplayObject):DisplayObject
		{
			if (_application)
				_application.applicationPopUp.removePopUp(child);
			return child;
		}
		
		/**
		 * center an alrealy existed pop up child
		 *
		 * @param child
		 * @return
		 *
		 */
		public static function centerPopUp(child:DisplayObject):DisplayObject
		{
			if (_application)
				_application.applicationPopUp.centerPopUp(child);
			return child;
		}
		
	}
}