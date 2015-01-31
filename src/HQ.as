package
{
	public class HQ extends Unit
	{
		public static const PRICE:int = 400;
		public static const STATE_BUILDING_UNIT:int = 1;
		public static const TICKS_TO_BUILD:int = 400;
		
	
		
		public function HQ(_faction:int, _type:int)
		{			
			super(_faction, _type);
			unitName = "HQ";
			price = 400;
		}
		
		public override function logicUpdate():void
		{
			switch(state)
			{
				case STATE_BUILDING_UNIT:
					constructionPercent = tick / TICKS_TO_BUILD;
					if (tick > TICKS_TO_BUILD)
					{
						var newUnit:Unit = Game.smInstance.addUnit(faction, constructionType);
						newUnit.setPosition(position.x, Game.GROUND_Y);
						state = STATE_IDLE;
						constructionPercent = 0;
					}
					break;
			}
			super.logicUpdate();
		}
		
		public function build(type:int):void
		{
			if (state == STATE_BUILDING_UNIT) return;
			if (buildingPercent < 100) return;
			
			if (Game.players[faction].pay(type))
			{
			
				state = STATE_BUILDING_UNIT;
				tick = 0;
				constructionType = type;
			}
		}
		
	}
}