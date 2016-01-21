package 
{
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class MainStarlingSprite extends Sprite
	{
		private var animationLayer:Sprite;
		
		private var playButton:SimpleColorButton;
		private var playFlashButton:SimpleColorButton;
		private var skipButton:SimpleColorButton;
		
		private var stream:NetStream;
		private var image:Image;
		private var texture:Texture;
		
		private var video:Video;
		
		private static const VIDEO_MODE_STARLING:String = "Starling";
		private static const VIDEO_MODE_FLASH:String = "Flash";
		
		private var videoMode:String;
		
		public function MainStarlingSprite()
		{
			super();
			//
			playButton = new SimpleColorButton(100, 50, 0x880000, "Play in Starling (MP4)", 0xFFFFFF);
			playButton.x = 100;
			playButton.y = 100;
			
			skipButton = new SimpleColorButton(100, 50, 0x0000a0, "Skip Movie", 0xFFFFFF);
			skipButton.x = 220;
			skipButton.y = 100;
			skipButton.touchable = false;
			skipButton.alpha = 0.2;
			
			playFlashButton = new SimpleColorButton(100, 50, 0x008800, "Play in flash.display (FLV)", 0xFFFFFF);
			playFlashButton.x = 100;
			playFlashButton.y = 160;
			
			animationLayer = new Sprite();
			this.addChild(animationLayer);
			this.addChild(playButton);
			this.addChild(skipButton);
			this.addChild(playFlashButton);
			
			playButton.addEventListener(Event.TRIGGERED, playVideo);
			playFlashButton.addEventListener(Event.TRIGGERED, playFlashVideo);
			skipButton.addEventListener(Event.TRIGGERED, finish);
		}
		
		private function playVideo(event:Event):void
		{
			if(!playButton.touchable) return;
			
			videoMode = VIDEO_MODE_STARLING;
			
			playButton.touchable = false;
			playButton.alpha = 0.2;
			
			playFlashButton.touchable = false;
			playFlashButton.alpha = 0.2;
			
			skipButton.touchable = true;
			skipButton.alpha = 1;
			
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			
			stream = new NetStream(connection);
			
			
			image = null;
			texture = Texture.fromNetStream(stream, 1, function():void {
				
				trace("Video load Complete.");
				
				image = new Image(texture);
				
				image.x = 0;
				var animationScale:Number = Terminal.contentsArea.width / texture.width;
				image.scaleX = animationScale;
				image.scaleY = animationScale;
				image.y = (Terminal.contentsArea.height - (texture.height * animationScale)) / 2;
				
				animationLayer.addChild(image);
			});
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			stream.play("app:/sampleVideo.mp4");
		}
		
		private function playFlashVideo(event:Event):void
		{
			if(!playFlashButton.touchable) return;
			
			videoMode = VIDEO_MODE_FLASH;
			
			playButton.touchable = false;
			playButton.alpha = 0.2;
			
			playFlashButton.touchable = false;
			playFlashButton.alpha = 0.2;
			
			skipButton.touchable = true;
			skipButton.alpha = 1;
			
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			
			stream = new NetStream(connection);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, function(e:AsyncErrorEvent):void{});
			stream.client = this;
			
			video = new Video();
			video.attachNetStream(stream);
			
			video.x = Terminal.contentsArea.x;
			video.width = Terminal.contentsArea.width;
			video.height = video.width * (16 / 9);
			video.y = Terminal.contentsArea.y - (video.height - Terminal.contentsArea.height) / 2;
			
			Terminal.flashStage.addChild(video);
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			stream.play("app:/sampleVideo.flv");
		}
		
		private function finish (e:* = null):void
		{
			if(!skipButton.touchable) return;
			
			playButton.touchable = true;
			playButton.alpha = 1;
			
			playFlashButton.touchable = true;
			playFlashButton.alpha = 1;
			
			skipButton.touchable = false;
			skipButton.alpha = 0.2;
			
			stream.close();
			stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			stream.dispose();
			
			switch(videoMode)
			{
				case VIDEO_MODE_STARLING:
					image.removeFromParent(true);
					texture.dispose();
					break;
				
				case VIDEO_MODE_FLASH:
					if(Terminal.flashStage.contains(video))
					{
						Terminal.flashStage.removeChild(video);
					}
					video.clear();
					break;
			}
		};
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
			
			if(event.info.level == "error") {
				finish(new Error(event.info.code));
			}
			else if(event.info.code == "NetStream.Play.Stop") {
				finish();
			}
		};
		
		public function onCuePoint(e:*):void{}
		public function onImageData(e:*):void{}
		public function onMetaData(e:*):void{}
		public function onPlayStatus(e:*):void{}
		public function onSeekPoint(e:*):void{}
		public function onTextData(e:*):void{}
		public function onXMPData(e:*):void{}
		
	}
}