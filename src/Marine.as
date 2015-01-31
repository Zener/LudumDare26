package
{
	import flash.geom.Vector3D;

	public class Marine extends Unit
	{
		public static const PRICE:int = 75;
		
		public function Marine(_faction:int, _type:int)
		{
			super(_faction, _type);
			
			unitName = "Marine";			
			attackRange = 30;
			attackDamage = 5;
			attackCooldown = 20;
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