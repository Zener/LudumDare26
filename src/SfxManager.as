package{
	
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	

	public class SfxManager
	{
		private static var mInstance:SfxManager;
		private var mSoundsDictionary:Dictionary;
		private var mSounds:Array;
		
		public function SfxManager()
		{			
			
			mSoundsDictionary = new Dictionary(true);
			mSounds = new Array();
			
		}
		
		
		public static function getInstance():SfxManager
		{
			if( SfxManager.mInstance == null )
			{			
				SfxManager.mInstance = new SfxManager();			
			}
			return SfxManager.mInstance;
		}
		
		
		
	
		public function loadSound( path:String, name:String, type:int = 1):Boolean
		{
			var snd:Sound = new Sound( new URLRequest( path ), new SoundLoaderContext( 1000, false) );
			createSound( snd, name, type );
			
			return true;
		}
		
		
		private function createSound( snd:Sound, name:String, type:int ):void
		{
			var soundObject:Object = new Object();
			soundObject.name = name;
			soundObject.sound = snd;
			soundObject.channel = new SoundChannel();
			soundObject.position = 0;
			soundObject.paused = false;
			soundObject.stopped = true;
			soundObject.volume = 1;
			soundObject.startTime = 0;
			soundObject.loops = 0;		
			soundObject.length = 0;
			mSoundsDictionary[name] = soundObject;
			mSounds.push(soundObject);
		}
		
		
		
		
		public function soundExists( name:String ):Boolean
		{
			return mSoundsDictionary[name] != null;
		}
		
		
		public function playSound(name:String, loops:int = 0, volume:Number = 1):void
		{
			//return;
			var soundObject:Object = mSoundsDictionary[ name ];
			
			
			soundObject.volume = volume;
			soundObject.loops = loops;
			

			soundObject.channel = soundObject.sound.play(0, soundObject.loops, new SoundTransform(volume));						
				
			soundObject.stopped = false;
			
			
			if (soundObject.channel != null)
			{
				if(loops < 0)
				{
					soundObject.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				}
			}
				
		}
		
		
		
		private function soundCompleteHandler(event:Event):void 
		{
			for each(var object:Object in mSoundsDictionary)
			{
				var channel:SoundChannel = object.channel as SoundChannel;
				var targetChannel:SoundChannel = event.target as SoundChannel;
				
				if(targetChannel == channel)
				{
					targetChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					
					object.channel = object.sound.play( object.position, object.loops, new SoundTransform(object.volume) );					
					object.length = object.sound.length;
					
					if(object.channel != null)
					{
						object.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);				
					}
				}
			}
		}
		
		
	
		
				
	}
}