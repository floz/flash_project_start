
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.module
{
	import com.makemepulse.navigation.module.event.ModuleEvent;
	
	public class ModulePart extends TransitionPart implements IModulePart
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		protected var _id:String;
		protected var _frozen:Boolean;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function ModulePart() 
		{
			
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		override public function show( delay:Number = 0 ):Number
		{
			dispatchEvent( new ModuleEvent( ModuleEvent.OPEN ) );
			return 0;
		}
		
		override public function hide( delay:Number = 0 ):Number
		{
			dispatchEvent( new ModuleEvent( ModuleEvent.CLOSE ) );
			return 0;
		}
		
		public function freeze():void
		{
			if ( _frozen )
				return;
			
			_frozen = true;
		}
		
		public function unfreeze():void 
		{
			if ( !_frozen )
				return;
			
			_frozen = false;
		}
		
		public function dispose():void
		{
			// ABSTRACT
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
		public function get id():String { return _id; }
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get frozen():Boolean { return _frozen; }
		
		public function set frozen(value:Boolean):void 
		{
			if ( value )
				freeze();
			else
				unfreeze();			
		}
		
	}
	
}