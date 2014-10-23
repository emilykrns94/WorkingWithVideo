package
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	
	import feathers.themes.MinimalMobileTheme;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.controls.Screen;
	import feathers.controls.Button;
	import feathers.layout.VerticalLayout;
	import feathers.layout.VerticalLayoutData;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.events.FeathersEventType;
	import starling.utils.AssetManager;
	
	import starling.display.Button;
	import flash.filesystem.File;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	
	public class Main extends Screen
	{
		private var assetMgr:AssetManager;
		private var controlButton:Button;
		private var videoStream:NetStream;
		private var video:Video;
		private var videoPlaying:Boolean;
		private var portraitMode:Boolean;

		public function Main()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		private function initializeHandler(e:Event):void
		{
			this.removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			this.stage.addEventListener(Event.RESIZE,stageResized);
			assetMgr = new AssetManager();
			assetMgr.verbose = true;
			
			var appDir:File = File.applicationDirectory;
			assetMgr.enqueue(appDir.resolvePath("assets"))
			assetMgr.loadQueue(handleAssetsLoading);
		}
		
		private function handleAssetsLoading(ratioLoaded:Number):void
		{
			trace("handleAssetsLoading: " + ratioLoaded);
			if (ratioLoaded == 1)
			{
				startApp();
			}
		}
		
		private function startApp()
		{
			new MetalWorksMobileTheme();

			this.layout = new AnchorLayout();
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
			portraitMode = true;
			setupVideo();
			setupButton();
		}
		
		private function setupVideo()
		{
			var nc:NetConnection = new NetConnection()
			nc.connect(null);
			videoStream = new NetStream(nc);
			videoStream.client = this;
			video = new Video();
			Starling.current.nativeStage.addChild(video);
			video.attachNetStream(videoStream);
			videoPlaying = false;
			positionVideo();
		}
		
		private function setupButton()
		{
			controlButton = new Button;
			controlButton.label = "Play"
			var controlButtonLayout: AnchorLayoutData = new AnchorLayoutData();
			controlButtonLayout.left = 10;
			controlButtonLayout.right = 10;
			controlButtonLayout.bottom = 10;
			controlButton.layoutData = controlButtonLayout;
			controlButton.addEventListener(Event.TRIGGERED, handleControlButtonClick);
			this.addChild(controlButton);
		}
		
		private function handleControlButtonClick(e:Event):void
		{
			if (! videoPlaying)
			{
				videoStream.play("videos/Ed Sheeran - I'm A Mess (x Acoustic Sessions).mp4");
				controlButton.label = "Pause";
				videoPlaying = true;
			}
			else
			{
				videoStream.togglePause();
				videoPlaying = false;
				controlButton.label = "Play";
			}
		}
		
		protected function stageResized(e:Event):void
		{
			this.height = this.stage.stageHeight;
			this.width = this.stage.stageWidth;
			if (this.height > this.width)
			{
				this.portraitMode = true;
			}
			else
			{
				this.portraitMode = false;
			}
			positionVideo();
		}
		
		private function positionVideo()
		{
			if (video !=null)
			{
				if (! portraitMode)
				{
					video.height = this.height - controlButton.height - 5 - 10;
					video.scaleX = video.scaleY;
					
					video.x = (this.width - video.width)/2
					video.y = 5;
				}
				else
				{
					video.width = this.width - 10;
					video.scaleY = video.scaleX;
					
					video.x = 5;
					video.y = 5;
				}
			}
			
		}
		
		public function onMetaData(infoObject:Object)
		{
			trace ("onMetaData invoke...");
		}
		
		public function onXMPData(infoObject:Object)
		{
			trace ("onXMPData invoke...");
		}
		
		public function onCuePoint(infoObject:Object)
		{
			trace ("onCuePoint invoke...");
		}

	}

}