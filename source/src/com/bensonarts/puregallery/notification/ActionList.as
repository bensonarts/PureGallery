package com.bensonarts.puregallery.notification
{
	/**
	 * 
	 * @author Aaron Benson
	 * Action List notification names for application communication
	 * 
	 */	
	public class ActionList
	{
		public static const NAME:String = "ActionList";
		public static const GET_DATA:String = NAME + "GetData";
		public static const DATA_LOAD_PROGRESS:String = NAME + "DataLoadProgress";
		public static const DIMENSIONS_READY:String = NAME + "DimensionsReady";
		public static const DATA_READY:String = NAME + "DataReady";
		public static const GET_IMAGES:String = NAME + "GetImages";
		public static const IMAGES_READY:String = NAME + "ImagesReady";
		public static const CLEAR:String = NAME + "Clear";
		public static const CHANGE_CATEGORY:String = NAME + "ChangeCategory";
		public static const GET_LARGE_IMAGE:String = NAME + "GetLargeImage";
		public static const LARGE_IMAGE_LOAD_PROGRESS:String = NAME + "LargeImageLoadProgress";
		public static const LARGE_IMAGE_READY:String = NAME + "LargeImageReady";
		public static const LARGE_IMAGE_CLOSE:String = NAME + "LargeImageClose";
		public static const STAGE_RESIZE:String = NAME + "StageResize";
		public static const KEYBOARD_EVENT:String = NAME + "KeyboardEvent";
		public static const TOGGLE_FULLSCREEN:String = NAME + "ToggleFullscreen";
		public static const MOUSE_LEAVE:String = NAME + "MouseLeave";
	}
}