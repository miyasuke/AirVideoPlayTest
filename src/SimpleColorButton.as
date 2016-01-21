package 
{
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class SimpleColorButton extends Sprite
	{	
		private var self:SimpleColorButton;
		
		private var canceled:Boolean;
		
		public function SimpleColorButton(width:Number, height:Number, color:uint, labelText:String, textColor:uint = 0x000000)
		{
			super();
			
			var back:Quad = new Quad(width, height, color);
			back.alignPivot();
			
			this.addChild(back);
			
			var label:TextField = new TextField(width, height, labelText);
			label.color = textColor;
			label.x = -width/2;
			label.y = -height/2;
			
			this.addChild(label);
			if(stage == null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else
			{
				this.addEventListener(TouchEvent.TOUCH, onTouch);
			}
			
			self = this;
			canceled = false;
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.touches[0];
			
			switch(touch.phase)
			{
				case TouchPhase.BEGAN:
					if(touch.isTouching(self))
					{
						this.scaleX = 1.2;
						this.scaleY = 1.2;
						canceled = false;
					}
					break;
					
				case TouchPhase.MOVED:
					if(!self.getBounds(self).containsPoint(touch.getLocation(self)))
					{
						this.scaleX = 1;
						this.scaleY = 1;
						canceled = true;
					}
					break;
					
				case TouchPhase.ENDED:
					this.scaleX = 1;
					this.scaleY = 1;
					
					if(!canceled && self.getBounds(self).containsPoint(touch.getLocation(self)))
					{
						this.dispatchEventWith(Event.TRIGGERED);
					}
					
					break;
			}
			
		}
	}
}