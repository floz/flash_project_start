
/**
 * @author Floz
 */
package com.makemepulse.navigation.node
{
	import com.makemepulse.navigation.node.event.NavEvent;
	import flash.events.EventDispatcher;


	public class NavNode extends EventDispatcher
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		private var _currentId:String;
		
		private var _frozen:Boolean;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function NavNode() 
		{
			
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		public function reset():void
		{
			_currentId = null;
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
		public function set currentId( value:String ):void
		{
			if( frozen == true || _currentId == value )
				return;
			
			_currentId = value;
			dispatchEvent( new NavEvent( NavEvent.NAV_CHANGE ) );
		}
		
		public function get currentId():String { return _currentId; }
		
		public function set frozen( value:Boolean ):void
		{
			_frozen = value;
		}

		public function get frozen():Boolean
		{
			return _frozen;
		}
		
	}

}