package
{
	import flash.geom.Vector3D;

	public class Drone extends Unit
	{
		public static const PRICE:int = 40;
		
		public static const STATE_BUILDING_BUILDING:int = -2;
		public var targetMineral:Unit = null;
		public var targetBuilding:Unit = null;
		
		public function Drone(_faction:int, _type:int)
		{
			super(_faction, _type);
			
			unitName = "Drone";
			
			attackRange = 14;			
			attackDamage = 2;
		}
		
		
		public override function logicUpdate():void
		{
			switch(state)
			{
				case STATE_BUILDING_BUILDING:
					if (distanceToPosX(targetBuilding.position.x) < 10)
					{
						if (targetBuilding && targetBuilding.energy > 0 && targetBuilding.buildingPercent < 100)
						{
							targetBuilding.buildingPercent += 0.1;
							targetPosition.x = targetBuilding.position.x + (Math.random()*9) - (Math.random()*9);
						}
						else
						{
							state = STATE_IDLE;
						}
					}
					break;
				case STATE_ATTACKING:
					defaultAttack();					
					break;
				case STATE_GO_MINING:
					if (distanceToPosX(targetPosition.x) < 10)
					{
						state = STATE_MINING;
						tick = 0;
					}
					break;
				case STATE_MINING:
					if (tick > 200)
					{						
						var u:Unit = getClosestUnitType(Unit.TYPE_HQ);
						if (u)
						{
							state = STATE_GO_TO_HQ;
							targetPosition.x = u.position.x;
						}
						else
						{
							state = 0;
						}
					}
					break;
				case STATE_GO_TO_HQ:
					if (distanceToPosX(targetPosition.x) < 10)
					{
						Game.players[faction].minerals += 20;
						state = STATE_GO_MINING;
						targetPosition.x = targetMineral.position.x;
					}
					break;
			}
							
			super.logicUpdate();
		}
		
		
		public override function rightClick(_x:int, _y:int):void
		{
			targetPosition = new Vector3D( _x, _y);
			state = STATE_IDLE;
			
			for (var i:int = 0; i < Game.units.length; i++)
			{				
				if (Game.units[i].distanceToPosX(_x) < 10)
				{
					
					if (Game.units[i].type == TYPE_MINERALS )
					{
						targetMineral = Game.units[i];	
						state = STATE_GO_MINING;
					}
					if (Game.units[i].faction == faction && Game.units[i].isABuilding && Game.units[i].buildingPercent < 100  )
					{
						targetBuilding = Game.units[i];	
						state = STATE_BUILDING_BUILDING;
					}
					if (Game.units[i].faction > 0 && Game.units[i].faction != faction )
					{
						targetUnit = Game.units[i];	
						state = STATE_ATTACKING;
					}
				}
			}
		}
		
		
		
		
		
		
		public function build(_type:int, _x:int):void
		{
			if (Game.players[faction].pay(_type))
			{
				
				state = STATE_BUILDING_BUILDING;
				tick = 0;
				constructionType = _type;
				
				var u:Unit = Game.smInstance.addUnit(faction, constructionType);
				u.setPosition(_x, Game.GROUND_Y);
				u.buildingPercent = 1;
				
				targetBuilding = u;
				targetPosition = new Vector3D(_x, Game.GROUND_Y);
				
				
			}
		}
	}
}