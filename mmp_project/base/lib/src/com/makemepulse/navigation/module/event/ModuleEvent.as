
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.module.event 
{
	import flash.events.Event;
	
	public class ModuleEvent extends Event 
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		public static const OPEN:String = "moduleevent_open";
		public static const CLOSE:String = "moduleevent_close";
		public static const READY:String = "moduleevent_ready";
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function ModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		public override function clone():Event 
		{ 
			return new ModuleEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ModuleEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
	}
	
}