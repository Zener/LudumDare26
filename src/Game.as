package
{
	///////////////////////////////////////////////////////////////////////////////////////////
	// Minimal Annihilation
	// Evolution game for Ludum Dare
	// Author: Carlos Peris
	// Date: 28/04/2013
	///////////////////////////////////////////////////////////////////////////////////////////
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class Game extends Sprite
	{
		public static var GFX_SCALE:int = 3;
		
		public static var CANVAS_WIDTH:int = 320;
		public static var CANVAS_HEIGHT:int = 240;

		public static var FACTION_NONE:int = 0;
		public static var FACTION_1:int = 1;
		public static var FACTION_2:int = 2;
		
		private var canvasSprite:Sprite;		
		//private var minimapBitmap:Bitmap;
		
		public static var players:Vector.<Player>;
		public static var units:Vector.<Unit>;
		public static var unitsSelected:Vector.<Unit>;
		public static var particles:Vector.<Particle>;
		public static var GROUND_Y:int = 155;
		public var scrollOffsetX:Number = 0;
		public var backGroundBitmap:Bitmap;
		private var clickSprite:Sprite = new Sprite();
		public static var hud:HUD = new HUD();
		public static var smInstance:Game;
		public static var cursorX:int;
		public static var cursorY:int;
		
		[Embed (source="data/img/background.png" )]
		public static const backgroundClass:Class;

		[Embed(source="data/font/nokiafc22.ttf",fontFamily="system",embedAsCFF="false")] protected var junk:String; 
		
		public function Game(difficulty:int = 3)
		{
			super();

			switch(difficulty)
			{
				case 0: Player.iaDelay = 500;Player.handicapDrone = 2;break;
				case 1: Player.iaDelay = 260;Player.handicapDrone = 1;break;
				case 2: Player.iaDelay = 80;Player.handicapDrone = 1;break;
				case 3: Player.iaDelay = 0;Player.handicapDrone = 0;break;
			}
			Player.difficulty = difficulty;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			state = -1;
		}
		
		
		public function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		
			smInstance = this;
			initDisplay();
			Unit.loadResources();
			initEngine();
			
			this.addEventListener(Event.ENTER_FRAME, logicUpdate);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			//stage.addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
			
			SfxManager.getInstance().playSound("music", -1, 0.5);
			
		}
		
		
		public function initDisplay():void
		{
			canvasSprite = new Sprite();
			canvasSprite.scaleX = GFX_SCALE;
			canvasSprite.scaleY = GFX_SCALE;
			
				/*var mosaicTexture:BitmapData = makeMosaicTexture(GFX_SCALE);
			var mosaicSprite:Sprite = new Sprite();
			mosaicSprite.graphics.beginBitmapFill(mosaicTexture, null, true, false);
			mosaicSprite.graphics.drawRect(0,0,CANVAS_WIDTH*GFX_SCALE, CANVAS_HEIGHT*GFX_SCALE);
			mosaicSprite.graphics.endFill();
			mosaicSprite.blendMode = BlendMode.OVERLAY;
			mosaicSprite.alpha = 0.4;*/
			
			/*var bd:BitmapData = new BitmapData(CANVAS_WIDTH*GFX_SCALE, CANVAS_HEIGHT*GFX_SCALE); 
			displayBitmap = new Bitmap(bd);
			displayBitmap.scaleX = GFX_SCALE;
			displayBitmap.scaleY = GFX_SCALE;
			
			this.addChild(displayBitmap);*/
			
			
			this.addChild(canvasSprite);
			//this.addChild(mosaicSprite);
			this.addChild(hud);
			
		}
		
		
		public var mineralTextField:TextField;
		public var tutorialTextField:TextField;
		
		
		public function initEngine():void
		{
			units = new Vector.<Unit>();
			unitsSelected = new Vector.<Unit>();
			players = new Vector.<Player>();
			particles = new Vector.<Particle>;
			
			for (var i:int = 0; i < 3; i++)
				players.push(new Player(i));
			
			
			backGroundBitmap = new backgroundClass();
			canvasSprite.addChild(backGroundBitmap);

			
			u = addUnit(FACTION_NONE, Unit.TYPE_MINERALS, "Minerals");
			u.setPosition(30, GROUND_Y);
			
			u = addUnit(FACTION_NONE, Unit.TYPE_MINERALS, "Minerals");
			u.setPosition(880, GROUND_Y);
			
			var u:Unit = addUnit(FACTION_1, Unit.TYPE_HQ);
			u.setPosition(100, GROUND_Y);
			
			u = addUnit(FACTION_2, Unit.TYPE_HQ);
			u.setPosition(800, GROUND_Y);
			
			u = addUnit(FACTION_2, Unit.TYPE_DRONE);
			u.setPosition(700, GROUND_Y);
			
			//u = addUnit(FACTION_1, Unit.TYPE_RAIDER);
			//u.setPosition(200, GROUND_Y);
			
			u = addUnit(FACTION_1, Unit.TYPE_DRONE);
			u.setPosition(150, GROUND_Y);
			
		
			
			clickSprite = new Sprite();
			clickSprite.graphics.beginFill(0xffffff);
			clickSprite.graphics.drawRect(-10,-10, 20, 20);
			clickSprite.graphics.endFill();
			
			
			
			
			SfxManager.getInstance().loadSound("data/snd/fish.mp3", "music", 1);
			SfxManager.getInstance().loadSound("data/snd/click2.mp3", "click", 1);
			
			
			
			var myFormat:TextFormat = new TextFormat("system",8*GFX_SCALE,0x000000,null,null,null,null,null,"left");;
			
			
			mineralTextField = new TextField();
			mineralTextField.embedFonts = true;
			mineralTextField.antiAliasType = AntiAliasType.NORMAL;
			mineralTextField.gridFitType = GridFitType.PIXEL;
			mineralTextField.multiline = true;
			mineralTextField.wordWrap = true;
			mineralTextField.selectable = false;
			mineralTextField.height = 100;
			mineralTextField.width = 400;
			mineralTextField.x = 8;
			mineralTextField.y = 4;
			mineralTextField.defaultTextFormat = myFormat;
			
			mineralTextField.text = "Minerals: "+players[FACTION_1].minerals;
			
			
			
			
			
			//
			this.addChild(mineralTextField);
			
			
			
			var spotTexture:BitmapData = makeSpotlightTexture(CANVAS_WIDTH, CANVAS_HEIGHT, 150, 145, 25);
		
			spotSprite.graphics.beginBitmapFill(spotTexture, null, true, false);
			spotSprite.graphics.drawRect(0,0,CANVAS_WIDTH, CANVAS_HEIGHT);
			spotSprite.graphics.endFill();
			canvasSprite.addChild(spotSprite);
			spotSprite.blendMode = BlendMode.SUBTRACT;
			
			
			tutorialTextField = new TextField();
			tutorialTextField.embedFonts = true;
			tutorialTextField.antiAliasType = AntiAliasType.NORMAL;
			tutorialTextField.gridFitType = GridFitType.PIXEL;
			tutorialTextField.multiline = true;
			tutorialTextField.wordWrap = true;
			tutorialTextField.selectable = false;
			tutorialTextField.height = 200;
			tutorialTextField.width = 600;
			tutorialTextField.x = 320;
			tutorialTextField.y = 191;
			tutorialTextField.defaultTextFormat = myFormat;
			
			tutorialTextField.text = "I'm a drone.\nI'm very useful, I can:\n -Collect minerals\n -Build structures\nWe need more minerals.";
			this.addChild(tutorialTextField);
		}
		
		public var spotSprite:Sprite = new Sprite();
		
		
		public function addUnit(faction:int, type:int, name:String = null):Unit
		{
			var u:Unit;
			switch(type)
			{
				case Unit.TYPE_BARRACKS:
					u = new Barracks(faction, type);
					break;
				case Unit.TYPE_HQ:
					u = new HQ(faction, type);
					break;
				case Unit.TYPE_DRONE:
					u = new Drone(faction, type);
					break;
				case Unit.TYPE_RAIDER:
					u = new Raider(faction, type);
					break;
				case Unit.TYPE_MARINE:
					u = new Marine(faction, type);
					break;
				case Unit.TYPE_TANK:
					u = new Tank(faction, type);
					break;
				default:
					u = new Unit(faction, type);
					if (name) u.unitName = name;
					break;
			}
			units.push(u);
			if (u.isABuilding)
			{
				canvasSprite.addChildAt(u, 1);
			}
			else
			{
				canvasSprite.addChild(u);
			}
			return u;
		}
		
		
		public var state:int = 0;
		public var ticks:int = 0;
		
		public function logicUpdate(e:Event = null):void
		{
			
			
			if (state <= 0)
			{
				var i:int;
				//Input
				
				//AI
				if (state == 0)	players[FACTION_2].logicUpdate();
				
				
				//Logic
				players[FACTION_1].myUnitsCount = 0;
				players[FACTION_2].myUnitsCount = 0;
				for (i = 0; i < units.length; i++)
				{
					players[units[i].faction].myUnitsCount++;
					units[i].updateFrame("");
					units[i].logicUpdate();				
				}
				for (i = 0; i < units.length; i++)
				{
					if (units[i].energy <= 0)
					{
						canvasSprite.removeChild(units[i]);
						addParticles(units[i].x, units[i].y);
						units.splice(i,1);
						i-= 1;
						
					}
				}
				
				for (i = 0; i < particles.length; i++)
				{
					particles[i].logicUpdate();
					if (particles[i].ttl <= 0)
					{
						canvasSprite.removeChild(particles[i]);
						particles.splice(i,1);
						i-= 1;	
					}
				}
				
				
				
				//UI
				hud.logicUpdate();
				mineralTextField.text = "Minerals: "+players[FACTION_1].minerals;
				
				if (players[FACTION_2].myUnitsCount == 0)
				{
					state = 1;
					mineralTextField.text = "You win";					
					ticks = 0;
				}
				if (players[FACTION_1].myUnitsCount == 0)
				{
					state = 1;
					mineralTextField.text = "You lose!";
					ticks = 0;
				}
			}
			else
			{
				mineralTextField.x = 150*3;
				mineralTextField.y = 110*3;
				ticks++;	
			}
			//Render	
			if (scrollOffsetX < -(backGroundBitmap.width - CANVAS_WIDTH)) scrollOffsetX = -(backGroundBitmap.width - CANVAS_WIDTH);
			if (scrollOffsetX > 0) scrollOffsetX = 0;
			canvasSprite.x = scrollOffsetX*GFX_SCALE;
			
			/*var b:BitmapData = minimapBitmap.bitmapData;
			//var m:Matrix = new Matrix();
			//m.translate(scrollOffsetX, 0);
			b.draw(canvasSprite);
			//var bitmap:Bitmap = new Bitmap(b);*/
		}
		
		
		public function addParticles(x:int, y:int):void
		{
			for(var i:int;i < 10; i++)
			{
				var p:Particle = new Particle();
				p.set(120+(Math.random()*60), x+(Math.random()*10), y+(Math.random()*10), (Math.random()- Math.random())*0.7, Math.random()- Math.random());
				canvasSprite.addChild(p);
				particles.push(p);
			}
		}
		
		private var startScrollX:int = -1;
		private var startScrollDX:int = 0;
		
		public function onMouseDown(e:MouseEvent):void
		{
			if (state < 0)
			{
				state = 0;
				canvasSprite.removeChild(spotSprite);
				this.removeChild(tutorialTextField);				
				return;
			}
			
			startScrollX = e.stageX;
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			if (startScrollX != -1)
			{			
				startScrollDX =  e.stageX - startScrollX;
				scrollOffsetX += startScrollDX;
				startScrollX = e.stageX;
			}
			cursorX = e.stageX;
			cursorY = e.stageY;
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			startScrollX = -1;
			startScrollDX = 0;
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.RIGHT)
			{
					scrollOffsetX -= 2*GFX_SCALE;
			}
			if (e.keyCode == Keyboard.LEFT)
			{
					scrollOffsetX += 2*GFX_SCALE;
			}
			
		}
		
		public function onRightClick(e:MouseEvent):void
		{
			if (hud.placingBitmap)
			{
				hud.droneBuild();
				SfxManager.getInstance().playSound("click", 0);
				return;
			}
			
			for (var i:int = 0; i < unitsSelected.length;i++)
			{
				if (!unitsSelected[i].isABuilding)
				{
					unitsSelected[i].rightClick(  ((e.stageX) / GFX_SCALE)- scrollOffsetX, e.stageY / GFX_SCALE);
					
					SfxManager.getInstance().playSound("click", 0);
				}
			}
		}
		
		
		public function onClick(e:MouseEvent):void
		{
			
			//trace(""+(e.stageX / GFX_SCALE) + "  "+ (e.stageY / GFX_SCALE) + " "+scrollOffsetX);
			
			
				

				
			
			/*if (unitsSelected.length > 0)
			{
				onRightClick(e);
			}*/
			
			if (hud.placingBitmap)
			{
				hud.droneBuild();
				SfxManager.getInstance().playSound("click", 0);				
			}
			
			clickSprite.x = ((e.stageX) / GFX_SCALE)- scrollOffsetX ;
			clickSprite.y = e.stageY / GFX_SCALE;
			
			var closestObject:Object = null;
			var closestDistance:int = -1;
			
			for (var i:int = 0; i < units.length; i++)
			{				
				if (units[i].faction == FACTION_1 && units[i].hitTestObject(clickSprite))
				{
					var d:int = Math.abs(units[i].x - clickSprite.x) + Math.abs(units[i].y - clickSprite.y);
					if (closestDistance == -1 || d < closestDistance)
					{
						closestObject = units[i];
						closestDistance = d;
					}
				}
			}
			
			if (closestObject)
			{
				SfxManager.getInstance().playSound("click", 0);
				closestObject.dispatchEvent( new MouseEvent(MouseEvent.CLICK) );
			}
		}
		
		
		
		public function collidesWithOtherBuildings(sourceX:int, sourceWidth:int):Boolean
		{
			var sx:int = sourceX ;// + source.width/2;
			for (var i:int = 0; i < Game.units.length; i++)
			{
				var u:Unit = Game.units[i];
				if (u.isABuilding)
				{
					if ((sx + sourceWidth < u.position.x - (u.gfx.width/2) || sx  > u.position.x- (u.gfx.width/2) + u.gfx.width))// && !(u.position.x > sx && u.position.x + u.gfx.width >  sx + sourceWidth))
					{
						continue;
					}
					return true;
				}
			}
			return false;
		}
		
		
		public function makeSpotlightTexture(_width:int, _height:int, _x:int, _y:int, _radius:Number):BitmapData
		{
			var bd:BitmapData = new BitmapData(_width, _height, true, 0xffffff);
			
			var w:int = 0xff505050;
			for(var y:int = 0; y < _height-1; y++)
			{
				for(var x:int = 0; x < _width-1; x++) 
				{					
					var dx:int = x - _x;
					var dy:int = y - _y;
					if ((dx*dx) + (dy*dy) > _radius*_radius)
					{
						bd.setPixel32(x, y, w);
					}
				}
			}
			return bd;
		}
		
		
		
	}
}