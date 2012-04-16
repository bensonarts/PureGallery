package com.bensonarts.puregallery.model.proxy
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.bensonarts.puregallery.model.vo.ImageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	/**
	 * 
	 * @author Aaron Benson
	 * GalleryAssetProxy
	 * Loads all thumbnails ands holds them as BitmapData in a data collection ( Array )
	 * 
	 */
	public class GalleryAssetProxy extends Proxy implements IProxy
	{
		// Proxy name
		public static const NAME:String = "GalleryAssetProxy";
		
		private var _imageData:Array;
		private var _bulkLoader:BulkLoader;
		private var _bulkID:int = 0;
		// Class constructor
		public function GalleryAssetProxy()
		{
			super( NAME );
		}
		// Retrieve imageData values
		public function get imageData():Array
		{
			return _imageData;
		}
		/**
		 * Load all thumbnails with BulkLoader. Array must contain an array of ImageVOs
		 * Add event listeners to the BulkLoader instance. Begin Loading. 
		 * @param data
		 * 
		 */		
		public function load( data:Array ):void
		{
			_imageData = data;
			if ( _bulkLoader != null ) _bulkLoader.clear();
			_bulkLoader = new BulkLoader( "bulkLoaderAssets" + _bulkID );
			_bulkID++;
			_bulkLoader.addEventListener( BulkProgressEvent.PROGRESS, _onImagesLoadProgress );
			_bulkLoader.addEventListener( BulkProgressEvent.COMPLETE, _onImagesLoadComplete );
			_bulkLoader.start();
			_loadAssets();
		}
		// Add references ( keys ) to the BulkLoader instance
		private function _loadAssets():void
		{
			var len:int = imageData.length;
			for ( var i:int = 0; i < len; ++i )
			{
				_bulkLoader.add( imageData[i].thumbnail );
			}
		}
		// Images Load progress, send notification to PreloaderMediator
		private function _onImagesLoadProgress( e:BulkProgressEvent ):void
		{
			var percentLoaded:Number = Math.round( ( e.bytesLoaded / e.bytesTotal ) * 100 );
			sendNotification( ActionList.LARGE_IMAGE_LOAD_PROGRESS, percentLoaded );
		}
		// Images Load complete, send notification to PreloaderMediator
		// Remove event listeners
		private function _onImagesLoadComplete( e:BulkProgressEvent ):void
		{
			var len:int = imageData.length;
			var vo:ImageVO;
			for ( var i:int = 0; i < len; ++i )
			{
				imageData[i].thumbnailBitmapData = _bulkLoader.getBitmapData( imageData[i].thumbnail );
			}
			sendNotification( ActionList.IMAGES_READY, imageData );
			_bulkLoader.removeEventListener( BulkProgressEvent.PROGRESS, _onImagesLoadProgress );
			_bulkLoader.removeEventListener( BulkProgressEvent.COMPLETE, _onImagesLoadComplete );
			_bulkLoader.removeAll();
		}
	}
}