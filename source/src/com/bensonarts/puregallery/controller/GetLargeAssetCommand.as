package com.bensonarts.puregallery.controller
{
	import com.bensonarts.puregallery.model.proxy.GalleryLargeAssetProxy;
	import com.bensonarts.puregallery.model.vo.ImageVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	/**
	 * 
	 * @author Aaron Benson
	 * 
	 */
	public class GetLargeAssetCommand extends SimpleCommand implements ICommand
	{
		/**
		 * Load the LargeAsset BitmapData from the notification Image Value Object
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			var vo:ImageVO = notification.getBody() as ImageVO;
			var galleryLargeAssetProxy:GalleryLargeAssetProxy = facade.retrieveProxy( GalleryLargeAssetProxy.NAME ) as GalleryLargeAssetProxy;
			galleryLargeAssetProxy.load( vo );
		}
		
	}
}