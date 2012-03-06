package guilecc.som3d.sounds
{
	import flash.geom.Vector3D;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * The class represents a sound used in the demo.
	 */
	public class Sound3D {

		private var loaded:Boolean = false;
		
		private var coords:Vector3D;
		private var nearRadius:Number;
		private var farRadius:Number;
		private var maxVolume:Number;
		private var farDelimiter:Number;
		
		private var url:String;
		
		private var sound:Sound;
		private var channel:SoundChannel;
		private var transform:SoundTransform = new SoundTransform(0);
		
		private var volume:Number = 1;
		private var onLoadMethod:Function;
		
		/**
		 * The method calculates sound properties according to the relative position of sound source and an object.
		 * 
		 * @param objectCoords object's coordinates
		 * @param soundCoords sound source's coordinates
		 * @param normal right ear's normal of the object
		 * @param nearRadius inside near radius the sound has full strengh and panning is equal to zero. Outside the near radius the sound's strength is
		 *   dereased inversely proportional to square of the distance.
		 * @param farRadius at the far radius the sounds's strength is "delimiter" times less than full strength
		 * @param delimiter the coefficient shows how much times is the sound strength less at far radius than at near radius
		 * @param soundTransform calculated sound properties are stored here
		 */
		public static function getSoundProperties(objectCoords:Vector3D, soundCoords:Vector3D, normal:Vector3D, nearRadius:Number, farRadius:Number, delimiter:Number, soundTransform:SoundTransform):void {
			var vector:Vector3D = soundCoords.subtract(objectCoords);
			var len:Number = vector.length;
			if (len < nearRadius) {
				trace("NEAR ", len, nearRadius);
				// Within the near radius limits the sound strength is at maximum, panning equals zero
				soundTransform.volume = 1;
				soundTransform.pan = 0;
			} else {
				delimiter = Math.sqrt(delimiter);
				var k:Number = 1 + (delimiter - 1) * (len - nearRadius) / (farRadius - nearRadius);
				k *= k;
				trace("FAR ", k);
				soundTransform.volume = 1 / k;
				// Calculating sound panning
				vector.normalize();
				soundTransform.pan = vector.dotProduct(normal) * (1 - 1 / k);
			}				
		}
		
		/**
		 * The constructor creates a new instance of the classs.
		 * 
		 * @param coords coordinates of the sound
		 * @param near Near radius. Inside near radius the sound has full strengh and panning is equal to zero. Outside the near radius the sound's strength is
		 *   dereased inversely proportional to square of the distance.
		 * @param far Far radius. At the far radius the sounds's strength is "delimiter" times less than full strength
		 * @param delimiter the coefficient shows how much times is the sound strength less at far radius than at near radius
		 * @param url URL URL of the sound file 
		 * @param info status string
		 * @param multiplier maximum sound strength
		 */
		public function Sound3D(coords:Vector3D, near:Number, far:Number, delimiter:Number, sound:Sound, maxVolume:Number = 1) {
			this.coords = coords.clone();
			this.nearRadius = near;
			this.farRadius = far;
			farDelimiter = delimiter;
			this.sound = sound;
			this.maxVolume = maxVolume;
		}
		
		
		
		public function play():void
		{
			this.channel = sound.play(0, 999);
			loaded = true;
		}
		
		/**
		 * The method sets new sound properties according to the relative position of the sound source and the given object.
		 * 
		 * @param coords the object's coordinates
		 * @param normal right ear's normal of the object
		 */
		public function checkVolume(coords:Vector3D, normal:Vector3D):void {
			if (loaded)
			{
				var v:Number = transform.volume;
				getSoundProperties(coords, this.coords, normal, nearRadius, farRadius, farDelimiter, transform);
				volume = transform.volume * maxVolume;
				
				transform.volume = volume;
				channel.soundTransform = transform;
				
			}
			
			
		}
	}
}