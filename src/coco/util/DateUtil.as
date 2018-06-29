package coco.util
{
	
	
	/**
	 * 
	 * Date Helper Component
	 * 
	 * @author Coco
	 * 
	 */	
	public class DateUtil
	{
		public function DateUtil()
		{
		}
		
		/**
		 * day names
		 */		
		public static var dayNames:Vector.<String> = new <String>['日', '一', '二', '三', '四', '五', '六'];
		
		/**
		 * Get days of the month
		 * 
		 * @param year
		 * @param month 0-11
		 * @return 
		 */		
		public static function getMonthDays(year:int, month:int):int
		{
			var n:int;
			
			if (month == 1)
			{
				if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) // leap year
					n = 29;
				else
					n = 28;
			}
				
			else if (month == 3 || month == 5 || month == 8 || month == 10)
				n = 30;
				
			else
				n = 31;
			
			return n;
		}
		
		
		/**
		 * Add Day
		 * 
		 * @param date
		 * @param second
		 * @return 
		 * 
		 */		
		public static function addDay(date:Date, day:int):Date
		{
			return addHour(date, day * 24);
		}
		
		/**
		 * Add Hour
		 * 
		 * @param date
		 * @param second
		 * @return 
		 * 
		 */		
		public static function addHour(date:Date, hour:int):Date
		{
			return addMinute(date, hour * 60);
		}
		
		/**
		 * Add Minute
		 * 
		 * @param date
		 * @param second
		 * @return 
		 * 
		 */		
		public static function addMinute(date:Date, minute:int):Date
		{
			return addSecond(date, minute * 60);
		}
		
		/**
		 * Add Second
		 *  
		 * @param date
		 * @param second
		 * @return 
		 * 
		 */		
		public static function addSecond(date:Date, second:int):Date
		{
			var newDate:Date = new Date();
			newDate.time = date.time + second * 1000;
			return newDate;
		}
		
	}
}