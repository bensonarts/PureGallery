package com.bensonarts.puregallery.model.vo
{
	import flash.display.BitmapData;
	/**
	 * 
	 * @author Aaron Benson
	 * Image Value Object
	 * 
	 */	
	public class ImageVO
	{
		public var categoryID:int;
		public var large:String;
		public var thumbnail:String;
		public var caption:String;
		public var largeBitmapData:BitmapData;
		public var thumbnailBitmapData:BitmapData;
	}
}