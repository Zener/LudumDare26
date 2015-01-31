package
{
	public class Barracks extends Unit
	{
		public static const PRICE:int = 125;
		public static const STATE_BUILDING_UNIT:int = 1;
		public static const TICKS_TO_BUILD:int = 500;
		
		public function Barracks(_faction:int, _type:int)
		{
			super(_faction, _type);
			
			unitName = "Barracks";
			
		}
		
		
		public override function logicUpdate():void
		{
			switch(state)
			{
				case STATE_BUILDING_UNIT:
					constructionPercent = tick / getTicksToBuild(constructionType);//TICKS_TO_BUILD;
					if (tick > getTicksToBuild(constructionType))
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
		
		public function getTicksToBuild(t:int):int
		{
			switch (t)
			{
				case Unit.TYPE_MARINE: return 350;
				case Unit.TYPE_RAIDER: return 500;
				case Unit.TYPE_TANK: return 750;
			}
			return TICKS_TO_BUILD;
		}
	}
}