package coco.util
{
    import coco.core.coco;
	
	
    /**
     * 输出调试信息，当CocoConfig.debugEnabled=true时才会输出调试信息
     */    
	public function debug(...parameters):void
	{
		if (CocoUI.useDebug)
		{
			var arg:Array = parameters as Array;
			if (arg.length > 0)
				arg[0] = "[cocoui" + CocoUI.coco::VERSION + "][Debug] " + arg[0];
			trace(arg);
		}
	}
}

