package com.bensonarts.puregallery.view.mediator
{
	import com.bensonarts.puregallery.event.StringEvent;
	import com.bensonarts.puregallery.event.ThumbnailEvent;
	import com.bensonarts.puregallery.model.vo.DimensionsVO;
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	import com.bensonarts.puregallery.view.component.ThumbnailView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * ThumbnailMediator. Responsible for listening to thumbnail events, Setting its data provider, resizing upon stage resize.
	 * Also displays the Keyboard icon momentarily.
	 * 
	 */
	public class ThumbnailMediator extends Mediator implements IMediator
	{
		// Mediator name
		public static const NAME:String = "ThumbnailMediator";
		// Lightbox mode names
		public static const LIGHTBOX_ON:String = NAME + "LightBoxOn";
		public static const LIGHTBOX_OFF:String = NAME + "LightBoxOff";
		
		private var _thumbnailView:ThumbnailView;
		private var _state:String;
		// Class constructor
		public function ThumbnailMediator( viewComponent:DisplayObjectContainer )
		{
			super(NAME, viewComponent);
		}
		// Listen for the following notification names
		override public function listNotificationInterests():Array
		{
			return [
				ActionList.DIMENSIONS_READY,
				ActionList.IMAGES_READY,
				ActionList.CLEAR,
				ActionList.GET_LARGE_IMAGE,
				ActionList.LARGE_IMAGE_CLOSE,
				ActionList.STAGE_RESIZE
			];
		}
		// Handle notification names
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case ActionList.DIMENSIONS_READY :
					_thumbnailView.dimensions = notification.getBody() as DimensionsVO;
					break;
				case ActionList.IMAGES_READY :
					_thumbnailView.dataProvider = notification.getBody() as Array;
					_state = LIGHTBOX_OFF;
					break;
				case ActionList.CLEAR :
					_thumbnailView.destroy();
					break;
				case ActionList.GET_LARGE_IMAGE :
					_state = LIGHTBOX_ON;
					break;
				case ActionList.LARGE_IMAGE_CLOSE :
					_state = LIGHTBOX_OFF;
					break;
				case ActionList.STAGE_RESIZE :
					var stageVO:StageVO = notification.getBody() as StageVO;
					_thumbnailView.resize( stageVO );
					break;
				default :
					break;
			}
		}
		// Add thubnail view component to the display list.
		override public function onRegister():void
		{
			_thumbnailView = new ThumbnailView();
			_thumbnailView.addEventListener( ThumbnailEvent.CLICKED, _onThumbnailClicked );
			viewComponent.addChild( _thumbnailView );
			
			var stageVO:StageVO = new StageVO();
			stageVO.stageWidth = this.viewComponent.stage.stageWidth;
			stageVO.stageHeight = this.viewComponent.stage.stageHeight;
			_thumbnailView.resize( stageVO );
		}
		// Thumbnail click, send selected image value object to the command
		private function _onThumbnailClicked( e:ThumbnailEvent ):void
		{
			sendNotification( ActionList.GET_LARGE_IMAGE, e.imageVO );
		}
		
	}
}