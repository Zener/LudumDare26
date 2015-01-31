package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Menu extends Sprite
	{
		[Embed (source="data/img/menu.png" )]
		public static const backgroundClass:Class;
		
		[Embed(source="data/font/nokiafc22.ttf",fontFamily="system",embedAsCFF="false")] protected var junk:String; 
		
		
		public function Menu()
		{
			super();
			
			var bd:Bitmap = new backgroundClass();
			bd.scaleX = 8;
			bd.scaleY = 8;
			bd.x = 100;
			bd.y = 150;
			this.addChild(bd);
			
			var t0:TextField = addTextfield("CHOOSE DIFFICULTY", false);
			var t1:TextField = addTextfield("EASY");
			var t2:TextField = addTextfield("NORMAL");
			var t3:TextField = addTextfield("DIFFICULT");
			var t4:TextField = addTextfield("INSANE");
			
			t0.x = 300
			t1.x = 300;
			t2.x = 300;
			t3.x = 300;
			t4.x = 300;
			
			t0.y = 400;
			t1.y = 450;
			t2.y = 500;
			t3.y = 550;
			t4.y = 600;
			
			this.addEventListener(Event.ENTER_FRAME, logicUpdate);
		}
		
		
		public function addTextfield(t:String, lis:Boolean = true):TextField
		{
			var tf:TextField = new TextField();
			var myFormat:TextFormat = new TextFormat("system",24,0x000000,null,null,null,null,null,"center");;
			
			tf = new TextField();
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.NORMAL;
			tf.gridFitType = GridFitType.PIXEL;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.selectable = false;
			tf.height = 20;
			tf.width = 400;
			tf.x = 8;
			tf.y = 4;
			tf.defaultTextFormat = myFormat;			
			tf.text = t;
			
			if (lis) tf.addEventListener(MouseEvent.CLICK, onClick);
			this.addChild(tf);
			
			return tf;
		}
		
		private var g:Game;
		
		public function onClick(e:MouseEvent):void
		{
			var diff:int = 0;
			var tf:TextField = e.target as TextField;
			switch(tf.y)
			{
				case 450: diff = 0; break;
				case 500: diff = 1; break;
				case 550: diff = 2; break;
				case 600: diff = 3; break;
			}
			
			g = new Game(diff);
			this.addChild(g);
		}
		
		public function logicUpdate(e:Event):void
		{
			if (g)
			{
				if (g.state == 1 && g.ticks > 300)
				{
					this.removeChild(g);
					g = null;
				}
			}
		}
	}
}