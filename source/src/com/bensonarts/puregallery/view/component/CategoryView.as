package com.bensonarts.puregallery.view.component
{
	import com.bensonarts.puregallery.event.CategoryEvent;
	import com.bensonarts.puregallery.event.StringEvent;
	import com.bensonarts.puregallery.model.vo.CategoryVO;
	import com.bensonarts.puregallery.model.vo.StageVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 
	 * @author Aaron Benson
	 * This class displays the categories, fullscreen button and navigation bar
	 * 
	 */
	public class CategoryView extends Sprite
	{
		private var _dataProvider:Array = new Array();
		private var _background:CategorySkin;
		private var _button:CategoryButton;
		private var _fullscreenButton:FullscreenButton = new FullscreenButton();
		private var _stageVO:StageVO = new StageVO();
		// Class constructor
		public function CategoryView()
		{
			_background = new CategorySkin();
		}
		// Retrieve dataProvider value ( Array of CategoryVOs )
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		// Set the dataProvider ( set by CategoryMediator )
		public function set dataProvider( value:Array ):void
		{
			_dataProvider = value;
			if ( _dataProvider != null ) _createChildren();
		}
		// Resize on stage resize
		public function resize( stageVO:StageVO ):void
		{
			_stageVO.stageWidth = stageVO.stageWidth;
			_stageVO.stageHeight = stageVO.stageHeight;
			_background.width = _stageVO.stageWidth;
			_fullscreenButton.x = _stageVO.stageWidth;
			this.y = _stageVO.stageHeight - this._background.height;
		}
		// Add items to this view component
		private function _createChildren():void
		{
			this.addChild( _background );
			_fullscreenButton.x = _stageVO.stageWidth;
			_fullscreenButton.buttonMode = true;
			_fullscreenButton.addEventListener( MouseEvent.CLICK, _onFullScreenButtonClick );
			this.addChild( _fullscreenButton );
			var len:int = dataProvider.length;
			var vo:CategoryVO;
			var startX:Number = 0;
			for ( var i:int = 0; i < len; ++i )
			{
				vo = new CategoryVO();
				vo.id = dataProvider[i].id;
				vo.title = dataProvider[i].title;
				vo.description = dataProvider[i].description;
				_button = new CategoryButton();
				_button.background.gotoAndStop( 1 );
				_button.addEventListener( MouseEvent.ROLL_OVER, _onRollOver );
				_button.addEventListener( MouseEvent.ROLL_OUT, _onRollOut );
				_button.addEventListener( MouseEvent.CLICK, _onClick );
				_button.mouseChildren = false;
				_button.mouseEnabled = true;
				_button.buttonMode = true;
				_button.label.autoSize = "left";
				_button.label.htmlText = vo.title;
				_button.name = "button" + vo.id;
				_button.background.width = _button.label.width + 40;
				_button.x = startX;
				startX += _button.label.width + 40;
				this.addChild( _button );
			}
		}
		// Category button roll over
		private function _onRollOver( e:MouseEvent ):void
		{
			var clip:CategoryButton = e.currentTarget as CategoryButton;
			clip.background.gotoAndPlay( "start" );
		}
		// Category button roll out
		private function _onRollOut( e:MouseEvent ):void
		{
			var clip:CategoryButton = e.currentTarget as CategoryButton;
			clip.background.gotoAndPlay( "end" );
		}
		// Category button click, dispatch a CategoryEvent of the category id to the CategoryMediator
		private function _onClick( e:MouseEvent ):void
		{
			var clip:CategoryButton = e.currentTarget as CategoryButton;
			var clipName:String = clip.name;
			var id:int = int( clipName.substr( clipName.length - 1, 1 ) );
			this.dispatchEvent( new CategoryEvent( CategoryEvent.CHANGE, id ) );
		}
		// Fullscreen button click // Toggle fullscreen
		private function _onFullScreenButtonClick( e:MouseEvent ):void
		{
			this.dispatchEvent( new StringEvent( StringEvent.EVENT, "fullscreen" ) );
		}
	}
}