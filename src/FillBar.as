package
{
	import flash.display.Sprite;
	
	public class FillBar extends Sprite
	{
		private var percentage:Number = 1;
		private var barWidth:int;
		private var barHeight:int;
		
		public function FillBar(_width:int, _height:int)
		{
			super();
			barWidth = _width;
			barHeight = _height;					
			
			setPercentage(0);
		}
		
		public function setPercentage(v:Number):void
		{
			if (percentage == v) return;
			percentage = v;			
			var _width:int = Math.round((barWidth-4)*percentage);
			
			graphics.clear();
			graphics.lineStyle(1, 0, 1, true);			
			graphics.beginFill(0x00)
			graphics.drawRect(0, -barHeight-2, barWidth, barHeight);
			graphics.endFill();
			
			
			graphics.lineStyle(1, 0xffffff, 1, true);			
			graphics.beginFill(0xffffff);
			graphics.drawRect(0+1, (-barHeight)+1-2, (barWidth)-2, (barHeight)-2);
			graphics.endFill();
			
			
			graphics.lineStyle(1, 0, 1, true);
			graphics.beginFill(0x00);
			graphics.drawRect(0+2, (-barHeight)+2-2, (_width), (barHeight)-4);
			graphics.endFill();			
		}
	}
}