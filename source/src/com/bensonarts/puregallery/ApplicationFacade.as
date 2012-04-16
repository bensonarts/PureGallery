package com.bensonarts.puregallery
{
	import com.bensonarts.puregallery.controller.GetCategoryAssetCommand;
	import com.bensonarts.puregallery.controller.GetInitAssetCommand;
	import com.bensonarts.puregallery.controller.GetLargeAssetCommand;
	import com.bensonarts.puregallery.controller.StartupCommand;
	import com.bensonarts.puregallery.notification.ActionList;
	import com.bensonarts.puregallery.view.mediator.ApplicationMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	/**
	 * 
	 * @author Aaron Benson
	 * PureMVC Application Facade.
	 * Register controllers. Register Application Mediator. Launch the startup Command.
	 */
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const NAME:String = "ApplicationFacade";
		public static const STARTUP:String = NAME + "StartUp";
		
		public function ApplicationFacade( key:String )
		{
			super( key );
		}
		
		/**
		 * Retrun Application Facade singleton
		 * @return Application Facade
		 * 
		 */		
		public static function getInstance( key:String ):ApplicationFacade
		{
			if ( instanceMap[ key ] == null )
			{
				instanceMap[ key ] = new ApplicationFacade( key );
			}
			return instanceMap[ key ] as ApplicationFacade;
		}
		// Register Commands to Notification Names
		override protected function initializeController():void
		{
			super.initializeController();
			// Register Commands
			registerCommand( ApplicationFacade.STARTUP, StartupCommand );
			registerCommand( ActionList.GET_IMAGES, GetInitAssetCommand );
			registerCommand( ActionList.CHANGE_CATEGORY, GetCategoryAssetCommand );
			registerCommand( ActionList.GET_LARGE_IMAGE, GetLargeAssetCommand );
		}
		/**
		 * Override registerMediator ( for debugging )
		 * @param mediator IMediator interface
		 * 
		 */		
		override public function registerMediator(mediator:IMediator):void
		{
			// register mediators
			//trace( "Register Mediator :: " + mediator.getMediatorName() );
			super.registerMediator( mediator );
		}
		/**
		 * Send STARTUP notification, starts appliation
		 * Register the Application Mediator
		 * @param disp DisplayObjectContainer from the main document class
		 * 
		 */		
		public function startup( disp:DisplayObjectContainer ):void
		{
			sendNotification( STARTUP, disp );
			registerMediator( new ApplicationMediator( disp ) );
		}
		/**
		 * Override the sendNotification method ( for debugging ) 
		 * @param notificationName
		 * @param body
		 * @param type
		 * 
		 */		
		override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void
		{
			//trace( "Send Notification :: " + notificationName );
			super.sendNotification( notificationName, body, type );
		}
		
	}
}