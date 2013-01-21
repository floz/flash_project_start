
/**
 * @author Floz
 */
package com.makemepulse.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	/**
	 * Idée reprise de Rashid Ghassempouri et de son googlecode bigarobas.
	 * Crée un élément bateau, utile pour effectuer des tests en ayant rapidement un objet visuel sous la main.
	 */
	public class Dummy extends Sprite
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		/**
		 * Un objet dummy pour effectuer des tests.
		 */
		public function Dummy( width:Number = 20, height:Number = 20, color:uint = 0xFFFF00 ) 
		{
			_width = width;
			_height = height;
			_color = color;
			
			init();
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		private function init():void
		{
			var g:Graphics = this.graphics;
			g.beginFill( 0x000000 );
			g.drawRect( 0, 0, _width, _height );
			g.endFill();
			
			g.beginFill( _color );
			g.drawRect( 1, 1, ( _width >> 1 ) - 1, ( _height >> 1 ) - 1 );
			g.drawRect( ( _width >> 1 ), ( _height >> 1 ), ( _width >> 1 ) - 1, ( _height >> 1 ) - 1 );
			g.endFill();
		}
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
	}
	
}