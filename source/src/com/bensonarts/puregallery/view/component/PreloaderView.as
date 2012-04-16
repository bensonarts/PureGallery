package com.bensonarts.puregallery.view.component
{
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.flashdynamix.motion.Tweensy;
	
	import flash.display.Sprite;
	/**
	 * 
	 * @author Aaron Benson
	 * Preloader view component. Displays when loading XML and image assets.
	 * 
	 */
	public class PreloaderView extends Sprite
	{
		private const LOAD_INIT_MESSAGE:String = "Loading...";
		private const LOAD_PROGRESS_MESSAGE:String = "Loading ";
		private const LOAD_COMPLETE_MESSAGE:String = "Load Complete";
		
		private var _preloader:PreloaderSkin;
		private var _stageVO:StageVO = new StageVO();
		// Class constructor
		public function PreloaderView()
		{
			_createChildren();
			_invisible();
		}
		/**
		 * Show preloader 
		 * 
		 */		
		public function show():void
		{
			this.visible = true;
			this.alpha = 0;
			Tweensy.to( this, { alpha: 1 }, 1 );
			_preloader.status.text = LOAD_INIT_MESSAGE;
		}
		/**
		 * Update the text field with the percentage loaded
		 * @param percentLoaded
		 * 
		 */		
		public function update( percentLoaded:Number ):void
		{
			if ( percentLoaded > 0 && percentLoaded < 100 && percentLoaded.toString().length > 3 )
			{
				_preloader.status.text = LOAD_PROGRESS_MESSAGE + percentLoaded.toString() + "%";
			} else {
				_preloader.status.text = LOAD_PROGRESS_MESSAGE;
			}
		}
		/**
		 * Hide prelaoder 
		 * 
		 */		
		public function hide():void
		{
			_preloader.status.text = LOAD_COMPLETE_MESSAGE;
			Tweensy.to( this, { alpha: 0 }, 1, null, 0.5, null, _invisible );
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
			this.x = _stageVO.stageWidth / 2;
			this.y = _stageVO.stageHeight / 2;
		}
		// Set the visible to false 
		private function _invisible():void
		{
			this.visible = false;
		}
		// Add items to the display list
		private function _createChildren():void
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			_preloader = new PreloaderSkin();
			this.addChild( _preloader );
		}
		
	}
}