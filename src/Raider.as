package
{
	import flash.geom.Vector3D;

	public class Raider extends Unit
	{
		public static const PRICE:int = 150;
		
		public function Raider(_faction:int, _type:int)
		{
			super(_faction, _type);
			
			unitName = "Raider";			
			attackRange = 50;
			attackDamage = 10;
			attackCooldown = 50;
		}
		
		
		public override function logicUpdate():void
		{
			switch(state)
			{
				case STATE_IDLE:
					var u:Unit = searchClosestEnemy();
					if (u)
					{
						targetUnit = u;
						targetPosition = new Vector3D(targetUnit.x, targetUnit.y);
						state = STATE_ATTACKING;
					}
					break;
				case STATE_ATTACKING:
					defaultAttack();					
					break;
			}
			super.logicUpdate();
		}
	}
}