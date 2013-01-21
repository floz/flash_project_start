
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.module
{
	
	public interface IModule extends IModulePart
	{
		function loadData( url:String ):void;
		
		function get data():XML;
		function set data( value:XML ):void;
	}
	
}