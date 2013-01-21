
/**
 * Written by :
 * @author Floz
 * www.floz.fr || www.minuit4.fr
 */
package com.makemepulse.core
{
	
	public interface IDisposable 
	{
		/**
		 * Supprime totalement l'objet afin de le rendre disponible au GC.
		 * Après l'appel de la méthode dispose, l'objet est inutilisable.
		 */
		function dispose():void;
	}
	
}