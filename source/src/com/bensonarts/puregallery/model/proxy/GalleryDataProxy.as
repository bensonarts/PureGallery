package com.bensonarts.puregallery.model.proxy
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.bensonarts.puregallery.model.vo.CategoryVO;
	import com.bensonarts.puregallery.model.vo.DimensionsVO;
	import com.bensonarts.puregallery.model.vo.ImageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	/**
	 * 
	 * @author Aaron Benson
	 * GalleryDataProxy
	 * Load all XML data. Store in a data collection ( Array ). Stored as ImageVOs.
	 */
	public class GalleryDataProxy extends Proxy implements IProxy
	{
		// Name of the Proxy
		public static const NAME:String = "GalleryDataProxy";
		
		private var _categoryVO:CategoryVO;
		private var _dimensionVO:DimensionsVO;
		private var _categoryArr:Array;
		private var _imageArr:Array;
		private var _bulkLoader:BulkLoader;
		private var _url:String;
		// Class constructor
		public function GalleryDataProxy()
		{
			super( NAME );
		}
		// Retrieve category data collection
		public function get categoryData():Array
		{
			return _categoryArr;
		}
		// Retrieve image data colleciton
		public function get imageData():Array
		{
			return _imageArr;
		}
		// Retrieve dimensions ( thumbnail width & thumbnail height )
		public function get dimensionData():DimensionsVO
		{
			return _dimensionVO;
		}
		/**
		 * Load XML feed.
		 * Create new BulkLoader instance. Add event listeners. Start load. 
		 * @param url
		 * 
		 */		
		public function load( url:String=null ):void
		{
			if ( _bulkLoader == null )
			{
				_url = url;
				_bulkLoader = new BulkLoader( "bulkLoaderData" );
				_bulkLoader.addEventListener( BulkProgressEvent.COMPLETE, _onDataLoadComplete );
				_bulkLoader.add( _url, { type: "xml" } );
				_bulkLoader.start();
			}
		}
		// Data load complete event handler. Remove Event listener.
		private function _onDataLoadComplete( e:BulkProgressEvent ):void
		{
			_bulkLoader.removeEventListener( BulkProgressEvent.COMPLETE, _onDataLoadComplete );
			_setDimensionData();
		}
		// Set dimension data collection ( DimensionsVO ) i.e. Thumbnail width & height
		private function _setDimensionData():void
		{
			var xml:XML = new XML( _bulkLoader.getXML( _url ) );
			_dimensionVO = new DimensionsVO();
			// TODO 
			_dimensionVO.thumbWidth = 100;
			_dimensionVO.thumbHeight = 100;
			_setCategoryData( xml );
			sendNotification( ActionList.DIMENSIONS_READY, dimensionData );
		}
		// Set category data collection ( CategoryVO ) i.e. Category names
		private function _setCategoryData( data:XML ):void
		{
			_categoryArr = new Array();
			_imageArr = new Array();
			var vo:CategoryVO;
			var len:int = data..album.length();
			for ( var i:int = 0; i < len; ++i )
			{
				vo = new CategoryVO();
				vo.id = i;
				vo.title = String( data..album[i].title );
				_setImageData( i, data..album[i].images );
				_categoryArr.push( vo );
			}
			sendNotification( ActionList.DATA_READY, _categoryArr );
		}
		// Set image data per category as multi-dimensional arrays ( ImageVO )
		private function _setImageData( id:int, data:XMLList ):void
		{
			var tempArr:Array = new Array();
			var vo:ImageVO;
			var len:int = data.image.length();
			for ( var i:int = 0; i < len; ++i )
			{
				vo = new ImageVO();
				vo.categoryID = id;
				vo.thumbnail = String( data.image[i].thumb );
				vo.large = String( data.image[i].url );
				vo.caption = String( data.image[i].caption );
				tempArr.push( vo );
			}
			_imageArr.push( tempArr );
		}
		
	}
}