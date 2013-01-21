
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.navigation.module
{
	import com.makemepulse.core.IDisposable;
	
	public interface IModulePart extends IDisposable, ITransitionPart
	{		
		function freeze():void;
		function unfreeze():void;
		
		function get id():String;
		function set id( value:String ):void;
	}
	
}