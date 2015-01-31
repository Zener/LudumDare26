package
{
	
	///////////////////////////////////////////////////////////////////////////////////////////
	// Minimal Annihilation
	// Evolution game for Ludum Dare
	// Author: Carlos Peris
	// Date: 28/04/2013
	///////////////////////////////////////////////////////////////////////////////////////////
	
	import flash.display.Sprite;
	
	
	
	[SWF(width="960", height="720", frameRate="60", backgroundColor="#ffffff", allowScriptAccess="always", allowFullScreen="true")]
	public class MinimalAnnihilation extends Sprite
	{
	

		
		public function MinimalAnnihilation()
		{
			this.addChild(new Menu());
		}
	}
}