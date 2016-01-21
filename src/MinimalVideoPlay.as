package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	
	
	public class MinimalVideoPlay extends Sprite
	{
		
		public function MinimalVideoPlay()
		{
			super();
			
			// autoOrients をサポート
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Terminal.initialize(stage, new MainStarlingSprite());
		}
	}
}