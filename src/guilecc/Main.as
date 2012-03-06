package guilecc
{
	import alternativa.engine3d.containers.BSPContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.Sorting;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import guilecc.som3d.sounds.sound3D.Sound3D;
	import guilecc.som3d.sounds.Sounds;
	
	/**
	 * ...
	 * @author GuileCC <guiccardoso@gmail.com>
	 */
	public class Main extends Sprite
	{
		
		public const DRUMS_ID:String = "drums";
		public const GUITAR_ID:String = "guitar";
		public const BASS_ID:String = "bass";
		
		public const DRUMS:String = "sounds/bateria.mp3";
		public const GUITAR:String = "sounds/guita.mp3";
		public const BASS:String = "sounds/baixo.mp3";
		
		[Embed(source = "../../bin/textures/1.png")]
		public var texture1:Class;
		
		[Embed(source = "../../bin/textures/2.png")]
		public var texture2:Class;
		
		[Embed(source = "../../bin/textures/3.png")]
		public var texture3:Class;
		
		private var _sounds:Sounds;
		
		private var _rootContainer:Object3DContainer = new BSPContainer();
		
		private var _camera:Camera3D;
		
		private var _goForward:Boolean;
		private var _goBackward:Boolean;
		private var _turnLeft:Boolean;
		private var _turnRight:Boolean;
		private var _cameraController:SimpleObjectController;
		private var _sound1:Sound3D;
		private var _sound2:Sound3D;
		private var _sound3:Sound3D;
		
		public function Main():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_sounds = new Sounds();
			_sounds.addSound(DRUMS_ID, DRUMS);
			_sounds.addSound(GUITAR_ID, GUITAR);
			_sounds.addSound(BASS_ID, BASS);
			
			_sounds.addEventListener(Event.COMPLETE, onSoundsComplete);
			_sounds.loadSounds();
		}
		
		private function onSoundsComplete(e:Event):void 
		{
			//_sounds.playAll();
			init3d();
			initObjects();
			initListeners();
		}
		
		private function init3d():void 
		{
			_camera = new Camera3D();
			_camera.view = new View(stage.width, stage.height);
			_camera.view.hideLogo();
			addChild(_camera.view);
			addChild(_camera.diagram);
			
			_cameraController = new SimpleObjectController(stage, _camera, 3000);
			_cameraController.setDefaultBindings();
			//_cameraController.bindKey(String("W").charCodeAt(), SimpleObjectController.ACTION_FORWARD);
			
			_rootContainer.addChild(_camera);
		}
		
		private function initObjects():void 
		{
			var box1:Box = new Box(500, 500, 500);
			box1.setMaterialToAllFaces(new FillMaterial(0xFF00CC,1,1,0x000000));
			box1.z = 2000;
			
			var box2:Box = new Box(500, 500, 500);
			box2.setMaterialToAllFaces(new FillMaterial(0xFF0000,1,1,0x000000));
			box2.z = -2000;
			box2.x = -2000;
			
			var box3:Box = new Box(500, 500, 500);
			box3.setMaterialToAllFaces(new FillMaterial(0x00FFCC,1,1,0x000000));
			box3.z = -2000;
			box3.x = 2000;
			
			var plane1:Plane = new Plane(1500, 1500);
			plane1.setMaterialToAllFaces(new TextureMaterial((new texture1() as Bitmap).bitmapData));
			
			var plane2:Plane = new Plane(1500, 1500);
			
			plane2.z = -1000;
			plane2.x = -1000;
			
			plane2.rotationY = 180;
			
			plane2.setMaterialToAllFaces(new TextureMaterial((new texture2() as Bitmap).bitmapData));
			
			var plane3:Plane = new Plane(1500, 1500);
			
			plane3.z = -1000;
			plane3.x = 1000;
			
			plane3.rotationY = -180;
			
			plane3.setMaterialToAllFaces(new TextureMaterial((new texture3() as Bitmap).bitmapData));
			
			_rootContainer.addChild(box1);
			
			_rootContainer.addChild(box2);
			
			_rootContainer.addChild(box3);
			
			_rootContainer.addChild(plane1);
			
			_rootContainer.addChild(plane2);
			
			_rootContainer.addChild(plane3);
			
			_sound1 = new Sound3D(box1, _camera, 5000, _sounds.getSoundById(DRUMS_ID));
			//_sound2 = new Sound3D(box2, _camera, 5000, _sounds.getSoundById(GUITAR_ID));
			//_sound3 = new Sound3D(box3, _camera, 5000, _sounds.getSoundById(BASS_ID));
			
			_sound1.play();
			//_sound2.play();
			//_sound3.play();
		}
		
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onEnterFrame( e:Event ):void
		{
			_camera.view.width = stage.stageWidth;
			_camera.view.height = stage.stageHeight;
			
			
			_sound1.update();
			//_sound2.update();
			//_sound3.update();
			
			_cameraController.update();
			
			_camera.render();
		}
		
		private function updateSound():void 
		{
			
		}
		
		private function onResize(event:Event = null):void
		{
			
		}
		
		private function getRandomColor():Number
		{
			return Math.floor(Math.random() * 16777215);
		}
	
	}

}