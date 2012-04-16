package com.bensonarts.puregallery.controller
{
	import com.bensonarts.puregallery.model.proxy.GalleryAssetProxy;
	import com.bensonarts.puregallery.model.proxy.GalleryDataProxy;
	import com.bensonarts.puregallery.model.proxy.GalleryLargeAssetProxy;
	import com.bensonarts.puregallery.service.ServiceCalls;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 
	 * @author Aaron Benson
	 * 
	 */
	public class StartupCommand extends SimpleCommand implements ICommand
	{
		/**
		 * Register all proxies, GalleryDataProxy, GalleryAssetProxy, GalleryLargeAssetProxy
		 * Load XML from the dataPath defined in ServiceCalls 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			// Register proxies
			facade.registerProxy( new GalleryDataProxy() );
			facade.registerProxy( new GalleryAssetProxy() );
			facade.registerProxy( new GalleryLargeAssetProxy() );
			
			var galleryDataProxy:GalleryDataProxy = facade.retrieveProxy( GalleryDataProxy.NAME ) as GalleryDataProxy;
			galleryDataProxy.load( ServiceCalls.getDataPath() );
		}
		
	}
}