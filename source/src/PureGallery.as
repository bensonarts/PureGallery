package {
	import com.bensonarts.puregallery.ApplicationFacade;
	import com.bensonarts.puregallery.service.ServiceCalls;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	/**
	 * @author Aaron Benson
	 * http://activeden.net/user/abenson
	 * http://www.bensonarts.com
	 * bensonan55@gmail.com
	 */
	public class PureGallery extends Sprite
	{
		public static const KEY:String = "com.bensonarts.puregallery.PureGallery";
		// Data path var
		private var _dataPath:String;
		// Class Constructor, add ADDED_TO_STAGE event listener
		public function PureGallery()
		{
			this.addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
		}
		// Getter for dataPath
		public function get dataPath():String
		{
			return _dataPath;
		}
		// Setter for dataPath
		public function set dataPath( value:String ):void
		{
			_dataPath = value;
			ServiceCalls.turnOnRemote( dataPath );
			_init();
		}
		// Set up the stage attributes
		private function _stageSetup():void
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		// Find the dataPath load vars in the JavaScript embed code, if not found, default to local file
		private function _loadVars():void
		{
			if ( LoaderInfo( this.root.loaderInfo ).parameters.dataPath && dataPath != null )
			{
				dataPath = String( LoaderInfo( this.root.loaderInfo ).parameters.dataPath );
			} else {
				//--------------------------------------------------------------------------------------//
				// For running locally with no dataPath - will always link to assets/xml/gallery.xml
				// Turn the two lines of code on for local testing...
				//--------------------------------------------------------------------------------------//
				ServiceCalls.turnOnLocal();
				_init();
				//--------------------------------------------------------------------------------------//
				trace( 	"\nYou must set the dataPath in the FlashVars in your javascript embed code like so \n" + 
						'var flashvars = { dataPath: "http://domain.com/gallerycms/index.php/view/xml" };' + 
						" \n\n ---or--- \n\n" + 
						"If you are attempting to load this SWF in Flash, you must set the dataPath like so \n" + 
						'Object( loader.content ).dataPath = "http://domain.com/gallerycms/index.php/view/xml";\n\n' );
			}
		}
		// Register PureMVC Application facade. pass this display object into the constructor
		private function _init():void
		{
			ApplicationFacade.getInstance( PureGallery.KEY ).startup( this );
		}
		// On added to stage event handler
		private function _onAddedToStage( e:Event ):void
		{
			_stageSetup();
			_loadVars();
			this.removeEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
		}
		
	}
}
