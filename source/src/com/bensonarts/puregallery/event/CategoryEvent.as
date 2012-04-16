package com.bensonarts.puregallery.event
{
	import flash.events.Event;
	/**
	 * 
	 * @author Aaron Benson
	 * Custom Event Class
	 * Can add id as a supplement to Event vars
	 */
	public class CategoryEvent extends Event
	{
		// Event Name
		public static const CHANGE:String = "CategoryChange";
		
		private var _id:int;
		/**
		 * 
		 * @param type
		 * @param id For dispatching events to the CategoryMediator.
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function CategoryEvent(type:String, id:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_id = id;
		}
		// Retrieve id value
		public function get id():int
		{
			return _id;
		}
		// Override the clone method ( best practice )
		override public function clone():Event
		{
			return new CategoryEvent( type, id, bubbles, cancelable );
		}
		
	}
}