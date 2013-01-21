
package {package}
{
	import {package}.nav.Nav{modulename}Ids;
	import {package}.nav.nav{modulename};
	{importmodules}
	import com.makemepulse.navigation.module.manager.BasicModuleManager;
	import com.makemepulse.navigation.module.ModuleInfo;
	import com.makemepulse.navigation.module.Module;
	
	public class {modulename}Module extends Module
	{
		private var _moduleManager:BasicModuleManager;
		
		public function {modulename}Module()
		{
			_initNav();	
		}

		private function _initNav():void
		{
			_moduleManager = new BasicModuleManager( nav{modulename}, [ {modules} ] );
			addChild( _moduleManager );
		}
	}
}

