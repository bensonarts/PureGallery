package com.bensonarts.puregallery.view.mediator
{
	import com.bensonarts.puregallery.event.CategoryEvent;
	import com.bensonarts.puregallery.event.StringEvent;
	import com.bensonarts.puregallery.model.vo.StageVO;
	import com.bensonarts.puregallery.notification.ActionList;
	import com.bensonarts.puregallery.view.component.CategoryView;
	
	import flash.display.DisplayObjectContainer;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	/**
	 * 
	 * @author Aaron Benson
	 * CategoryMediator. Listens for events dispatched from the CategoryView component.
	 * 
	 */
	public class CategoryMediator extends Mediator implements IMediator
	{
		// Mediator name
		public static const NAME:String = "CategoryMediator";
		
		private var _categoryView:CategoryView;
		// Class constructor
		public function CategoryMediator( viewComponent:DisplayObjectContainer )
		{
			super(NAME, viewComponent);
		}
		// Listen for the notification names...
		override public function listNotificationInterests():Array
		{
			return [
				ActionList.DATA_READY,
				ActionList.STAGE_RESIZE
			];
		}
		// Handle notification names...
		override public function handleNotification(notification:INotification):void
		{
			switch ( notification.getName() )
			{
				case ActionList.DATA_READY :
					_categoryView.dataProvider = notification.getBody() as Array;
					sendNotification( ActionList.GET_IMAGES );
					break;
				case ActionList.STAGE_RESIZE :
					var stageVO:StageVO = notification.getBody() as StageVO;
					_categoryView.resize( stageVO );
					break;
				default :
					break;
			}
		}
		// Add the CategoryView component to the display list. Add event listeners.
		override public function onRegister():void
		{
			_categoryView = new CategoryView();
			_categoryView.addEventListener( CategoryEvent.CHANGE, _onCategoryChange );
			_categoryView.addEventListener( StringEvent.EVENT, _onFullScreenClick );
			viewComponent.addChild( _categoryView );
			
			var stageVO:StageVO = new StageVO();
			stageVO.stageWidth = this.viewComponent.stage.stageWidth;
			stageVO.stageHeight = this.viewComponent.stage.stageHeight;
			_categoryView.resize( stageVO );
		}
		// When category is clicked, send the id to the command
		private function _onCategoryChange( e:CategoryEvent ):void
		{
			sendNotification( ActionList.CHANGE_CATEGORY, e.id );
		}
		// Fullscreen button click, send notification
		private function _onFullScreenClick( e:StringEvent ):void
		{
			sendNotification( ActionList.TOGGLE_FULLSCREEN );
		}
		
	}
}