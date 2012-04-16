package com.bensonarts.puregallery.view.component
{
	import com.bensonarts.puregallery.event.StringEvent;
	import com.bensonarts.puregallery.model.vo.ImageVO;
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.flashdynamix.motion.Tweensy;
	
	import fl.motion.easing.Circular;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	/**
	 * 
	 * @author Aaron Benson
	 * Large image view class. Contains the large image, close button, background and caption.
	 * 
	 */
	public class LargeView extends Sprite
	{
		// Padding around the image and the white background
		private const SKIN_PADDING:Number = 10;
		// Limit of distance between the image and the stage boundaries
		private const MAX_SIZE_REDUCTION:Number = 100;
		private var _dataProvider:ImageVO;
		private var _skin:LargeImageSkin = new LargeImageSkin();
		private var _background:Sprite = new Sprite();
		private var _stageVO:StageVO = new StageVO();
		private var _container:Sprite = new Sprite();
		private var _captionSkin:CaptionSkin = new CaptionSkin();
		private var _captionMask:Sprite = new Sprite();
		private var _image:Bitmap;
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		// Class constructor
		public function LargeView()
		{
			this.visible = false;
			_createStatics();
			_addEventListeners();
		}
		/**
		 * Reset to initial phase for loading the next image. 
		 * 
		 */		
		public function reset():void
		{
			if ( _image != null ) this._container.removeChild( _image );
			_skin.scaleX = 1;
			_skin.scaleY = 1;
			this.visible = true;
			_skin.alpha = 0;
			_container.alpha = 0;
			_captionSkin.alpha = 0;
		}
		/**
		 * Resize upon stage resize 
		 * @param stageVO
		 * 
		 */		
		public function resize( stageVO:StageVO ):void
		{
			_stageVO.stageWidth = stageVO.stageWidth;
			_stageVO.stageHeight = stageVO.stageHeight;
			_container.x = _stageVO.stageWidth / 2;
			_container.y = _stageVO.stageHeight / 2;
			_skin.x = _container.x;
			_skin.y = _container.y;
			_background.width = _stageVO.stageWidth;
			_background.height = _stageVO.stageHeight;
			_moveCaption();
		}
		// Retrieve data provider value ( ImageVO )
		public function get dataProvider():ImageVO
		{
			return _dataProvider;
		}
		// Set the data provider
		public function set dataProvider( value:ImageVO ):void
		{
			reset();
			_dataProvider = value;
			_createChildren();
		}
		/**
		 * Disable this view component 
		 * 
		 */		
		public function close():void
		{
			_hide();
		}
		// Add attributes and add to the display list for persistent objects
		private function _createStatics():void
		{
			_background.alpha = 0;
			_background.graphics.beginFill( 0, 0.5 );
			_background.graphics.drawRect( 0, 0, _stageVO.stageWidth, _stageVO.stageHeight );
			_background.graphics.endFill();
			_captionMask.graphics.beginFill( 0 );
			_captionMask.graphics.drawRect( 0, 0, 100, 100 );
			_captionMask.graphics.endFill();
			_captionSkin.info.autoSize = TextFieldAutoSize.LEFT;
			_captionSkin.info.multiline = true;
			_captionSkin.info.wordWrap = true;
			_captionSkin.mouseEnabled = false;
			_captionSkin.info.mouseEnabled = false;
			_captionSkin.background.mouseEnabled = false;
			this.addChild( _background );
			this.addChild( _skin );
			this.addChild( _container );
			this.addChild( _captionSkin );
			_container.addChild( _captionMask );
			_captionSkin.mask = _captionMask;
			this._skin.alpha = 0;
		}
		// Add items to the display list
		private function _createChildren():void
		{
			_image = new Bitmap( dataProvider.largeBitmapData );
			_image.smoothing = true;
			_getImageSize();
			_container.addChild( _image );
			_moveCaption();
			_captionSkin.info.htmlText = dataProvider.caption;
			_captionSkin.background.height = _captionSkin.info.height + 20;
			_animateSkin();
			_animateBitmap();
		}
		// Compare the loaded image size to the stage size, fit accordingly
		private function _getImageSize():void
		{
			if ( _image != null )
			{
				_imageWidth = _image.width;
				_imageHeight = _image.height;
				if ( _image.width >= _stageVO.stageWidth )
				{
					_imageWidth = _stageVO.stageWidth - MAX_SIZE_REDUCTION;
				}
				if ( _image.height >= _stageVO.stageHeight )
				{
					_imageHeight = _stageVO.stageHeight - MAX_SIZE_REDUCTION;
				}
				if ( _imageWidth >= _imageHeight )
				{
					_imageWidth = _image.width * _imageHeight / _image.height;
				} else {
					_imageHeight = _image.height * _imageWidth / _image.width;
				}
				_image.width = _imageWidth;
				_image.height = _imageHeight;
			}
		}
		// Animate large image assets
		private function _animateSkin():void
		{
			_skin.background.width = _imageWidth / 2;
			_skin.background.height = _imageHeight / 2;
			Tweensy.to( _background, { alpha: 1 }, 0.5 );
			Tweensy.to( _skin, { alpha: 1 }, 0.5, Circular.easeInOut, 0.5 );
			Tweensy.to( _skin.background, { 
											width: _imageWidth + ( SKIN_PADDING * 2 ), 
											height: _imageHeight + ( SKIN_PADDING * 2 )
											}, 
											0.5, 
											Circular.easeInOut, 
											0.5 );
			Tweensy.to( _skin.close, { x: _imageWidth / 2 + 10, y: - ( _imageHeight / 2 ) - 10 }, 0.5, Circular.easeInOut, 0.7 );
		}
		// Animate the bitmap
		private function _animateBitmap():void
		{
			_image.x = - _imageWidth / 2;
			_image.y = - _imageHeight / 2;
			_container.scaleX = 0.5;
			_container.scaleY = 0.5;
			Tweensy.to( _container, { scaleX: 1, scaleY: 1, alpha: 1 }, 1, Circular.easeInOut, 1 );
		}
		// Position caption according to its new inherited height, restricted to the large image size
		private function _moveCaption():void
		{
			_captionMask.x = - _imageWidth / 2;
			_captionMask.y = - _imageHeight / 2;
			_captionMask.width = _imageWidth;
			_captionMask.height = _imageHeight
			_captionSkin.x = _stageVO.stageWidth / 2;
			_captionSkin.y = ( _stageVO.stageHeight / 2 ) + ( _imageHeight / 2 );
			_captionSkin.background.width = _imageWidth;
			_captionSkin.info.width = _captionSkin.background.width - 10;
			_captionSkin.info.x = - _imageWidth / 2 + SKIN_PADDING;
		}
		// Add event listeners
		private function _addEventListeners():void
		{
			_skin.close.buttonMode = true;
			_skin.close.mouseChildren = false;
			_background.addEventListener( MouseEvent.CLICK, _onClose );
			_skin.close.addEventListener( MouseEvent.CLICK, _onClose );
			_container.addEventListener( MouseEvent.ROLL_OVER, _showCaption );
			_container.addEventListener( MouseEvent.ROLL_OUT, _hideCaption );
			_container.addEventListener( MouseEvent.CLICK, _onClose );
		}
		// Close button click handler
		private function _onClose( e:MouseEvent ):void
		{
			_hide();
		}
		// Show caption
		private function _showCaption( e:MouseEvent ):void
		{
			if ( dataProvider.caption.length > 0 )
			{
				Tweensy.to( _captionSkin, { y: ( _stageVO.stageHeight / 2 ) + ( _imageHeight / 2 ) - _captionSkin.height, alpha: 1 }, 0.5, Circular.easeInOut );
			}
		}
		// Hide caption
		private function _hideCaption( e:MouseEvent ):void
		{
			if ( dataProvider.caption.length > 0 )
			{
				Tweensy.to( _captionSkin, { y: ( _stageVO.stageHeight / 2 ) + ( _imageHeight / 2 ), alpha: 0 }, 0.5, Circular.easeInOut );
			}
		}
		// Hide this view component, dispatch event to the mediator
		private function _hide():void
		{
			Tweensy.to( _captionSkin, { alpha: 0 }, 0.2 );
			Tweensy.to( _skin, { scaleX: 0.6, scaleY: 0.6, alpha: 0 }, 0.6, Circular.easeInOut );
			Tweensy.to( _container, { scaleX: 0.6, scaleY: 0.6, alpha: 0 }, 0.6, Circular.easeInOut, 0, null, _invisibility );
			Tweensy.to( _background, { alpha: 0 }, 0.6 );
			this.dispatchEvent( new StringEvent( StringEvent.EVENT ) );
		}
		// Set this visible to false
		private function _invisibility():void
		{
			this.visible = false;
		}
		
	}
}