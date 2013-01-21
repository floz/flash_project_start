
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.node.event
{
	import flash.events.Event;
	
	public class NavEvent extends Event 
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		public static const NAV_CHANGE:String = "navevent_nav_change";
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function NavEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		public override function clone():Event 
		{ 
			return new NavEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("NavEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
	}
	
}