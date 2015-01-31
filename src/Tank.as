package
{
	import flash.geom.Vector3D;

	public class Tank extends Unit
	{
		public static const PRICE:int = 250;
		
		public function Tank(_faction:int, _type:int)
		{
			super(_faction, _type);
			
			unitName = "Tank";			
			attackRange = 60;
			attackDamage = 25;0
			attackCooldown = 130;
			speed = 0.25;
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