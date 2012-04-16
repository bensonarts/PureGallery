package com.bensonarts.puregallery.view.mediator
{
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * ApplicationMediator registers sub mediators
	 * 
	 */
	public class ApplicationMediator extends Mediator implements IMediator
	{
		// Mediator Name
		public static const NAME:String = "ApplicationMediator";
		// Class constructor
		public function ApplicationMediator( viewComponent:DisplayObjectContainer )
		{
			super( NAME, viewComponent );
		}
		// Notification interests ( none )
		override public function listNotificationInterests():Array
		{
			return [
				//
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				default :
					break;
			}
		}
		// Register sub-mediators
		override public function onRegister():void
		{
			facade.registerMediator( new StageMediator( typedView ) );
			facade.registerMediator( new ThumbnailMediator( typedView ) );
			facade.registerMediator( new CategoryMediator( typedView ) );
			facade.registerMediator( new LargeMediator( typedView ) );
			facade.registerMediator( new PreloaderMediator( typedView ) );
		}
		// Get the reference to this display object
		protected function get typedView():PureGallery
		{
			return this.viewComponent as PureGallery;
		}
	}
}