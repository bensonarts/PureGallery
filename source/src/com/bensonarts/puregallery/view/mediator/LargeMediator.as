package com.bensonarts.puregallery.view.mediator
{
	import com.bensonarts.puregallery.event.StringEvent;
	import com.bensonarts.puregallery.model.vo.ImageVO;
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	import com.bensonarts.puregallery.view.component.LargeView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * LargeMediator. Listends for keyboard events and image asset ready.
	 * 
	 */
	public class LargeMediator extends Mediator implements IMediator
	{
		// Mediator name
		public static const NAME:String = "LargeMediator";
		// Lightbox mode names
		public static const LIGHTBOX_OFF:String = NAME + "LightboxOff";
		public static const LIGHTBOX_ON:String = NAME + "LightboxOn";
		
		private var _state:String = LIGHTBOX_OFF;
		private var _largeView:LargeView;
		// Class constructor
		public function LargeMediator( viewComponent:DisplayObjectContainer )
		{
			super(NAME, viewComponent);
		}
		// Listen for the following notifcation names
		override public function listNotificationInterests():Array
		{
			return [
				ActionList.LARGE_IMAGE_READY,
				ActionList.STAGE_RESIZE,
				ActionList.KEYBOARD_EVENT
			];
		}
		// Handle the notification names
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case ActionList.LARGE_IMAGE_READY :
					var vo:ImageVO = notification.getBody() as ImageVO;
					_largeView.dataProvider = vo;
					_state = LIGHTBOX_ON;
					break;
				case ActionList.STAGE_RESIZE :
					var stageVO:StageVO = notification.getBody() as StageVO;
					_largeView.resize( stageVO );
					break;
				case ActionList.KEYBOARD_EVENT :
					_handleKeyboardEvent( notification.getBody() as uint );
					break;
				default :
					break;
			}
		}
		// Add the LargeView component to the display list.
		// Add event listener.
		override public function onRegister():void
		{
			_largeView = new LargeView();
			_largeView.addEventListener( StringEvent.EVENT, _onCloseLargeImage );
			
			var stageVO:StageVO = new StageVO();
			stageVO.stageWidth = this.viewComponent.stage.stageWidth;
			stageVO.stageHeight = this.viewComponent.stage.stageHeight;
			_largeView.resize( stageVO );
			this.viewComponent.addChild( _largeView );
		}
		// Close button clicked.
		private function _onCloseLargeImage( e:StringEvent ):void
		{
			sendNotification( ActionList.LARGE_IMAGE_CLOSE );
			_state = LIGHTBOX_OFF;
		}
		// Space bar pressed when in lightbox mode
		private function _handleKeyboardEvent( e:uint ):void
		{
			switch ( e )
			{
				case 32 : // spacebar
					if ( _state == LIGHTBOX_ON ) _largeView.close();
					break;
				default :
					break;
			}
		}
		
	}
}