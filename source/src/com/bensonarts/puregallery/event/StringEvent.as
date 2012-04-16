package com.bensonarts.puregallery.event
{
	import flash.events.Event;
	/**
	 * 
	 * @author Aaron Benson
	 * Custom Event Class
	 * Add a string var as a supplement
	 */
	public class StringEvent extends Event
	{
		// Event name
		public static const EVENT:String = "StringEvent";
		
		private var _string:String;
		/**
		 * 
		 * @param type
		 * @param string Optional
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function StringEvent(type:String, string:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_string = string;
		}
		// Retrieve string value
		public function get string():String
		{
			return _string;
		}
		// Override the clone method - best practice
		override public function clone():Event
		{
			return new StringEvent( type, string, bubbles, cancelable );
		}
		
	}
}