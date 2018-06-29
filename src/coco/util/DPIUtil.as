package coco.util
{
    import flash.display.Stage;
    import flash.system.Capabilities;

    /**
     *
     * DPI Util
     * Copy From Adobe
     *
     * @auther Coco
     */
    public class DPIUtil
    {
        public function DPIUtil()
        {
        }

        public static const DPI_120:Number = 120;
        public static const DPI_160:Number = 160;
        public static const DPI_240:Number = 240;
        public static const DPI_320:Number = 320;
        public static const DPI_480:Number = 480;
        public static const DPI_640:Number = 640;

        private static const IPAD_MAX_EXTENT:int = 1024;
        private static const IPAD_RETINA_MAX_EXTENT:int = 2048;

        public static function getRuntimeDPI(stage:Stage):Number
        {
            var isIOS:Boolean = Platform.isIOS;
            var screenDPI:Number = Capabilities.screenDPI;

            if (isIOS && stage) // as isIPad returns false in the simulator
            {
                var scX:Number = stage.fullScreenWidth;
                var scY:Number = stage.fullScreenHeight;
                if ((scX == IPAD_RETINA_MAX_EXTENT || scY == IPAD_RETINA_MAX_EXTENT))
                    return DPI_320;
                else if (scX == IPAD_MAX_EXTENT || scY == IPAD_MAX_EXTENT)
                    return DPI_160;
            }

            return getDPI(screenDPI);
        }

        public static function getDPIScale(sourceDPI:Number, targetDPI:Number):Number
        {
            // unkonwn dpi return 1
            if ((sourceDPI != DPI_120 && sourceDPI != DPI_160 && sourceDPI != DPI_240 && sourceDPI != DPI_320 && sourceDPI != DPI_480 && sourceDPI != DPI_640) ||
                    (targetDPI != DPI_120 && targetDPI != DPI_160 && targetDPI != DPI_240 && targetDPI != DPI_320 && targetDPI != DPI_480 && targetDPI != DPI_640))
            {
                return 1;
            }

            return targetDPI / sourceDPI;
        }

        public static function getDPI(dpi:Number):Number
        {
            if (dpi <= 140)
                return DPI_120;

            if (dpi <= 200)
                return DPI_160;

            if (dpi <= 280)
                return DPI_240;

            if (dpi <= 400)
                return DPI_320;

            if (dpi <= 560)
                return DPI_480;

            return DPI_640;
        }


    }
}
