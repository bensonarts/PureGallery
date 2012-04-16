package com.bensonarts.puregallery.view.mediator
{
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	import com.bensonarts.puregallery.view.component.PreloaderView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * PreloaderMediator. Diplays the preloader when loading data or images.
	 * 
	 */
	public class PreloaderMediator extends Mediator implements IMediator
	{
		// Mediator name
		public static const NAME:String = "PreloaderMediator";
		
		private var _preloader:PreloaderView;
		// Class constructor
		public function PreloaderMediator( viewComponent:DisplayObjectContainer )
		{
			super( NAME, viewComponent );
		}
		// Listen for the following notification names
		override public function listNotificationInterests():Array
		{
			return [
				ActionList.GET_IMAGES,
				ActionList.GET_LARGE_IMAGE,
				ActionList.CLEAR,
				ActionList.LARGE_IMAGE_LOAD_PROGRESS,
				ActionList.LARGE_IMAGE_READY,
				ActionList.IMAGES_READY,
				ActionList.STAGE_RESIZE
			];
		}
		// Handle notification names
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case ActionList.GET_IMAGES :
				case ActionList.GET_LARGE_IMAGE :
				case ActionList.CLEAR :
					_preloader.show();
					break;
				case ActionList.LARGE_IMAGE_LOAD_PROGRESS :
					var percentLoaded:Number = notification.getBody() as Number;
					_preloader.update( percentLoaded );
					break;
				case ActionList.IMAGES_READY :
				case ActionList.LARGE_IMAGE_READY :
					_preloader.hide();
					break;
				case ActionList.STAGE_RESIZE :
					var stageVO:StageVO = notification.getBody() as StageVO;
					_preloader.resize( stageVO );
					break;
				default :
					break;
			}
		}
		// Add preloader to the display list
		override public function onRegister():void
		{
			_preloader = new PreloaderView();
			this.viewComponent.addChild( _preloader );
			
			var stageVO:StageVO = new StageVO();
			stageVO.stageWidth = this.viewComponent.stage.stageWidth;
			stageVO.stageHeight = this.viewComponent.stage.stageHeight;
			_preloader.resize( stageVO );
		}
		
	}
}