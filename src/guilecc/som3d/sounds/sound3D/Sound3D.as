package guilecc.som3d.sounds.sound3D
{
	import alternativa.engine3d.core.Object3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author GuileCC <guiccardoso@gmail.com>
	 */
	public class Sound3D
	{
		private var _source:Object3D;
		
		private var _listener:Object3D;
		
		private var _far:Number;
		
		private var _sound:Sound;
		
		private var _channel:SoundChannel;
		
		private var _refv:Vector3D;
		
		private var _inv_ref_mtx:Matrix3D;
		
		public function Sound3D(source:Object3D, listener:Object3D, far:Number, sound:Sound)
		{
			_source = source;
			_listener = listener;
			_far = far;
			_sound = sound;
			_inv_ref_mtx = new Matrix3D;
		}
		
		public function play():void
		{
			_channel = _sound.play(0, 999);
		}
		
		public function update():void
		{
			if (_channel)
			{
				var transform:SoundTransform = _channel.soundTransform;
				var distance:Number = Vector3D.distance(_source.matrix.position, _listener.matrix.position);
				transform.volume = distance > _far ? 0 : 1 - distance / _far;
				
				var product:Vector3D = _source.matrix.position.crossProduct(_listener.matrix.position);
				
				trace(product.length);
				//transform.pan = product * ();
				
				
				_channel.soundTransform = transform;
			}
		}
	
	}

}