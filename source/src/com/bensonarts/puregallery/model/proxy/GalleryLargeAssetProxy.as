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
	 * GalleryLargeAssetProxy
	 * Load the BitmapData from the large image. Hold reference and send via a notification.
	 * 
	 */
	public class GalleryLargeAssetProxy extends Proxy implements IProxy
	{
		// Name of the proxy
		public static const NAME:String = "GalleryLargeAssetProxy";
		
		private var _bulkLoader:BulkLoader;
		private var _imageData:ImageVO;
		private var _bulkID:int = 0;
		// Class constructor
		public function GalleryLargeAssetProxy()
		{
			super( NAME );
		}
		// Retrieve imageData ( image VO )
		public function get imageData():ImageVO
		{
			return _imageData;
		}
		/**
		 * Load large image 
		 * Create new BulkLoader instance, add event listeners, start load.
		 * @param vo ImageVO 
		 * 
		 */		
		public function load( vo:ImageVO ):void
		{
			_imageData = vo;
			if ( _bulkLoader != null ) _bulkLoader.clear();
			_bulkLoader = new BulkLoader( "bulkLargeLoader" + _bulkID );
			_bulkID++;
			_bulkLoader.addEventListener( BulkProgressEvent.PROGRESS, _onLoadProgress );
			_bulkLoader.addEventListener( BulkProgressEvent.COMPLETE, _onLoadComplete );
			_bulkLoader.start();
			_bulkLoader.add( vo.large );
		}
		// On large image load progress
		private function _onLoadProgress( e:BulkProgressEvent ):void
		{
			var percentLoaded:Number = Math.round( ( e.bytesLoaded / e.bytesTotal ) * 100 );
			sendNotification( ActionList.LARGE_IMAGE_LOAD_PROGRESS, percentLoaded );
		}
		// Image load complete. Send notification with bitmapData to the LargeMediator. Do garbage collection.
		private function _onLoadComplete( e:BulkProgressEvent ):void
		{
			imageData.largeBitmapData = _bulkLoader.getBitmapData( imageData.large );
			sendNotification( ActionList.LARGE_IMAGE_READY, imageData );
			_bulkLoader.removeEventListener( BulkProgressEvent.PROGRESS, _onLoadProgress );
			_bulkLoader.removeEventListener( BulkProgressEvent.COMPLETE, _onLoadComplete );
		}
		
	}
}