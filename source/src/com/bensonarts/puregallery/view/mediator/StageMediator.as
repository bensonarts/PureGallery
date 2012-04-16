package com.bensonarts.puregallery.view.mediator
{
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * StageMediator. Listends for keyboard events, stage resize and mouse leave.
	 * 
	 */
	public class StageMediator extends Mediator implements IMediator
	{
		// Mediator name
		public static const NAME:String = "StageMediator";
		// Stage value object
		private var _stageVO:StageVO = new StageVO();
		// Class constructor
		public function StageMediator( viewComponent:DisplayObjectContainer )
		{
			super( NAME, viewComponent );
		}
		// Listen for the following notification names
		override public function listNotificationInterests():Array
		{
			return [
				ActionList.TOGGLE_FULLSCREEN
			];
		}
		// Handle the notification names
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case ActionList.TOGGLE_FULLSCREEN :
					_toggleFullscreen();
					break;
				default :
					break;
			}
		}
		// Add event listeners to the stage
		override public function onRegister():void
		{
			this.viewComponent.stage.addEventListener( Event.RESIZE, _onStageResize );
			this.viewComponent.stage.addEventListener( KeyboardEvent.KEY_DOWN, _onKeyDown );
			this.viewComponent.stage.addEventListener( Event.MOUSE_LEAVE, _onMouseLeave );
		}
		// Upon stage resize, send notification with the stage value object. All mediators will pick up on this.
		private function _onStageResize( e:Event ):void
		{
			var stageWidth:Number = this.viewComponent.stage.stageWidth;
			var stageHeight:Number = this.viewComponent.stage.stageHeight;
			_stageVO.stageWidth = stageWidth;
			_stageVO.stageHeight = stageHeight;
			sendNotification( ActionList.STAGE_RESIZE, _stageVO );
		}
		// Keyboard button pressed. Send notification. See ThumbnailMediator & LargeMediator.
		private function _onKeyDown( e:KeyboardEvent ):void
		{
			sendNotification( ActionList.KEYBOARD_EVENT, e.keyCode );
		}
		// Mouse left the stage. 
		private function _onMouseLeave( e:Event ):void
		{
			sendNotification( ActionList.MOUSE_LEAVE );
		}
		// Toggle fullscreen mode.
		private function _toggleFullscreen():void
		{
			switch( this.viewComponent.stage.displayState )
			{
				case StageDisplayState.NORMAL :
					this.viewComponent.stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				case StageDisplayState.FULL_SCREEN :
					this.viewComponent.stage.displayState = StageDisplayState.NORMAL;
					break;
				default :
					this.viewComponent.stage.displayState = StageDisplayState.NORMAL;
					break;
			}
		}
	}
}