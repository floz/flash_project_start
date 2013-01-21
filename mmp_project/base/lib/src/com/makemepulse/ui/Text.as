/**
 * @author floz
 */
package com.makemepulse.ui 
{
	import fr.digitas.flowearth.text.styles.styleManager;
	import flash.text.TextField;
	
	public class Text extends TextField
	{
		private var _styleName:String;
		
		public function Text( styleName:String, text:String = "" )
		{
			_styleName = styleName;		
			this.text = text;	
		}
			
		override public function set text( value:String ):void
		{
			styleManager.apply( this, _styleName, value );
		}
	}
}

