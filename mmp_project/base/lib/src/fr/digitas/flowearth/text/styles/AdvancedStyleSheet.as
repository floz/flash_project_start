/* ***** BEGIN LICENSE BLOCK *****
 * Copyright (C) 2007-2009 Digitas France
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * The Initial Developer of the Original Code is
 * Digitas France Flash Team
 *
 * Contributor(s):
 *   Digitas France Flash Team
 *
 * ***** END LICENSE BLOCK ***** */

package fr.digitas.flowearth.text.styles {
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;	
		
	
	/*FDT_IGNORE*/
	/*-FP10*/
	//import flashx.textLayout.elements.IFormatResolver;
	/*FP10-*/
	/*FDT_IGNORE*/

	/**
	 * @author Pierre Lepers
	 */
	public class AdvancedStyleSheet {

		
		public function AdvancedStyleSheet( ns : Namespace, id : String ) {
			this.id = id;
			this.ns = ns;
			_baseSheet = new StyleSheet( );
			_styles = new Dictionary( );
			/*FDT_IGNORE*/
			/*-FP10*/
/*			if( tlfFactory.hasSupport() ) {
				_tlfFormatResolver = tlfFactory.getFormatResolver( );
				_tlfFormatResolver.init( this );
			}*/
			/*FP10-*/
			/*FDT_IGNORE*/
		}

		public function parseCSS(CSSText : String) : void {
			_baseSheet.parseCSS( CSSText );
			new StyleSheetProcessor( _baseSheet ).process();
			_parseBase( );
		}
	
	

		public function getCss() : StyleSheet {
			return _baseSheet;
		}

		
		
		public function get styleNames() : Array {
			return _baseSheet.styleNames;
		}

		public function setStyle( styleName : String, style : AdvancedFormat ) : void {
			if(styleName.charAt( 0 ) == ".") styleName = styleName.substr( 1 ); 
			_styles[ styleName ] = style;
		}

		public function getStyle( styleName : String ) : AdvancedFormat {
			if(styleName.charAt( 0 ) == ".") styleName = styleName.substr( 1 ); 
			var s : AdvancedFormat = _styles[ styleName ];
			if ( ! s ) throw new Error( "com.nissan.core.styles.AdvStyleSheet - getStyle : unable to find style '" + styleName + "' in styles library" );
			return s;
		}
		
		/*FDT_IGNORE*/
		/*-FP10*/
		public function getTlfFormatResolver() : Object {
			return _tlfFormatResolver;
		}
		
		private var _tlfFormatResolver : Object;

		/*FP10-*/
		/*FDT_IGNORE*/
			
		
		//_____________________________________________________________________________
		//																	   PRIVATES
		
		internal var ns : Namespace;
		
		internal var id : String;

		private function _parseBase() : void {
			var sn : Array = _baseSheet.styleNames;
			var l : int = sn.length;
			var id : String;
			while( -- l > - 1 ) {
				id = sn[l];
				if(id.charAt( 0 ) == ".") id = id.substr( 1 ); 
				setStyle( id , objToStyle( _baseSheet.getStyle( sn[ l ] ) ) );
			}
		}

		
		private function objToStyle( obj : Object) : AdvancedFormat {
			var s : AdvancedFormat = new AdvancedFormat( );
			s.parseObject( obj );
			return s;
		}

		
		private var _styles : Dictionary;
		
		private var _baseSheet : StyleSheet;
		
	}
}

//_____________________________________________________________________________
//															STYLESHEETPROCESSOR
//
// SSSSS TTTTTT YY  YY  LL      EEEEEEE  SSSSS HH   HH EEEEEEE EEEEEEE TTTTTT PPPPPP  RRRRR    OOOO   CCCCC  EEEEEEE  SSSSS  SSSSS  OOOO  RRRRR   
//SS       TT    YYYY   LL      EE      SS     HH   HH EE      EE        TT   PP   PP RR  RR  OO  OO CC   CC EE      SS     SS     OO  OO RR  RR  
// SSSS    TT     YY    LL      EEEE     SSSS  HHHHHHH EEEE    EEEE      TT   PPPPPP  RRRRR   OO  OO CC      EEEE     SSSS   SSSS  OO  OO RRRRR   
//    SS   TT     YY    LL      EE          SS HH   HH EE      EE        TT   PP      RR  RR  OO  OO CC   CC EE          SS     SS OO  OO RR  RR  
//SSSSS    TT     YY    LLLLLLL EEEEEEE SSSSS  HH   HH EEEEEEE EEEEEEE   TT   PP      RR   RR  OOOO   CCCCC  EEEEEEE SSSSS  SSSSS   OOOO  RR   RR

