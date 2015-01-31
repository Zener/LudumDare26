package
{
	import flash.display.Sprite;
	
	public class Particle extends Sprite
	{
		public var ttl:int;
		private var dx:Number;		
		private var dy:Number;
		
		public function Particle()
		{
			super();
			
			graphics.beginFill(0x00);
			graphics.drawRect(0,0,1,1);
			graphics.endFill();
			
		}
		
		public function set(_ttl:int, x:Number, y:Number, _dx:Number, _dy:Number):void
		{
			this.x = x;
			this.y = y;
			dx = _dx;
			dy = _dy;
			ttl = _ttl;
		}
		
		public function logicUpdate():void
		{
			x += dx;
			y += dy;
			
			dy += 0.015;
			
			if (y >= Game.GROUND_Y) dy = -dy*0.7;
			
			ttl--;
		}
	}
}