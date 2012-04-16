package com.bensonarts.puregallery.service
{
	/**
	 * 
	 * @author Aaron Benson
	 * Attempt to find dataPath in the LoaderInfo ( flashVars in the JavaScript embed code )
	 * If none is found, defaut to _localFile
	 * 
	 */	
	public class ServiceCalls
	{
		private static var _localFile:String = "http://gcms2.gallerycms.com/api/myfeed/xml/9c09b806-84cf-11e1-8def-00e0814b024a";
		private static var _location:String;
		private static var _server:String;
		private static var _isLocal:Boolean = false;
		// Enable local XML file
		public static function turnOnLocal( location:String="" ):void
		{
			if ( location.length > 0 )
			{
				_location = location;
			} else {
				_location = _localFile;
			}
			_isLocal = true;
			return;
		}
		// Use GalleryCMS data path i.e. ( http://www.server.com/gallerycms/index.php/view/xml )
		public static function turnOnRemote( server:String ):void
		{
			if ( server.length > 0 )
			{
				_server = server;
				_isLocal = false;
				return;
			}
		}
		// Return the dataPath ( used by the GalleryDataProxy )
		public static function getDataPath():String
		{
			var returnStr:String;
			if ( _isLocal )
			{
				returnStr = _location;
			} else {
				returnStr = _server;
			}
			return returnStr;
		}
	}
}