package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HUD extends Sprite
	{
		[Embed (source="data/img/button.png" )]
		public static const buttonClass:Class;
		[Embed (source="data/img/button_drone.png" )]
		public static const buttonDroneClass:Class;
		[Embed (source="data/img/button_hq.png" )]
		public static const buttonHQClass:Class;
		[Embed (source="data/img/button_barracks.png" )]
		public static const buttonBarracksClass:Class;
		[Embed (source="data/img/button_marine.png" )]
		public static const buttonMarineClass:Class;
		[Embed (source="data/img/button_raider.png" )]
		public static const buttonRaiderClass:Class;
		[Embed (source="data/img/button_cancel.png" )]
		public static const buttonCancelClass:Class;
		[Embed (source="data/img/button_tank.png" )]
		public static const buttonTankClass:Class;
		
		
		[Embed (source="data/img/hud.png" )]
		public static const hudClass:Class;
		
		public static const MINIMAP_SCALE:Number = 0.09;
		public var selected:Unit;
		public var buttons:Array;
		public var constructionBar:FillBar;
		public var placingBitmap:Bitmap;
		public var miniMap:Sprite;
		public var unitName:TextField;
		public var info:TextField;
		
		public function drawMinimap():void
		{
			var w:int = Game.smInstance.backGroundBitmap.width;
			var h:int = Game.smInstance.backGroundBitmap.height;
			
			var mapw:int = w*MINIMAP_SCALE;
			var maph:int = h*MINIMAP_SCALE;
			miniMap.graphics.clear();
			miniMap.graphics.beginFill(0xffffff);
			miniMap.graphics.drawRect(0,0, mapw, maph);
			miniMap.graphics.beginFill(0x0);
			var groundY:int = Game.GROUND_Y;
			miniMap.graphics.drawRect(0,groundY*MINIMAP_SCALE, mapw, 1);
			for (var i:int = 0; i < Game.units.length; i++)
			{
				var u:Unit = Game.units[i];
				
				var x:int = u.position.x * MINIMAP_SCALE;
				var y:int = u.position.y * MINIMAP_SCALE;
				if (u.isABuilding)
				{					
					miniMap.graphics.drawRect(x-1,y-1, 3, 2);
				}
				else
				{
					miniMap.graphics.drawRect(x,y, 1, 1);
				}
			}
			
		}
		
		
		
		public function HUD()
		{
			super();
			
			
			scaleX = 3;
			scaleY = 3;
			
			var b:Bitmap = new hudClass();
			b.y = 240 - b.height;
			this.addChild(b);
			
			buttons = new Array();
			
			constructionBar = new FillBar(150, 10);
			constructionBar.visible = false;
			constructionBar.y = 197;
			constructionBar.x = 100;
			
			miniMap = new Sprite();
			miniMap.addEventListener(MouseEvent.CLICK, onMiniMapClick);
			miniMap.x = 6;
			miniMap.y = 207;
			
			unitName = new TextField();			
			var myFormat:TextFormat = new TextFormat("system",8,0x000000,null,null,null,null,null,"center");
			unitName.embedFonts = true;
			unitName.antiAliasType = AntiAliasType.NORMAL;
			unitName.gridFitType = GridFitType.PIXEL;
			unitName.multiline = true;
			unitName.wordWrap = true;
			unitName.selectable = false;
			unitName.width = 100;
			unitName.height = 30;
			
			unitName.defaultTextFormat = myFormat;
			
			unitName.x = 0;
			unitName.y = 182;
			
			
			info = new TextField();			
			//var myFormat:TextFormat = new TextFormat("system",8,0x000000,null,null,null,null,null,"center");
			info.embedFonts = true;
			info.antiAliasType = AntiAliasType.NORMAL;
			info.gridFitType = GridFitType.PIXEL;
			info.multiline = true;
			info.wordWrap = true;
			info.selectable = false;
			info.width = 100;
			info.height = 100;			
			info.defaultTextFormat = myFormat;			
			info.x = 236;
			info.y = 182;
			
			
			this.addChild(constructionBar);
			this.addChild(miniMap);
			this.addChild(unitName);
			this.addChild(info);
		}
		
		public function updateHUD(_selected:Unit):void
		{
			selected = _selected;
			
			constructionBar.visible = false;
			removeButtons();
			unitName.text = selected.unitName;
			if (selected.faction == Game.FACTION_1)
			{
				switch(selected.type)
				{
					case Unit.TYPE_HQ:					
						constructionBar.visible = true;
						addButton(Unit.TYPE_DRONE);
						break;
					case Unit.TYPE_BARRACKS:					
						constructionBar.visible = true;
						addButton(Unit.TYPE_MARINE);
						addButton(Unit.TYPE_RAIDER);
						addButton(Unit.TYPE_TANK);
						break;
					case Unit.TYPE_DRONE:
						addButton(Unit.TYPE_HQ);
						addButton(Unit.TYPE_BARRACKS);
						addButton(-1);
						break;
				}
			}	
			
		}
		
		public function logicUpdate():void
		{
			for (var j:int = 0; j < buttons.length; j++)
			{			
				buttons[j].spr.alpha = Game.players[Game.FACTION_1].canPay(buttons[j].type)? 1: 0.5;
			}
			
			if (selected && selected.isABuilding)
			{
				constructionBar.setPercentage(selected.constructionPercent);
				{
					for (var i:int = 0; i < buttons.length; i++)
					{
						buttons[i].spr.alpha *= selected.buildingPercent >= 100 && selected.constructionPercent == 0 ? 1: 0.5;
					}
				}
				
					
			}
			
			
			
			if (placingBitmap)
			{				
				placingBitmap.x = (Game.cursorX / Game.GFX_SCALE) - placingBitmap.width/2;
				placingBitmap.y = Game.GROUND_Y - placingBitmap.height;
				placingBitmap.alpha = Game.smInstance.collidesWithOtherBuildings(placingBitmap.x- Game.smInstance.scrollOffsetX, placingBitmap.width)? 0.5: 1;
			}
			
			drawMinimap();
		}
		
		
		
		public function addButton(t:int):void
		{
			
			var s:Sprite = new Sprite();
			this.addChild(s);
			var b:Bitmap;
			switch(t)
			{
				case -1:b = new buttonCancelClass();break;
				case Unit.TYPE_DRONE: b = new buttonDroneClass();break;
				case Unit.TYPE_HQ: b = new buttonHQClass();break;
				case Unit.TYPE_BARRACKS: b = new buttonBarracksClass();break;
				case Unit.TYPE_RAIDER: b = new buttonRaiderClass();break;
				case Unit.TYPE_MARINE: b = new buttonMarineClass();break;
				case Unit.TYPE_TANK: b = new buttonTankClass();break;
				default: b = new buttonClass();break;
			}
			s.addChild(b);
			s.x  = 101 + buttons.length*50;
			s.y  = 200;
			s.mouseChildren = false;
			
			var myFormat:TextFormat = new TextFormat("system",8,0x000000,null,null,null,null,null,"center");
			var txt:TextField = new TextField();
			txt.embedFonts = true;
			txt.antiAliasType = AntiAliasType.NORMAL;
			txt.gridFitType = GridFitType.PIXEL;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.selectable = false;
			txt.height = 36;
			txt.width = 50;
			txt.x = -2
			txt.defaultTextFormat = myFormat;
			
			
			
			if (t == -1)
				txt.text = "";
			else
				txt.text = ""+Game.players[0].getPrice(t);	
			/*switch(t)
			{
				case Unit.TYPE_DRONE:
					txt.text = Drone.; 
					break;
				case Unit.TYPE_HQ:
					txt.text = "HQ"; 
					break;
				case Unit.TYPE_BARRACKS:
					txt.text = "BARRACKS"; 
					break;
				case Unit.TYPE_RAIDER:
					txt.text = "RAIDER"; 
					break;
				case Unit.TYPE_MARINE:
					txt.text = "MARINE"; 
					break;
			}*/
			
			s.addChild(txt);	
			s.addEventListener(MouseEvent.CLICK, onClick);
			if (t >= 0)
				s.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			
			var obj:Object = new Object();
			obj.spr = s;
			obj.type = t;
			buttons.push(obj);
		}
		
		public function removeButtons():void
		{			
			for (var i:int = 0; i < buttons.length; i++)
			{
				this.removeChild(buttons[i].spr);
			}
			buttons.length = 0;
		}
		
		
		public function onClick(e:MouseEvent):void
		{
			
			var drone:Drone;
			SfxManager.getInstance().playSound("click", 0);
		
			var b:Sprite = e.target as Sprite;
			for (var i:int = 0; i < buttons.length; i++)
			{
				if (buttons[i].spr == b)
				{
					var type:int = buttons[i].type;
					if (type == -1)
					{
						if (selected) selected.unselectAll();
						Game.unitsSelected.length = 0;
						selected = null;
						if (placingBitmap)
						{
							this.removeChild(placingBitmap);	
							placingBitmap = null;
							e.stopImmediatePropagation();
						}
						return;
					}
					
					
					if (!Game.players[Game.FACTION_1].canPay(type)) break;
					switch(type)
					{
						case Unit.TYPE_MARINE:
						case Unit.TYPE_RAIDER:
						case Unit.TYPE_TANK:
							var barracks:Barracks = selected as Barracks;
							barracks.build(type);							
							break;
						
						case Unit.TYPE_DRONE:
							var hq:HQ = selected as HQ;
							hq.build(type);							
							break;
						case Unit.TYPE_HQ:						
							drone = selected as Drone;
							constructionType = type;
							placingBitmap = Unit.masterHQBitmap;
							e.stopImmediatePropagation();
							this.addChild(placingBitmap);
							break;
						case Unit.TYPE_BARRACKS:
							drone = selected as Drone;
							constructionType = type;
							placingBitmap = Unit.masterBarracksBitmap;
							e.stopImmediatePropagation();
							this.addChild(placingBitmap);
							break;
					}
				}
			}
		}
		
		public var constructionType:int;
		
		public function droneBuild():void
		{
			if (!Game.smInstance.collidesWithOtherBuildings(placingBitmap.x- Game.smInstance.scrollOffsetX + placingBitmap.width/2, placingBitmap.width))
			{
			
				var drone:Drone = selected as Drone;
				drone.build(constructionType, placingBitmap.x - Game.smInstance.scrollOffsetX + placingBitmap.width/2);
				
				drone.unselectAll();
				Game.unitsSelected.length = 0;
			}
			this.removeChild(placingBitmap);	
			placingBitmap = null;
		}
		
		public function onMiniMapClick(e:MouseEvent):void
		{
			var x:Number =  (e.localX);
			Game.smInstance.scrollOffsetX = -((x / miniMap.width) * Game.smInstance.backGroundBitmap.width) + 160; 
		}	
		
		
		public function onOver(e:MouseEvent):void
		{
			var spr:Sprite = e.target as Sprite;
			for (var i:int = 0; i < buttons.length; i++)
			{
				if (buttons[i].spr == spr)
				{
					var but:Object = buttons[i];
					var t:int = but.type;
					var txt:TextField = info;
					switch(t)
					{
						case Unit.TYPE_DRONE:
							txt.text = "Build\nDrone\n\nMinerals:\n"+Drone.PRICE; 							
							break;
						case Unit.TYPE_HQ:
							txt.text = "Build\nHQ\n\nMinerals:\n"+HQ.PRICE; 						
							break;
						case Unit.TYPE_BARRACKS:
							txt.text = "Build\nBarracks\n\nMinerals:\n"+Barracks.PRICE; 						
							break;
						case Unit.TYPE_RAIDER:
							txt.text = "Train\nRaider\n\nMinerals:\n"+Raider.PRICE; 			 
							break;
						case Unit.TYPE_MARINE:
							txt.text = "Train\nMarine\n\nMinerals:\n"+Marine.PRICE; 			
							break;
						case Unit.TYPE_TANK:
							txt.text = "Train\nTank\n\nMinerals:\n"+Tank.PRICE; 			 
							break;
						
					}
				}
			}
		}
	}
}