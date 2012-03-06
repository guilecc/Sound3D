package guilecc.som3d.sounds
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author GuileCC <guiccardoso@gmail.com>
	 */
	public class Sounds extends EventDispatcher
	{
		private var _soundsURLsToLoad:Vector.<String>;
		private var _urlsById:Dictionary;
		private var _soundById:Dictionary;
		private var _soundsToGo:int = 0;
		
		public function Sounds()
		{
			_soundsURLsToLoad = new Vector.<String>;
			_urlsById = new Dictionary();
			_soundById = new Dictionary();
		}
		
		public function addSound(id:String, url:String):void
		{
			_urlsById[id] = url;
		}
		
		public function loadSounds():void
		{
			for (var id:String in _urlsById)
			{
				_soundsToGo++;
				var sound:Sound = new Sound();
				sound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
				sound.load(new URLRequest(_urlsById[id] as String));
				_soundById[id] = sound;
			}
		}
		
		public function getSoundById(id:String):Sound
		{
			return _soundById[id] as Sound;
		}
		
		public function getAllSounds():Dictionary
		{
			return _soundById;
		}
		
		public function playAll():void
		{
			for each (var sound:Sound in _soundById)
			{
				sound.play();
			}
		}
		
		private function onSoundLoadComplete(e:Event):void
		{
			_soundsToGo--;
			if (_soundsToGo == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	
	}

}