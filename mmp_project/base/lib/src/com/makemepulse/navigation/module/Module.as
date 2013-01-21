
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.module 
{
	
	public class Module extends ModulePart implements IModule 
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		protected var _data:XML;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function Module() 
		{
			
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		protected function onData():void
		{
			//
		}
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		public function loadData( url:String ):void
		{
			// TODO
		}
		
		override public function dispose():void 
		{
			_data = null;
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void 
		{
			_data = value;
			onData();
		}
		
	}
	
}