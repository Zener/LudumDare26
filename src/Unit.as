package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	public class Unit extends Sprite
	{
		///////////////////////////////////////////////////////////////////////////////////////////
		// Minimal Annihilation
		// Evolution game for Ludum Dare
		// Author: Carlos Peris
		// Date: 28/04/2013
		///////////////////////////////////////////////////////////////////////////////////////////
		public static const TYPE_DEFAULT:int = 0;
		public static const TYPE_RESOURCE:int = 1;
		public static const TYPE_BUILDING:int = 2;
		
		public static const TYPE_DRONE:int = 1;
		public static const TYPE_MINERALS:int = 2;
		public static const TYPE_HQ:int = 3;
		public static const TYPE_RAIDER:int = 4;
		public static const TYPE_BARRACKS:int = 5;
		public static const TYPE_MARINE:int = 6;
		public static const TYPE_TANK:int = 7;
		
		public static const STATE_ATTACKING:int = -1;
		public static const STATE_IDLE:int = 0;
		public static const STATE_GO_MINING:int = 1;
		public static const STATE_MINING:int = 2;
		public static const STATE_GO_TO_HQ:int = 3;
		
		public static const CORNER_TOP_LEFT_X:int = -10;
		public static const CORNER_TOP_LEFT_Y:int = -10;
		public static const CORNER_BOTTOM_LEFT_Y:int = 0;
		public static const CORNER_TOP_RIGHT_X:int = 10;
		
		public var type:int;
		public var faction:int;
		public var state:int;
		public var gfx:Bitmap;
		public var gfx_walk:Bitmap;
		public var gfx_attack:Bitmap;
		public var selectionSprite:Sprite;
		public var selected:Boolean;
		public var isABuilding:Boolean = false;
		public var constructionPercent:Number;
		
		public var buildingPercent:Number = 100;
		public var speed:Number = 0.5;
		public var energy:int;
		public var maxEnergy:int;

		public var position:Vector3D;
		public var energyBar:FillBar;
		
		public var targetPosition:Vector3D;
		public var tick:int = 0;
		public var targetUnit:Unit = null;
		public var attackRange:int = 10;
		public var attackDamage:int = 0;
		public var attackCooldown:int = 15;
		public var attackCooldownCounter:int = 0;
		public var constructionType:int;
		public var unitName:String = "XXX";
		public var price:int = 0;
		
		public static var masterHQBitmap:Bitmap;
		public static var masterDroneBitmap:Bitmap;
		public static var masterDroneAttackBitmap:Bitmap;
		public static var masterRaiderBitmap:Bitmap;
		public static var masterRaiderWalkBitmap:Bitmap;
		public static var masterRaiderAttackBitmap:Bitmap;
		public static var masterMineralBitmap:Bitmap;
		public static var masterBarracksBitmap:Bitmap;
		public static var masterMarineBitmap:Bitmap;
		public static var masterMarineWalkBitmap:Bitmap;
		public static var masterMarineAttackBitmap:Bitmap;		
		public static var masterTankBitmap:Bitmap;
		public static var masterTankAttackBitmap:Bitmap;
		
		public static var masterHQBitmap2:Bitmap;
		public static var masterDroneBitmap2:Bitmap;
		public static var masterDroneAttackBitmap2:Bitmap;
		public static var masterRaiderBitmap2:Bitmap;
		public static var masterRaiderWalkBitmap2:Bitmap;
		public static var masterRaiderAttackBitmap2:Bitmap;
		public static var masterMineralBitmap2:Bitmap;
		public static var masterBarracksBitmap2:Bitmap;
		public static var masterMarineBitmap2:Bitmap;
		public static var masterMarineWalkBitmap2:Bitmap;
		public static var masterMarineAttackBitmap2:Bitmap;
		public static var masterTankBitmap2:Bitmap;
		public static var masterTankAttackBitmap2:Bitmap;
		
		
		[Embed (source="data/img/hq.png" )]
		public static const hqClass:Class;
		
		[Embed (source="data/img/drone.png" )]
		public static const droneClass:Class;
		[Embed (source="data/img/drone_attack.png" )]
		public static const droneAttackClass:Class;
		
		[Embed (source="data/img/raider.png" )]
		public static const raiderClass:Class;
		[Embed (source="data/img/raider_walk.png" )]
		public static const raiderWalkClass:Class;
		[Embed (source="data/img/raider_attack.png" )]
		public static const raiderAttackClass:Class;
		
		
		[Embed (source="data/img/mineral.png" )]
		public static const mineralClass:Class;
		
		[Embed (source="data/img/barracks.png" )]
		public static const barracksClass:Class;
		
		[Embed (source="data/img/marine.png" )]
		public static const marineClass:Class;
		[Embed (source="data/img/marine_walk.png" )]
		public static const marineWalkClass:Class;
		[Embed (source="data/img/marine_attack.png" )]
		public static const marineAttackClass:Class;
		
		
		[Embed (source="data/img/tank.png" )]
		public static const tankClass:Class;
		[Embed (source="data/img/tank_attack.png" )]
		public static const tankAttackClass:Class;
		
		public static function loadResources():void
		{
			masterHQBitmap = new hqClass();
			masterDroneBitmap = new droneClass();
			masterDroneAttackBitmap = new droneAttackClass();
			masterRaiderBitmap = new raiderClass();
			masterRaiderWalkBitmap = new raiderWalkClass();
			masterRaiderAttackBitmap = new raiderAttackClass();
			masterMineralBitmap = new mineralClass();
			masterBarracksBitmap = new barracksClass();
			masterMarineBitmap = new marineClass();
			masterMarineWalkBitmap = new marineWalkClass();
			masterMarineAttackBitmap = new marineAttackClass();
			masterTankBitmap = new tankClass();
			masterTankAttackBitmap = new tankAttackClass();
			
			masterHQBitmap2= new hqClass();
			masterDroneBitmap2 = new droneClass();
			masterDroneAttackBitmap2 = new droneAttackClass();
			masterRaiderBitmap2 = new raiderClass();
			masterRaiderWalkBitmap2 = new raiderWalkClass();
			masterRaiderAttackBitmap2 = new raiderAttackClass();
			masterBarracksBitmap2 = new barracksClass();
			masterMarineBitmap2 = new marineClass();
			masterMarineWalkBitmap2 = new marineWalkClass();
			masterMarineAttackBitmap2 = new marineAttackClass();
			masterTankBitmap2 = new tankClass();
			masterTankAttackBitmap2 = new tankAttackClass();
			
			
			var invertTransform:ColorTransform = new ColorTransform(-1,-1,-1,1,255,255,255,0);
			masterHQBitmap2.bitmapData.colorTransform(masterHQBitmap2.bitmapData.rect, invertTransform);
			masterDroneBitmap2.bitmapData.colorTransform(masterDroneBitmap2.bitmapData.rect, invertTransform);
			masterDroneAttackBitmap2.bitmapData.colorTransform(masterDroneAttackBitmap2.bitmapData.rect, invertTransform);
			masterRaiderBitmap2.bitmapData.colorTransform(masterRaiderBitmap2.bitmapData.rect, invertTransform);
			masterRaiderWalkBitmap2.bitmapData.colorTransform(masterRaiderWalkBitmap2.bitmapData.rect, invertTransform);
			masterRaiderAttackBitmap2.bitmapData.colorTransform(masterRaiderAttackBitmap2.bitmapData.rect, invertTransform);
			masterBarracksBitmap2.bitmapData.colorTransform(masterBarracksBitmap2.bitmapData.rect, invertTransform);
			masterMarineBitmap2.bitmapData.colorTransform(masterMarineBitmap2.bitmapData.rect, invertTransform);
			masterMarineWalkBitmap2.bitmapData.colorTransform(masterMarineWalkBitmap2.bitmapData.rect, invertTransform);
			masterMarineAttackBitmap2.bitmapData.colorTransform(masterMarineAttackBitmap2.bitmapData.rect, invertTransform);			
			masterTankBitmap2.bitmapData.colorTransform(masterTankBitmap2.bitmapData.rect, invertTransform);
			masterTankAttackBitmap2.bitmapData.colorTransform(masterTankAttackBitmap2.bitmapData.rect, invertTransform);
		}
		
		public function Unit(_faction:int, _type:int)
		{
			super();
			//mouseChildren = false;
			faction = _faction;
			type = _type;
			position = new Vector3D();
			constructionPercent = 0;
			
			switch(type)
			{
				case TYPE_MINERALS:
					gfx = new Bitmap(masterMineralBitmap.bitmapData);
					maxEnergy = 1500;
					isABuilding = true;
					break;				
				case TYPE_HQ:
					if (faction <= 1)
						gfx = new Bitmap(masterHQBitmap.bitmapData);
					else
						gfx = new Bitmap(masterHQBitmap2.bitmapData);
					maxEnergy = 1500;
					isABuilding = true;
					break;
				case TYPE_DRONE:
					if (faction <= 1)
					{
						gfx = new Bitmap(masterDroneBitmap.bitmapData);
						gfx_attack = new Bitmap(masterDroneAttackBitmap.bitmapData);
					}
					else
					{
						gfx = new Bitmap(masterDroneBitmap2.bitmapData);
						gfx_attack = new Bitmap(masterDroneAttackBitmap2.bitmapData);
					}
					maxEnergy = 60;
					break;
				case TYPE_RAIDER:
					if (faction <= 1)
					{
						gfx = new Bitmap(masterRaiderBitmap.bitmapData);
						gfx_walk = new Bitmap(masterRaiderWalkBitmap.bitmapData);
						gfx_attack = new Bitmap(masterRaiderAttackBitmap.bitmapData);
					}
					else
					{
						gfx = new Bitmap(masterRaiderBitmap2.bitmapData);
						gfx_walk = new Bitmap(masterRaiderWalkBitmap2.bitmapData);
						gfx_attack = new Bitmap(masterRaiderAttackBitmap2.bitmapData);
					}
					maxEnergy = 150;
					break;
				case TYPE_TANK:
					if (faction <= 1)
					{
						gfx = new Bitmap(masterTankBitmap.bitmapData);						
						gfx_attack = new Bitmap(masterTankAttackBitmap.bitmapData);
					}
					else
					{
						gfx = new Bitmap(masterTankBitmap2.bitmapData);
						gfx_attack = new Bitmap(masterTankAttackBitmap2.bitmapData);
					}
					maxEnergy = 350;
					break;
				case TYPE_MARINE:
					if (faction <= 1)
					{
						gfx = new Bitmap(masterMarineBitmap.bitmapData);
						gfx_walk = new Bitmap(masterMarineWalkBitmap.bitmapData);
						gfx_attack = new Bitmap(masterMarineAttackBitmap.bitmapData);
					}
					else
					{
						gfx = new Bitmap(masterMarineBitmap2.bitmapData);
						gfx_walk = new Bitmap(masterMarineWalkBitmap2.bitmapData);
						gfx_attack = new Bitmap(masterMarineAttackBitmap2.bitmapData);
					}
					maxEnergy = 60;
					break;
				case TYPE_BARRACKS:
					if (faction <= 1)
						gfx = new Bitmap(masterBarracksBitmap.bitmapData);
					else
						gfx = new Bitmap(masterBarracksBitmap2.bitmapData);
					maxEnergy = 1000;
					isABuilding = true;
					break;
			}
			
			energy = maxEnergy;
			
			
			
			if (gfx) this.addChild(gfx);
			
			x = -gfx.width/2;
			y = -gfx.height;
			
			if (gfx_walk)
			{
				this.addChild(gfx_walk);
				gfx_walk.visible = false;
			}
				
			if (gfx_attack)
			{
				this.addChild(gfx_attack);
				gfx_attack.visible = false;
			}
			
			energyBar = new FillBar(gfx.width,5);
			this.addChild(energyBar);
			
			selectionSprite = new Sprite();
			var s:Sprite = selectionSprite;
			var startX:int = -width/2;
			
			s.graphics.lineStyle(1,0);			
			s.graphics.moveTo(startX+CORNER_TOP_LEFT_X+10, CORNER_TOP_LEFT_Y);
			s.graphics.lineTo(startX+CORNER_TOP_LEFT_X, CORNER_TOP_LEFT_Y);
			s.graphics.lineTo(startX+CORNER_TOP_LEFT_X, CORNER_TOP_LEFT_Y+10);
			
			s.graphics.moveTo(startX+CORNER_TOP_LEFT_X+10, height+CORNER_BOTTOM_LEFT_Y);
			s.graphics.lineTo(startX+CORNER_TOP_LEFT_X, height+CORNER_BOTTOM_LEFT_Y);
			s.graphics.lineTo(startX+CORNER_TOP_LEFT_X, height+CORNER_BOTTOM_LEFT_Y-10);
			
			s.graphics.moveTo(startX+width+CORNER_TOP_RIGHT_X-10, CORNER_TOP_LEFT_Y);
			s.graphics.lineTo(startX+width+CORNER_TOP_RIGHT_X, CORNER_TOP_LEFT_Y);
			s.graphics.lineTo(startX+width+CORNER_TOP_RIGHT_X, CORNER_TOP_LEFT_X+10);
			
			s.graphics.moveTo(startX+width+CORNER_TOP_RIGHT_X-10, height+CORNER_BOTTOM_LEFT_Y);
			s.graphics.lineTo(startX+width+CORNER_TOP_RIGHT_X, height+CORNER_BOTTOM_LEFT_Y);
			s.graphics.lineTo(startX+width+CORNER_TOP_RIGHT_X, height+CORNER_BOTTOM_LEFT_Y-10);
			
			s.x = width/2;
			this.addChild(s);
			
			this.addEventListener(MouseEvent.CLICK, onClick);			
		}
		
		
		public function setPosition(_x:Number, _y:Number):void
		{
			position.x = _x;
			position.y = _y;
		}

		
		public function logicUpdate():void
		{
			tick++;
			alpha = Math.max(buildingPercent / 100, 0.1);
			//if (buildingPercent < 100) return;
			if (energy <= 0) 
			{
				state=-1000;
				targetPosition=null;
				alpha=0.2;
			}
			
			if (targetPosition)
			{
				if (targetPosition.x < position.x)
				{
					position.x -= speed;
					gfx.scaleX = -1;
					updateFrame("Walk");
				}
				if (targetPosition.x > position.x)
				{
					position.x += speed;
					gfx.scaleX = 1;
					updateFrame("Walk");
				}
				
			}
			
			
			x = position.x - (gfx.width/2);
			if (gfx.scaleX > 0)
			{
				gfx.x = 0;
				if (gfx_walk) gfx_walk.x = 0;
				if (gfx_attack) gfx_attack.x = 0;
			}
			else
			{
				gfx.x = gfx.width;
				if (gfx_walk) gfx_walk.x = gfx.width;
				if (gfx_attack) gfx_attack.x = gfx.width;
			}
			y = position.y - gfx.height;
			
			//trace("x: "+x+"y: "+y);
			if (buildingPercent < 100)
			{
				energyBar.setPercentage(buildingPercent/100);
				energyBar.alpha = 20.0;
			}
			else
			{
				energyBar.setPercentage(energy/maxEnergy);
				energyBar.visible = energy < maxEnergy;
			}
			
			if (selected)
			{
				selectionSprite.visible = true;
				selectionSprite.scaleX = 1 + Math.sin(tick/8.0) * 0.05;
				selectionSprite.scaleY = selectionSprite.scaleX;
			}
			else
			{
				selectionSprite.visible = false;			
			}
			
		}
		
		public function onClick(e:MouseEvent):void
		{
			if (Game.unitsSelected.length > 0)
			{
				Game.smInstance.onRightClick(e);
			}
			unselectAll();
			selected = true;
			Game.hud.updateHUD(this);
			SfxManager.getInstance().playSound("click", 0);
		}
		
		
		public function distanceToPosX(_x:int):int
		{
			return Math.abs(_x - position.x);
		}
		
		public function unselectAll():void
		{
			for (var i:int = 0; i < Game.units.length;i++)
			{
				Game.units[i].selected = false;
			}
			
			Game.unitsSelected.length = 0;
			Game.unitsSelected.push(this);
		}
		
		public function rightClick(_x:int, _y:int):void
		{
			targetPosition = new Vector3D( _x, _y);
		}
		
		public function defaultAttack():void
		{
			if (distanceToPosX(targetUnit.position.x) < attackRange)
			{
				attackCooldownCounter--;
				if (attackCooldownCounter <= 0)
				{
					attackCooldownCounter = attackCooldown;					
					targetUnit.hit(attackDamage);
					updateFrame("Attack");
				}	
				targetPosition = null;
			}
			else
			{
				targetPosition = new Vector3D(targetUnit.position.x, targetUnit.position.y);
			}
			if (!targetUnit || targetUnit.energy < 0)
			{
				state = STATE_IDLE;
			}
		}
		
		public function hit(damage:int):void
		{
			energy -= damage;	
			
			if (buildingPercent < 100)
			{
				buildingPercent -= damage;
				if (buildingPercent < 0) energy = -1;
			}
			
			if (attackDamage > 0)
			{
				var u:Unit = searchClosestEnemy();
				if (u)
				{
					targetUnit = u;
					targetPosition = new Vector3D(targetUnit.x, targetUnit.y);
					state = STATE_ATTACKING;
				}
			}
		}
		
		
		
		public function searchClosestEnemy():Unit
		{
			var minDistance:int = 100000000;
			var closest:Unit = null;
			for (var i:int = 0; i < Game.units.length;i++)
			{
				var u:Unit = Game.units[i]; 
				var d:int = Math.abs(u.position.x - position.x);
				if (u.faction > 0 && u.energy > 0 && u.faction != faction && d < minDistance )
				{
					minDistance = d;
					closest = u;
				}		
			}
			return closest;
		}
		
		
		
		public function getClosestUnitType(_type:int):Unit
		{
			var minDistance:int = 1000000000;
			var u:Unit;
			for (var i:int = 0; i < Game.units.length; i++)
			{	
				if ((Game.units[i].faction == faction || Game.units[i].faction == 0) && Game.units[i].type == _type)
				{
					var d:int = Game.units[i].distanceToPosX(position.x);
					if (d < minDistance)
					{
						minDistance = d;
						u = Game.units[i];
					}
				}
			}
			
			return u;
		}
		
		private var attackFrameCooldown:int = 0;
		
		public function updateFrame(s:String):void
		{
			
						
			switch(s)
			{
				case "Walk":
					if (gfx_walk)
					{
						gfx.visible = (tick%16 < 8);
						gfx_walk.visible = (tick%16 >= 8);
						gfx_walk.scaleX = gfx.scaleX;
					}					
					if (gfx_attack) gfx_attack.visible = false;
					break;
				case "Attack":
					if (gfx_attack)
					{
						attackFrameCooldown = 5;
						gfx_attack.visible = true;
						gfx_attack.scaleX = gfx.scaleX;
						gfx.visible = false;
						if (gfx_walk) gfx_walk.visible = false;						
					}
					break;
				default:
					if (attackFrameCooldown <= 0)
					{
						gfx.visible = true;
						if (gfx_walk) gfx_walk.visible = false;
						if (gfx_attack) gfx_attack.visible = false;
					}
					else
					{
						attackFrameCooldown--;
						gfx_attack.visible = true;
						gfx_attack.scaleX = gfx.scaleX;
						gfx.visible = false;
						if (gfx_walk) gfx_walk.visible = false;		
					}
					break;
			}
		}
	}
}