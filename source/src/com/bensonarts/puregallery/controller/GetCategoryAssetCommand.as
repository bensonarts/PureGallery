package com.bensonarts.puregallery.controller
{
	import com.bensonarts.puregallery.model.proxy.GalleryAssetProxy;
	import com.bensonarts.puregallery.model.proxy.GalleryDataProxy;
	import com.bensonarts.puregallery.notification.ActionList;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 
	 * @author Aaron Benson
	 * 
	 */
	public class GetCategoryAssetCommand extends SimpleCommand implements ICommand
	{
		/**
		 * Retrieve the data collection from the GalleryDataProxy
		 * Send data to the GalleryAssetProxy to load the bitmap data
		 * Load the Category by [ id ] // from the CategoryMediator
		 * @param notification INotification interface
		 * 
		 */
		override public function execute(notification:INotification):void
		{
			var id:int = notification.getBody() as int;
			
			var galleryDataProxy:GalleryDataProxy = facade.retrieveProxy( GalleryDataProxy.NAME ) as GalleryDataProxy;
			var galleryAssetProxy:GalleryAssetProxy = facade.retrieveProxy( GalleryAssetProxy.NAME ) as GalleryAssetProxy;
			
			sendNotification( ActionList.CLEAR );
			
			galleryAssetProxy.load( galleryDataProxy.imageData[ id ] );
		}
		
	}
}