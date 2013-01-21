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

package fr.digitas.flowearth.text.styles
{
	import flash.text.TextField;
	import flash.utils.Dictionary;
	


	/**
	 * @author Pierre Lepers
	 */
	internal final class StyleManagerClass {
		
		
		
		public function StyleManagerClass( ) {
			if( _instance != null ) throw new Error( "bi.text.styles.StyleManagerClass est deja instancié" );
			_spaces = new Dictionary();
			_sheets = new Dictionary();
		}
		
		/**
		 * If set to true, styles's embedFonts property is automatically overrided to true if the font is embeded
		 * modification of this property do not affect css already loaded
		 * @default true
		 */
		public var autoEmbed : Boolean = false;

		/**
		 * apply a style to a <code>TextField</code> with the given html string
		 * @param tf , textfield to stylized
		 * @param styleName Object the neme of the style to use, can be a String or a QName if you separate styles in several namespaces
		 * @param htmlText html text surrounded
		 */
		public function apply( tf : TextField, styleName : Object, htmlText : String = null ) : void {
			var qn : QName = new QName( styleName );
			var advCss : AdvancedStyleSheet = getSpace( qn ).findCss( qn.localName );
			advCss.getStyle( qn.localName ).getFormatter( ).format( tf );
			tf.styleSheet = advCss.getCss( );
			if( htmlText ) {
				if( qn.localName.charAt( 0 ) == "." )
					tf.htmlText = "<span class='" + stripDot( qn.localName.toLowerCase() ) + "'>" + htmlText + "</span>";
				else
					tf.htmlText = "<"+qn.localName.toLowerCase()+ ">" + htmlText + "</"+qn.localName.toLowerCase()+ ">";
			}
		}
		
		/*FDT_IGNORE*/
		/*-FP10*/
		/*public function getHtmlTlf( styleName : Object, htmlText : String ) : Object {
			var qn : QName = new QName( styleName );
			var advCss : AdvancedStyleSheet = getSpace( qn ).findCss( qn.localName );
			var advFmt : AdvancedFormat = advCss.getStyle( qn.localName );
			var _tlfImporter : Object = tlfFactory.getHtmlTextImporter( advFmt.getTlfConfig() );//TextConverter.getImporter( TextConverter.TEXT_FIELD_HTML_FORMAT, advFmt.getTlfConfig() );
			var _tf : Object = _tlfImporter.importToFlow( htmlText );
			_tf.formatResolver = advCss.getTlfFormatResolver();
			_tf.hostFormat = advFmt.getTlfFormat();
			return _tf;
		}*/

		/*FP10-*/
		/*FDT_IGNORE*/

		
		public function applyFormat( tf : TextField, styleName : Object ) : void {
			var qn : QName = new QName( styleName );
			getSpace( qn ).findStyle( qn.localName.toLowerCase() ).format( tf );
		}
		
		public function getStyle( styleName : Object ) : AdvancedFormat {
			var qn : QName = new QName( styleName );
			return getSpace( qn ).findStyle( qn.localName.toLowerCase( ) );
		}

		/**
		 * add a styleSheet to manager
		 * @param css String containing valid css format
		 * @param uri String namespace's uri in which add the css
		 * @param id int a unique id can be used to retreive css or delete it from manager
		 * @return a unique id, equals as id param if passed.
		 * 
		 * @throws Error if css is invalid or empty
		 */
		public function addCss( css : String, uri : String = "", id : String = "" ) : String {
			id = Unique.gimmy( id );
			var ns : Namespace = new Namespace( uri );
			var sheet : AdvancedStyleSheet = buildStyleSheet( css, ns, id );
			
			if( sheet.styleNames.length == 0 )
				throw new Error( "Style - the css has no styles or is invalid", 1001 );
				
			getSpace( new QName( ns, "_" ) ).addCss( sheet );
			_sheets[ sheet.id ] = sheet;
			return sheet.id;
		}
		
		
		public function getCss( id : String ) : AdvancedStyleSheet {
			return _sheets[ id ];
		}

		public function hasCss( id : String ) : Boolean {
			return ( _sheets[ id ] != undefined );
		}
		
		public function deleteCss( id : String ) : Boolean {
			var css : AdvancedStyleSheet = _sheets[ id ];
			if( !css ) return false;
			
			getSpace( new QName( css.ns, "_") ).removeCss( css );
			Unique.deleteId( id );
			delete _sheets[ id ];
						
			return true;
		}

		//_____________________________________________________________________________
		//																	   PRIVATES
		
		
		private function getSpace( qn : QName ) : StyleSpace {
			if( _spaces[ qn.uri ] == undefined ) 
				_spaces[ qn.uri ] = new StyleSpace( qn.uri );
			return _spaces[ qn.uri ];
		}
		
		private function buildStyleSheet( css : String, ns : Namespace, id : String) : AdvancedStyleSheet {
			var sheet : AdvancedStyleSheet = new AdvancedStyleSheet( ns, id );
			
			// clean whitespace around colons
			css = css.replace( /\s+:/g, ":" );
			sheet.parseCSS( css );
			
			return sheet;
		}
		
		private var _spaces : Dictionary;
		private var _sheets : Dictionary;
		

		//_____________________________________________________________________________
		//															 INTERNAL SINGLETON
		
		public static function _start() : StyleManagerClass {
			if (_instance == null)
				_instance = new StyleManagerClass();
			return _instance;
		}
		
		private static var _instance : StyleManagerClass;
		
		
	}
}
import fr.digitas.flowearth.text.styles.AdvancedFormat;
import fr.digitas.flowearth.text.styles.AdvancedStyleSheet;

