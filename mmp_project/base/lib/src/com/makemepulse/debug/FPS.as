
/**
 * Written by :
 * @author Floz - Florian Zumbrunn
 * www.floz.fr || www.minuit4.fr
 * 
 * Version log :
 * 
 * 05.09.10		2.01	Arno		+ Bouton pour le garbage collector
 * 11.07.10		2.0		Floz		+ Réecriture complète
 * 									+ Suppression des events ACTIVATE et DEACTIVATE
 * 									+ Changement de technique pour calculer les FPS (même technique que celui de MrDoob)
 * 19.04.10		1.1		David Ronai + Ajout des bouttons + et - pour gérer le framerate
 * 11.07.09		1.0		Floz		+ Correction de quelques morceaux de codes.
 * 									+ Ajout d'une valeur "moyenne" des fps.
 * 									+ Ajout d'une courbe représentative de la moyenne des fps.
 * 07.05.09		0.5		Floz		+ Ajout d'un parametre dans le constructeur pour rendre partiellement visible l'outil
 * 24.03.09		0.4		Floz		+ Courbe supplémentaire pour les millisecondes
 * 08.03.09		0.3		Floz		+ Possibilité de déplacer le composant, et de cacher/afficher le graphique.
 * 08.03.09		0.2		Floz		+ Refonte pour ajout d'un graphique de performances
 * 28.08.08		0.1		Floz		+ Première version
 */
