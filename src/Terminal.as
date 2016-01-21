package 
{
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Sprite;

	public class Terminal
	{
		// 端末画面サイズのピクセル数
		public static function get fullScreenWidth():uint { return flashStage.fullScreenWidth; }
		public static function get fullScreenHeight():uint { return flashStage.fullScreenHeight; }
		
		public static var contentsArea:Rectangle;
		
		public static var flashStage:Stage;
		
		private static var _starling:Starling;
		private static var viewPort:Rectangle;
		
		public function Terminal()
		{
		}
		
		public static function initialize(target:Stage, mainSprite:Sprite):void
		{
			if(flashStage != null) { return ; }
			
			flashStage = target;
			
			viewPort = new Rectangle(0, 0, fullScreenWidth, fullScreenHeight);
			contentsArea = new Rectangle(0, 0, viewPort.width, viewPort.height);
			
			_starling = new Starling(Sprite, flashStage, viewPort);
			_starling.showStats = true;
			_starling.start();
			
			_starling.stage.addChild(mainSprite);
		}
	}
}