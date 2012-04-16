package com.bensonarts.puregallery.view.component
{
	import com.bensonarts.puregallery.event.ThumbnailEvent;
	import com.bensonarts.puregallery.model.vo.DimensionsVO;
	import com.bensonarts.puregallery.model.vo.ImageVO;
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.flashdynamix.motion.Tweensy;
	
	import fl.motion.easing.Back;
	import fl.motion.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	/**
	 * 
	 * @author Aaron Benson
	 * Thumbnail View. Displays thumbnails in a 3D grid.
	 * 
	 */
	public class ThumbnailView extends Sprite
	{
		private const BORDER_SIZE:Number = 10;
		private const THUMB_PADDING:Number = 40;
		
		private var _dataProvider:Array;
		private var _stageVO:StageVO = new StageVO();
		private var _dimensionsVO:DimensionsVO = new DimensionsVO();
		private var _images:Array = new Array();
		private var _container:Sprite;
		private var _currentImage:int = 0;
		// Class constructor
		public function ThumbnailView()
		{
			super();
		}
		// Set the dataProvider to an array of ImageVOs. CreateChildren.
		public function set dataProvider( value:Array ):void
		{
			_dataProvider = value;
			_createChildren();
		}
		// Retrieve dataProvider values.
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		// Set the dimensions to DimensionsVO.
		public function set dimensions( value:DimensionsVO ):void
		{
			_dimensionsVO = value;
		}
		// Retrieve dimensions.
		public function get dimensions():DimensionsVO
		{
			return _dimensionsVO;
		}
		/**
		 * Garbage collection.
		 * Revert this view component to its initial phase to allow loading additional assets. 
		 * 
		 */		
		public function destroy():void
		{
			var len:int = _images.length;
			for ( var i:int = 0; i < len; ++i )
			{
				_images[i].removeEventListener( MouseEvent.CLICK, _onThumbClick );
				_images[i].removeEventListener( MouseEvent.ROLL_OVER, _onThumbRollOver );
				_images[i].removeEventListener( MouseEvent.ROLL_OUT, _onThumbRollOut );
				_container.removeChild( _images[i] );
			}
			_images = new Array();
		}
		/**
		 * Resize upon stage resize. 
		 * @param stageVO
		 * 
		 */		
		public function resize( stageVO:StageVO ):void
		{
			_stageVO.stageWidth = stageVO.stageWidth;
			_stageVO.stageHeight = stageVO.stageHeight;
			
			if ( dataProvider != null )
			{
				_animate();
			}
		}
		/**
		 * Select image. ( Triggered with the spacebar ) 
		 * 
		 */		
		public function select():void
		{
			
		}
		// Add thumbnails to the display list, apply random positioning, animate to grid
		private function _createChildren():void
		{
			_container = new Sprite();
			_container.y = 500;
			this.addChild( _container );
			var len:int = dataProvider.length;
			var img:Sprite;
			var bmp:Bitmap;
			for ( var i:int = 0; i < len; ++i )
			{
				img = new Sprite();
				img.filters = [ new DropShadowFilter( 2, 45, 0x000000, 0.5, 10, 10 ) ];
				img.name = "image_" + i;
				img.graphics.beginFill( 0xffffff );
				var b:Bitmap = new Bitmap( _dataProvider[i].thumbnailBitmapData );
				img.graphics.drawRect( - b.width / 2, - b.height / 2, b.width + BORDER_SIZE, b.height + BORDER_SIZE );
				img.graphics.endFill();
				img.buttonMode = true;
				img.addEventListener( MouseEvent.CLICK, _onThumbClick );
				img.addEventListener( MouseEvent.ROLL_OVER, _onThumbRollOver );
				img.addEventListener( MouseEvent.ROLL_OUT, _onThumbRollOut );
				img.x = Math.random() * _stageVO.stageWidth;
				img.y = _stageVO.stageHeight + 50;
				img.scaleX = 0;
				img.scaleY = 0;
				bmp = new Bitmap( _dataProvider[i].thumbnailBitmapData );
				bmp.smoothing = true;
				bmp.x = ( - b.width / 2 ) + ( BORDER_SIZE / 2 );
				bmp.y = ( - b.height / 2 ) + ( BORDER_SIZE / 2 );
				_container.addChild( img );
				img.addChild( bmp );
				_images.push( img );
			}
			_animate();
			
		}
		// Animate thumbs to grid
		private function _animate():void
		{
			var len:int = dataProvider.length;
			var startX:Number = dimensions.thumbWidth / 2 + 10;
			var startY:Number = ( - dimensions.thumbHeight / 2 ) + ( _stageVO.stageHeight / 2 );
			for ( var i:int = 0; i < len; ++i )
			{
				Tweensy.to( _images[ i ], { x: startX, y: startY, scaleX: 1, scaleY: 1 }, 0.8, Back.easeOut, i * 0.05 );
				if ( startX >= _stageVO.stageWidth - dimensions.thumbWidth - ( dimensions.thumbWidth / 2 ) )
				{
					startX = dimensions.thumbWidth / 2 + 10;
					startY += dimensions.thumbHeight + THUMB_PADDING;
				} else {
					startX += dimensions.thumbWidth + THUMB_PADDING;
				}
			}
			Tweensy.to( _container, { y: 0 }, 1, Back.easeInOut );
		}
		
		private function _onThumbClick( e:MouseEvent ):void
		{
			var img:Sprite = e.currentTarget as Sprite;
			var id:int = int( img.name.substr( img.name.lastIndexOf( "_" ) + 1, img.name.length ) );
			img.scaleX = 0.9;
			img.scaleY = 0.9;
			//Tweensy.to( img, { scaleX: 1, scaleY: 1 }, 0.3, Back.easeOut);
			_currentImage = id;
			_displayChosenPlane( id );
		}
		
		private function _onThumbRollOver( e:MouseEvent ):void
		{
			var img:Sprite = e.currentTarget as Sprite;
			Tweensy.to( _container, { y: - ( img.y - ( _stageVO.stageHeight / 2 ) ) }, 1.5, Sine.easeInOut );
			Tweensy.to( img, { scaleX: 1.2, scaleY: 1.2 }, 0.3, Back.easeOut );
		}
		
		private function _onThumbRollOut( e:MouseEvent ):void
		{
			var img:Sprite = e.currentTarget as Sprite;
			Tweensy.to( img, { scaleX: 1, scaleY: 1 }, 0.3, Back.easeOut );
		}
		// Dispatch a ThumbnailEvent to the ThumbnailMediator with the chosen thumbnail's ImageVO
		private function _displayChosenPlane( id:int ):void
		{
			var vo:ImageVO = new ImageVO();
			vo.large = dataProvider[id].large;
			vo.caption = dataProvider[id].caption;
			this.dispatchEvent( new ThumbnailEvent( ThumbnailEvent.CLICKED, vo ) );
		}
		
	}
}