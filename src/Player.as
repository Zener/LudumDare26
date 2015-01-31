package
{
	public class Player
	{
		public var minerals:int = 50;
		public var faction:int = 0;
		//private var myUnits:Vector.<Unit>;
		
		private var otherAttackingUnitsCount:int = 0;
		private var myAttackingUnitsCount:int = 0;
		private var otherDroneCount:int = 0;
		private var myDroneCount:int = 0;
		private var myBarracksCount:int = 0;
		private var otherBarracksCount:int = 0;
		private var myHQCount:int = 1;
		public var myUnitsCount:int = 2;
		
		public function Player(_faction:int)
		{
			faction = _faction;
			//myUnits = new Vector.<Unit>;
		}
		
		
		public function getPrice(type:int):int
		{
			var price:int = 1000;
			switch(type)
			{
				case -1: price = 0;break;
				case Unit.TYPE_HQ: price = HQ.PRICE; break;				
				case Unit.TYPE_BARRACKS: price = Barracks.PRICE; break;
				case Unit.TYPE_DRONE: price = Drone.PRICE; break;
				case Unit.TYPE_RAIDER: price = Raider.PRICE; break;			
				case Unit.TYPE_MARINE: price = Marine.PRICE; break;
				case Unit.TYPE_TANK: price = Tank.PRICE; break;
			}
			return price;
		}
		
		public function canPay(type:int):Boolean
		{	
			var price:int = getPrice(type);
			return minerals >= price;
		}
		
		
		public function pay(type:int):Boolean
		{
			if (canPay(type))
			{
				minerals -= getPrice(type);
				return true;
			}
			return false;
		}
		
		protected var wantToDoAWorker:Boolean = false;
		protected var wantToDoARaider:Boolean = false;
		protected var wantToDoATank:Boolean = false;
		protected var wantToDoAHQ:Boolean = false;
		protected var wantToDoABarracks:Boolean = false;
		protected var wantToDoAMarine:Boolean = false;
		protected var wantToDoRepair:Boolean = false;
		
		public function IA():void
		{
			//trace("IA");
			
			if (myDroneCount < 1 || myDroneCount <= otherDroneCount - handicapDrone)
			{ 
				wantToDoAWorker = true;
			}
			if (myBarracksCount < Math.max(otherBarracksCount, 1))
			{
				wantToDoABarracks = true;
			}
			if (myBarracksCount > 0 && myAttackingUnitsCount < otherAttackingUnitsCount - handicapDrone)
			{
				wantToDoAMarine = true;
				switch(int(Math.random()*3))
				{
					case 0: wantToDoAMarine = true;break;
					case 1: if (difficulty > 0) {wantToDoARaider = true;wantToDoAMarine = false;}break;
					case 2: if (difficulty > 1) {wantToDoATank = true;wantToDoAMarine = false;}break;
				}
			}
			
			wantToDoAHQ = myHQCount == 0;
		}
		
		public static var difficulty:int = 0;
		public static var handicapDrone:int = 0;		
		public static var iaDelay:int = 80;
		private var iaTicks:int = 0;
		
		public function logicUpdate():void
		{
			wantToDoAWorker = false;
			wantToDoARaider = false;
			wantToDoAHQ = false;
			wantToDoABarracks = false;
			wantToDoAMarine = false;
			wantToDoATank = false;
			wantToDoRepair = false;
			
			iaTicks--;
			if (iaTicks < 0)
			{
				IA();
				iaTicks = iaDelay;
			}
			
			// 	var u:Unit = getClosestUnitType(Unit.TYPE_HQ);
			var _otherAttackingUnitsCount:int = 0;
			var _myAttackingUnitsCount:int = 0;
			var _otherDroneCount:int = 0;
			var _myDroneCount:int = 0;
			var _myBarracksCount:int = 0;
			var _otherBarracksCount:int = 0;
			var _myHQCount:int = 0;
			
			
			
			//trace("AI Minerals: "+minerals);
			for (var i:int = 0; i < Game.units.length; i++)
			{
				
				var u:Unit = Game.units[i];
				//trace(i + " type: "+u.type + " " + u.faction);
				
				if (u.faction == faction)
				{
					switch(u.type)
					{
						case Unit.TYPE_DRONE:
							_myDroneCount++;
							switch (u.state)
							{
								case Unit.STATE_IDLE:									
										var mineralUnit:Unit = u.getClosestUnitType(Unit.TYPE_MINERALS);
										if (mineralUnit)
										{
											u.rightClick(mineralUnit.position.x, mineralUnit.position.y)
										}
									
									break;
							}
							
							if (wantToDoAHQ)
							{
								(u as Drone).build(Unit.TYPE_HQ, getXToPlace(Unit.TYPE_HQ));
								wantToDoAHQ = false;
							}
							if (wantToDoABarracks)
							{
								(u as Drone).build(Unit.TYPE_BARRACKS, getXToPlace(Unit.TYPE_BARRACKS));
								wantToDoABarracks = false;
							}
							break;
						case Unit.TYPE_HQ:
							_myHQCount++;
							if (wantToDoAWorker)
							{
								(u as HQ).build(Unit.TYPE_DRONE);
							}
							break;
						case Unit.TYPE_BARRACKS:
							if (wantToDoAMarine)
							{
								(u as Barracks).build(Unit.TYPE_MARINE);
							}
							if (wantToDoARaider)
							{
								(u as Barracks).build(Unit.TYPE_RAIDER);
							}
							if (wantToDoATank)
							{
								(u as Barracks).build(Unit.TYPE_TANK);
							}
							_myBarracksCount++;
							break;
					}
					if (!u.isABuilding)
					{
						_myAttackingUnitsCount++;						
					}
				}
				if (u.faction > 0 && u.faction != faction)
				{
					// ENENMY 
					switch(u.type)
					{
						case Unit.TYPE_DRONE:
							_otherDroneCount++;
							break;
						case Unit.TYPE_BARRACKS:
							_otherBarracksCount++;
							break;
					}
					if (!u.isABuilding)
					{
						_otherAttackingUnitsCount++;
					}
					
				}
			}
			
			
			
			
			otherAttackingUnitsCount = _otherAttackingUnitsCount;
			myAttackingUnitsCount = _myAttackingUnitsCount;
			myDroneCount = _myDroneCount;
			otherDroneCount = _otherDroneCount;
			myBarracksCount = _myBarracksCount;
			otherBarracksCount = _otherBarracksCount;
			myHQCount = _myHQCount;
		}
		
		
		public function getXToPlace(_type:int):int
		{
			var step:int = 20;
			var size:int;
			
			switch (_type)
			{
				case Unit.TYPE_HQ:
					size = Unit.masterHQBitmap.width;
					break;
				case Unit.TYPE_BARRACKS:
					size = Unit.masterBarracksBitmap.width;
					break;
			}
			
			var xToTry:int = (Game.smInstance.backGroundBitmap.width ) - size*3;
			var i:int=0;
			
			while(i < 30)
			{
				if (!Game.smInstance.collidesWithOtherBuildings(xToTry, size))
				{				
					return xToTry + size/2; 
				}
				xToTry -= step;
				i++;
			}
			return 960/2;
		}
	}
}