import flash.utils.Dictionary;

//_____________________________________________________________________________
//																    STYLE SPACE
//
//		 SSSSS TTTTTT YY  YY  LL      EEEEEEE          SSSSS PPPPPP    AAA    CCCCC  EEEEEEE 
//		SS       TT    YYYY   LL      EE              SS     PP   PP  AAAAA  CC   CC EE      
//		 SSSS    TT     YY    LL      EEEE             SSSS  PPPPPP  AA   AA CC      EEEE    
//		    SS   TT     YY    LL      EE                  SS PP      AAAAAAA CC   CC EE      
//		SSSSS    TT     YY    LLLLLLL EEEEEEE         SSSSS  PP      AA   AA  CCCCC  EEEEEEE



final class StyleSpace {

	
	public function StyleSpace( uri : String ) {
		_uri = uri;
		_stylesMap = new Dictionary( );
	}
	
	private var _uri : String;

	internal function findStyle( styleName : String ) : AdvancedFormat {
		styleName = stripDot( styleName );
		return findCss( styleName ).getStyle( styleName );
	}

	internal function findCss( styleName : String ) : AdvancedStyleSheet {
		styleName = stripDot( styleName );
		var adv : AdvancedStyleSheet = _stylesMap[ styleName ];
		if( !adv )
			throw new Error( "com.nissan.core.styles.GlobalStyles - findCss - unable to find style '" + styleName + "' in styles library "+_uri );
		return _stylesMap[ styleName ];
	}

	internal function addCss( css : AdvancedStyleSheet ) : void {
		var sn : Array = css.styleNames;
		var l : int = sn.length;
		var id:String;
		while( --l > -1 ) {
			id = sn[l];
			id = stripDot( id );
			if( _stylesMap[ id ] != undefined ) 
				throw new Error( "StyleManager - style conflict : style "+id+" already exist", 1000 );
			_stylesMap[ id ] = css;
		}
	}

	internal function removeCss( css : AdvancedStyleSheet ) : void {
		var sn : Array = css.styleNames;
		var l : int = sn.length;
		while( --l > -1 ) 
			delete _stylesMap[ stripDot( sn[l] ) ];
	}

	private var _stylesMap : Dictionary;
	
}

//_____________________________________________________________________________
//																		 UNIQUE
//
//		UU   UU NN  NN IIIIII  QQQQQ  UU   UU EEEEEEE 
//		UU   UU NNN NN   II   QQ   QQ UU   UU EE      
//		UU   UU NNNNNN   II   QQ Q QQ UU   UU EEEE    
//		UU   UU NN NNN   II   QQ  QQQ UU   UU EE      
//		 UUUUU  NN  NN IIIIII  QQQQ Q  UUUUU  EEEEEEE 


class Unique {
	
	internal static function gimmy( input : String ) : String {
		if( input != "" ) {
			if( _provided[ input ] != undefined )
				throw new Error( "StyleManager - given css id "+input+" already exist", 1003 );
			_provided[ input ] = true;
			return input;
		}
		while ( _provided[ String( ++_count ) ] != undefined ) 
			true;
		return String( _count );
	}

	internal static function deleteId( id : String ) : void {
		delete _provided[ id ];
	}

	
	
	private static var _count : int = 0;
	
	private static var _provided : Dictionary = new Dictionary();
		
}




//_____________________________________________________________________________
//																		 stripDot

function stripDot( input : String ) : String {
	if ( input.charAt(0) == "." ) 
		return input.substr(1);
	return input;
}


