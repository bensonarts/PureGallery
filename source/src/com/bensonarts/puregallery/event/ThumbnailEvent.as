package com.bensonarts.puregallery.event
{
	import com.bensonarts.puregallery.model.vo.ImageVO;
	
	import flash.events.Event;
	/**
	 * 
	 * @author aaronbenson
	 * Custom Event class
	 * Thumbnail Value Object is added to the even constructor. Used for passing the VO to the ThumbnailMediator
	 */
	public class ThumbnailEvent extends Event
	{
		// Event name
		public static const CLICKED:String = "ThumbnailClicked";
		
		private var _imageVO:ImageVO;
		/**
		 * 
		 * @param type
		 * @param imageVO Must provide the image value object ( ImageVO )
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function ThumbnailEvent(type:String, imageVO:ImageVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_imageVO = imageVO;
		}
		// Retrieve the imageVO value
		public function get imageVO():ImageVO
		{
			return _imageVO;
		}
		// Override the clone method - best practice
		override public function clone():Event
		{
			return new ThumbnailEvent( type, imageVO, bubbles, cancelable );
		}
	}
}