package coco.layout
{
    import coco.core.UIComponent;

    
    /**
     * 
     * All Layout Super Class
     * 
     * @author Coco
     * 
     */    
    public class LayoutBase
    {
        public function LayoutBase()
        {
        }
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //----------------------------------------------------------------------------------------------------------------
        
        private var _target:UIComponent;
        
        public function get target():UIComponent
        {
            return _target;
        }
        
        public function set target(value:UIComponent):void
        {
            _target = value;
        }
        
        protected var layoutWidth:Number = 0;
        protected var layoutHeight:Number = 0;
        
        //----------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //----------------------------------------------------------------------------------------------------------------
        
        
        /**
         * layout target should call <code>layout.updateDisplayList()</code> </br>
         * 
         * layout sub class sholud override <code>updateLayout()</code>
         * 
         */ 
        public final function updateDisplayList():void
        {
            if (!target) return;
            
            updateLayout();
            target.invalidateSize();
        }
        
        protected function updateLayout():void
        {
            // override here
        }
        
        public function getLayoutWidth():Number
        {
            // override here
            return layoutWidth;
        }
        
        public function getLayoutHeight():Number
        {
            // override here
            return layoutHeight;
        }
    }
}