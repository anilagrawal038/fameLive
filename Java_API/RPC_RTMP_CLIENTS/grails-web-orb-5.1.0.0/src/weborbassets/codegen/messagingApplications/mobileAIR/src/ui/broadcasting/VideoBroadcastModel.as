package ui.broadcasting
{
	import flash.media.Camera;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	/**
	 * Model of the broadcast triad.<br/>
	 * VideoBroadcastModel class holds data necessary to update view 
	 * that implements broadcast GUI
	 */
	public class VideoBroadcastModel
	{
		/**
		 * True means that connection to server is established.
		 * Otherwise false.
		 */
		public var connected:Boolean = false;
		
		/**
		 * True means that broadcast runs at the moment.
		 * Otherwise false.
		 */
		public var broadcasting:Boolean = false;
		
		public var cameraNames:ArrayCollection = new ArrayCollection( Camera.names );
		
		public var selectedCameraIndex:int = 0;
	}
}