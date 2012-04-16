package com.bensonarts.puregallery.controller
{
	import com.bensonarts.puregallery.model.proxy.GalleryAssetProxy;
	import com.bensonarts.puregallery.model.proxy.GalleryDataProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 
	 * @author Aaron Benson
	 * 
	 */
	public class GetInitAssetCommand extends SimpleCommand implements ICommand
	{
		/**
		 * When data is loaded initially, load the bitmap data from the first Category
		 * Retrieve data collection from the GalleryDataProxy, send to the GalleryAssetProxy 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			var galleryDataProxy:GalleryDataProxy = facade.retrieveProxy( GalleryDataProxy.NAME ) as GalleryDataProxy;
			var galleryAssetProxy:GalleryAssetProxy = facade.retrieveProxy( GalleryAssetProxy.NAME ) as GalleryAssetProxy;
			// Loads the images from the 1st category
			galleryAssetProxy.load( galleryDataProxy.imageData[0] );
		}
		
	}
}