import fr.digitas.flowearth.text.fonts.fontsManager;
import fr.digitas.flowearth.text.styles.styleManager;

import flash.text.StyleSheet;
import flash.utils.Dictionary;

final class StyleSheetProcessor {

		
	public function StyleSheetProcessor( styleSheet : StyleSheet ) {
		_styleSheet = styleSheet;
	}

	
	internal function process() : void {
		_dExtended = new Dictionary( );
		_aExtended = _styleSheet.styleNames.map( _mapSheet );
		_styleSheet.clear( );
		_aExtended.forEach( _processStyle );
		_dispose( );
	}

	private function _mapSheet( name : String, index:int, arr:Array) : ExtendedStyle {
		name = name.toLowerCase( );
		var exs : ExtendedStyle = new ExtendedStyle( name , _styleSheet.getStyle( name ) );
		_dExtended[ exs.name ] = exs;
		return exs;
		index;arr;
	}

	private function _processStyle( style : ExtendedStyle, index : int, styles : Array) : void {
		style.compileProtoChain( styles , _dExtended );
		if( styleManager.autoEmbed )
			style.checkFontAvailability();
		_styleSheet.setStyle( style.name , style.value );
		index;
	}

	private function _dispose() : void {
		_aExtended = null;
		_dExtended = null;
		_styleSheet = null;
	}

	private var _aExtended : Array;
	
	private var _dExtended : Dictionary;
	
	private var _styleSheet : StyleSheet;
}

//_____________________________________________________________________________
//																  EXTENDEDSTYLE
//
//		EEEEEEE X     X TTTTTT EEEEEEE NN  NN DDDDDD  EEEEEEE DDDDDD   SSSSS TTTTTT YY  YY  LL      EEEEEEE 
//		EE        X X     TT   EE      NNN NN DD   DD EE      DD   DD SS       TT    YYYY   LL      EE      
//		EEEE       X      TT   EEEE    NNNNNN DD   DD EEEE    DD   DD  SSSS    TT     YY    LL      EEEE    
//		EE        X X     TT   EE      NN NNN DD   DD EE      DD   DD     SS   TT     YY    LL      EE      
//		EEEEEEE X     X   TT   EEEEEEE NN  NN DDDDDD  EEEEEEE DDDDDD  SSSSS    TT     YY    LLLLLLL EEEEEEE 





final class ExtendedStyle {

	function ExtendedStyle( name : String, value : Object ) {
		_pcCompiled = false;
		this.name = name;
		this.value = value;
		_build( );
	}

	
	internal function compileProtoChain( provider : Array, dmap : Dictionary ) : void {
		if( _pcCompiled ) return;
		
		var parent : ExtendedStyle = dmap[ _pname ];
		if( ! parent ) 
			throw new Error( "AdvancedStyleSheet - compileProtoChain : " + name + " extend " + _pname + "which doesn't exist" , 1002 );
		if( ! parent._pcCompiled ) 
			parent.compileProtoChain( provider , dmap );
		
		for( var pprop : String in parent.value )
		{
			if( ! value.hasOwnProperty( pprop ) ) 
				value[pprop] = parent.value[pprop];
		}

		_pcCompiled = true;
	}
	
	internal function checkFontAvailability() : void {
		value.embedFonts = fontsManager.hasFont( value.fontFamily );
	}

	
	private function _build() : void {
		if( name.indexOf( ">" ) > - 1 ) {
			var split : Array = name.split( ">" );
			name = split[0];
			_pname = split[1];
		} else
			_pcCompiled = true;

	}

	
	internal var name : String;

	internal var value : Object;

	private var _pcCompiled : Boolean;

	private var _pname : String;
}