package com.makemepulse.debug
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class FPS extends Sprite
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		private const MEM_MAX:int = 500;
		private const MS_MAX:int = 200;
		
		private var _width:Number;
		private var _height:Number;
		private var _expand:Boolean;
		private var _scroll:int;
		
		private var _cntTitle:Sprite;
		private var _cntGraph:Sprite;
		private var _cntBts:Sprite;
		private var _btPlus:FPSButton;
		private var _btMinus:FPSButton;
		private var _btGC:FPSButton;
		private var _curves:BitmapData;
		private var _rect:Rectangle;
		
		private var _timerChangeFPS:Timer;
		
		private var _prevFps:int;
		private var _prevMem:int;
		private var _prevMoy:int;
		private var _prevMs:int;
		
		private var _fps:int;
		private var _mem:int;
		private var _moy:int;
		private var _ms:int;
		
		private var _moyValue:int;
		private var _moyTick:int;
		private var _moyRefresh:int = 10;
		
		private var _cntTexts:Sprite;
		private var _tfFps:TextField;
		private var _tfMem:TextField;
		private var _tfMoy:TextField;
		private var _tfMs:TextField;
		
		private var _running:Boolean;
		
		private var _prevTime:int;
		private var _prevIntervalTime:int;
		private var _currentTime:int;
		private var _ticks:int;
		
		private var _diffFps:int;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		/**
		 * Instancie un nouvel objet FPS.
		 * - FPS correspond au nombre d'image par secondes
		 * - MEM correspond à la mémoire physique utilisée par l'application (en mo)
		 * - MS correspond au nombre de millisecondes écoulées entre deux ticks de ENTER_FRAME.
		 * Chaque secondes, les paramètres principaux seront mis à jour.
		 * @param	width	Number	La largeur de l'outil.
		 * @param	height	Number	La hauteur de l'outil.
		 * @param	expand	Boolean	Fermé si false, ouvert si true.
		 * @param	scroll	int	Permet de définir combien de combien de pixels le graphisme sera décalé à chaque seconde.
		 */
		public function FPS( width:Number = 250, height:Number = 50, expand:Boolean = true, scroll:int = 2 ) 
		{
			_width = width;
			_height = height;
			_scroll = scroll;
			
			init();
			
			this.expand = expand;
			
			start();
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true );
			startDrag();
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			stopDrag();
		}
		
		private function btFpsDownHandler(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case _btPlus: _diffFps = 1; break;
				case _btMinus: _diffFps = -1; break;
			}
			
			onChangeFPS();
			stage.addEventListener( MouseEvent.MOUSE_UP, btFpsUpHandler, false, 0, true );
			_timerChangeFPS.addEventListener( TimerEvent.TIMER, timerHandler, false, 0, true );
			_timerChangeFPS.start();
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			onChangeFPS();
		}
		
		private function btFpsUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP, btFpsUpHandler );
			_timerChangeFPS.removeEventListener( TimerEvent.TIMER, timerHandler );
			_timerChangeFPS.stop();
		}
		
		private function doubleClickHandler(e:MouseEvent):void 
		{
			expand = !expand;
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			_currentTime = getTimer();
			
			if ( _currentTime - 1000 > _prevIntervalTime )
			{
				_fps = ( _ticks / stage.frameRate ) * stage.frameRate;
				if ( _fps > stage.frameRate ) _fps = stage.frameRate;
				
				_moyValue += _fps;
				if ( ( ++_moyTick % _moyRefresh ) == 0 )
				{
					_moy = ( _moy + _moyValue ) / ( _moyRefresh + 1 );
					_moyValue = 0;
				}
				
				_mem = System.totalMemory / 1048576;
				
				if( _expand )
					updateCurves(); 
				
				_ticks = 0;
				_prevIntervalTime = _currentTime;
			}
			++_ticks;
			
			_ms = int( _currentTime - _prevTime );
			_prevTime = _currentTime;
			
			updateTexts();
		}
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		private function init():void
		{
			initTitle();
			initGraph();
			initTexts();
			initBts();
			
			_rect = new Rectangle( _curves.width - _scroll, 0, _scroll, _curves.height );
			
			initListeners();
		}
		
		private function initTitle():void
		{
			_cntTitle = new Sprite();
			var g:Graphics = _cntTitle.graphics;
			g.beginFill( FPSColorEnum.BG_COLOR );
			g.drawRect( 0, 0, _width + 1, 20 );
			g.endFill();
			addChild( _cntTitle );
			
			_cntTitle.doubleClickEnabled =
			_cntTitle.buttonMode = true;
		}
		
		private function initGraph():void
		{
			_cntGraph = new Sprite();
			var g:Graphics = _cntGraph.graphics;
			g.lineStyle( 0, 0xe5e5e5 );
			g.beginFill( 0xffffff );
			g.drawRect( 0, 0, _width, _height );
			g.endFill();
			g.beginFill( 0xeeeeee );
			g.drawRect( 5, 5, _width - 10, _height - 10 );
			g.endFill();
			_cntGraph.y = _cntTitle.height;
			addChild( _cntGraph );
			
			_cntGraph.mouseEnabled =
			_cntGraph.mouseChildren = false;
			
			_curves = new BitmapData( _width - 11, _height - 11, false, 0xeeeeee );
			var b:Bitmap = new Bitmap( _curves, PixelSnapping.AUTO, false );
			b.x = 6;
			b.y = 6;
			_cntGraph.addChild( b );
			
			_prevFps =
			_prevMem = 
			_prevMs = _curves.height;
		}
		
		private function initTexts():void
		{
			_cntTexts = new Sprite();
			_cntTexts.mouseChildren = 
			_cntTexts.mouseEnabled = false;
			_cntTitle.addChild( _cntTexts );
			
			_tfFps = new TextField();
			_tfFps.x = 5;
			_tfFps.y = 2;
			formatText( _tfFps, FPSColorEnum.FPS );
			_tfFps.text = "FPS : ...";
			
			_tfMem = new TextField();
			_tfMem.x = 75;
			_tfMem.y = 2;
			formatText( _tfMem, FPSColorEnum.MEM );
			_tfMem.text = "MEM : ...";
			
			_tfMoy = new TextField();
			_tfMoy.x = 125;
			_tfMoy.y = 2;
			formatText( _tfMoy, FPSColorEnum.MOY );
			_tfMoy.text = "MS : ...";
			
			_tfMs = new TextField();
			_tfMs.x = _width - 50;
			_tfMs.y = 2;
			formatText( _tfMs, FPSColorEnum.MS );
			_tfMs.text = "MS : ...";
		}
		
		private function initBts():void
		{
			_cntBts = new Sprite();
			_cntBts.x = ( ( _cntTitle.x + _cntTitle.width ) >> 0 ) + 1;
			addChild( _cntBts );
			
			_btPlus = new FPSButton( "+" );
			_cntBts.addChild( _btPlus );
			
			_btMinus = new FPSButton( "-" );
			_btMinus.y = ( ( _btPlus.y + _btPlus.height ) >> 0 ) + 1;
			_cntBts.addChild( _btMinus );
			
			_btGC = new FPSButton("GC");
			_btGC.y = ( ( _btMinus.y + _btMinus.height ) >> 0 ) + 1;
			_cntBts.addChild(_btGC);
		}
		
		private function initListeners():void
		{
			_cntTitle.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true );
			_cntTitle.addEventListener( MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true );
			
			_timerChangeFPS = new Timer( 100 );
			
			_btPlus.addEventListener( MouseEvent.MOUSE_DOWN, btFpsDownHandler, false, 0, true );
			_btMinus.addEventListener( MouseEvent.MOUSE_DOWN, btFpsDownHandler, false, 0, true );
			_btGC.addEventListener(MouseEvent.CLICK, btGCClickHandler, false, 0, true);
		}
		
		private function btGCClickHandler(e:MouseEvent):void 
		{
			System.gc();
			drawLine(_curves.width - _scroll, 0,_curves.width - _scroll, _height, FPSColorEnum.GC);
		}
		
		private function onExpand():void
		{
			_cntGraph.visible = _expand;
		}
		
		private function updateCurves():void
		{
			_curves.lock();
			_curves.scroll( -_scroll, 0 );
			_curves.fillRect( _rect, 0xeeeeee );
			
			var nextFps:int = getNextVal( _fps, stage.frameRate );
			drawCurve( _prevFps, nextFps, FPSColorEnum.FPS );
			_prevFps = nextFps;
			
			var nextMem:int = getNextVal( _mem, MEM_MAX );
			drawCurve( _prevMem, nextMem, FPSColorEnum.MEM );
			_prevMem = nextMem;
			
			var nextMoy:int = getNextVal( _moy, stage.frameRate );
			drawCurve( _prevMoy, nextMoy, FPSColorEnum.MOY );
			_prevMoy = nextMoy;
			
			var nextMs:int = getNextVal( _ms, MS_MAX );
			drawCurve( _prevMs, nextMs, FPSColorEnum.MS );
			_prevMs = nextMs;
			
			_curves.unlock();
		}
		
		private function updateTexts():void
		{
			_tfFps.text = "FPS : " + _fps.toString() + " / " + int(stage.frameRate);
			_tfMem.text = "MEM : " + _mem.toString();
			_tfMoy.text = "MOY FPS : " + _moy.toString();
			_tfMs.text = "MS : " + _ms.toString();
		}
		
		private function formatText( tf:TextField, color:uint ):void
		{
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = color;
			tf.selectable = false;
			
			var format:TextFormat = new TextFormat( "_sans", 9 );
			tf.defaultTextFormat = format;
			
			_cntTexts.addChild( tf );
		}
		
		private function getNextVal( currentVal:int, maxVal:int ):int
		{
			var r:Number = currentVal / maxVal;
			if ( r > 1 ) r = 1;
			
			return int( ( 1 - r ) * ( _curves.height - 1 ) );
		}
		
		private function drawCurve( currentVal:int, newVal:int, color:uint ):void
		{
			drawLine( _curves.width - _scroll, currentVal, _curves.width - 1, newVal, color );
		}
		
		/**
		 * Draw a pixel line !
		 * @param	x0	int	Start point on the X axis.
		 * @param	y0	int	Start point on the Y axis.
		 * @param	x1	int	End point on the X axis.
		 * @param	y1	int	End point on the Y axis.
		 * @param	c	int	Line's color.
		 */
		private function drawLine( x0:int, y0:int, x1:int, y1:int, c:uint = 0xff000000 ):void
		{
			var dx:int = x1 - x0;
			var dy:int = y1 - y0;
			var xinc:int = ( dx > 0 ) ? 1 : -1;
			var yinc:int = ( dy > 0 ) ? 1 : -1;
			if ( dx < 0 ) dx = -dx;
			if ( dy < 0 ) dy = -dy;
			
			_curves.setPixel( x0, y0, c );
			
			var cumul:int, i:int;
			if ( dx > dy )
			{
				cumul = dx >> 1;
				for ( i = 1; i <= dx; ++i )
				{
					x0 += xinc;
					cumul += dy;
					if ( cumul >= dx )
					{
						y0 += yinc;
						cumul -= dx;
					}
					_curves.setPixel( x0, y0, c );
				}
			}
			else
			{
				cumul = dy >> 1;
				for ( i = 1; i <= dy; ++i )
				{
					y0 += yinc;
					cumul += dx;
					if ( cumul >= dy )
					{
						x0 += xinc;
						cumul -= dy;
					}
					_curves.setPixel( x0, y0, c );
				}
			}
		}
		
		private function onChangeFPS():void
		{
			stage.frameRate += _diffFps;
		}
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		/**
		 * Permet de démarrer l'outil de suivi de performances.
		 * Il se lance par défaut dès l'ajout au stage.
		 */
		public function start():void 
		{
			if ( _running )
				return;
			
			_prevTime = getTimer();
			
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			_running = true;
		}
		
		
		/**
		 * Permet de stopper l'outil de suivi de performances.
		 */
		public function stop():void
		{
			if ( !_running )
				return;
			
			removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			_running = false;
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
		public function get expand():Boolean { return _expand; }
		
		public function set expand(value:Boolean):void 
		{
			_expand = value;
			onExpand();
		}
		
		public function get running():Boolean { return _running; }
		
	}
	
}
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

final class FPSButton extends Sprite
{
	private var _label:String;
	
	public function FPSButton( label:String ):void
	{
		_label = label;
		
		initBg();
		initText();
		
		this.mouseChildren = false;
		this.buttonMode = true;
	}
	
	private function initBg():void
	{
		var g:Graphics = this.graphics;
		g.beginFill( FPSColorEnum.BG_COLOR );
		g.drawRect( 0, 0, 20, 20 );
		g.endFill();
	}
	
	private function initText():void
	{
		var format:TextFormat = new TextFormat( "_sans", 9, 0xffffff );
		
		var tf:TextField = new TextField();
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.defaultTextFormat = format;
		tf.text = _label;
		tf.x = ( ( this.width - tf.width ) >> 1 ) + 1;
		tf.y = ( ( this.height - tf.height ) >> 1 );
		addChild( tf );
	}
}

final class FPSColorEnum
{
	public static const FPS:uint = 0xff0000;
	public static const MEM:uint = 0x00ff00;
	public static const MOY:uint = 0xff6600;
	public static const MS:uint = 0x0099ff;
	public static const GC:uint = 0;
	
	public static const BG_COLOR:uint = 0x222222;
}
