
/**
 * @author Floz
 */
package com.makemepulse.navigation.module.manager
{
	import com.makemepulse.navigation.module.IModulePart;
	import com.makemepulse.navigation.module.Module;
	import com.makemepulse.navigation.module.ModuleInfo;
	import com.makemepulse.navigation.node.NavNode;
	import com.makemepulse.navigation.node.event.NavEvent;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;



	public class BasicModuleManager extends Module
	{
		
		// - PRIVATE VARIABLES -----------------------------------------------------------
		
		protected var _modulesClasses:Dictionary = new Dictionary();
		
		protected var _navNode:NavNode;
		protected var _currentModule:IModulePart;
		
		protected var _shown:Boolean;
		
		// - PUBLIC VARIABLES ------------------------------------------------------------
		
		// - CONSTRUCTOR -----------------------------------------------------------------
		
		public function BasicModuleManager( navNode:NavNode, modules:/*ModuleInfo*/Array = null ) 
		{
			_navNode = navNode;
			_navNode.addEventListener( NavEvent.NAV_CHANGE, navChangeHandler, false, 0, true );
			
			if ( modules )
				addModules( modules );
		}
		
		// - EVENTS HANDLERS -------------------------------------------------------------
		
		private function navChangeHandler(e:NavEvent):void 
		{
			if( !_shown )
				return;
			
			onNavChange();
		}
		
		// - PRIVATE METHODS -------------------------------------------------------------
		
		protected function onNavChange():void
		{
			if ( _navNode.frozen )
				return;
			
			if ( !_modulesClasses[ _navNode.currentId ] )
				return;
			
			_navNode.frozen = true;
			
			if ( _currentModule )
			{
				var d:Number = _currentModule.hide();
				setTimeout( showNewModule, d * 1000 );
			}
			else showNewModule();
		}
		
		protected function showNewModule( delay:Number = 0 ):Number
		{
			if ( _currentModule )
			{
				_currentModule.dispose();
				removeChild( _currentModule as DisplayObject );
				_currentModule = null;
			}
			
			if ( _modulesClasses[ _navNode.currentId ] )
				_currentModule = new _modulesClasses[ _navNode.currentId ];
			else 
				return 0;
			
			addChild( _currentModule as DisplayObject );
			
			var d:Number = _currentModule.show( delay );
			setTimeout( onModuleShow, d * 1000 );
			return d;
		}
		
		protected function onModuleShow():void
		{
			_navNode.frozen = false;
		}
		
		// - PUBLIC METHODS --------------------------------------------------------------
		
		public function addModule( id:String, c:Class ):void
		{
			_modulesClasses[ id ] = c;
			
			//if ( _navNode.currentId && _navNode.currentId == id )
				//showNewModule();
		}
		
		public function addModules( modules:/*ModuleInfo*/Array ):void
		{
			var n:int = modules.length;
			for ( var i:int; i < n; ++i )
				addModule( ModuleInfo( modules[ i ] ).id, ModuleInfo( modules[ i ] ).c );
		}
		
		public function update():void
		{
			onNavChange();
		}
		
		override public function show(delay:Number = 0):Number 
		{
			_shown = true;
			return showNewModule( delay );
		}
		
		override public function hide(delay:Number = 0):Number 
		{
			if ( _currentModule )
			{
				_navNode.frozen = true;
				return _currentModule.hide( delay );
			}			
			return 0;
		}
		
		override public function dispose():void
		{
			if ( _currentModule )
			{
				_currentModule.dispose();
				removeChild( _currentModule as DisplayObject );
				_currentModule = null;
			}
			
			_navNode.removeEventListener( NavEvent.NAV_CHANGE, navChangeHandler );
		}
		
		// - GETTERS & SETTERS -----------------------------------------------------------
		
		public function get currentModule():IModulePart { return _currentModule; }
		
	}

}