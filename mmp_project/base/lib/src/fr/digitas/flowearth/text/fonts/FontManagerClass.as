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

package fr.digitas.flowearth.text.fonts {
	import flash.text.Font;
	import flash.utils.Dictionary;	

	/**
	 * @author Pierre Lepers
	 */
	internal class FontManagerClass {


		public function hasFont( fontName : String ) : Boolean {
			return ( _embeddedFonts[ fontName ] != undefined );
		}
		
		public function registerFonts( provider : IFontsProvider ) : void {
			var fonts : Array = provider.getFonts();
			for each (var font : Class in fonts) 
				Font.registerFont( font );
			_updateEmbedded();
		}
		
		//_____________________________________________________________________________
		//																		PRIVATE
		
		function FontManagerClass() {
			if( _instance != null ) throw new Error( "FontManagerClass, still created singleton" );
			_embeddedFonts = new Dictionary();
			_updateEmbedded();
		}
		
		private function _updateEmbedded() : void {
			var list:Array = Font.enumerateFonts();
			var n:int = list.length;
			for (var i:Number = 0; i < n; i++) 
			{
				_embeddedFonts[ (list[i] as Font).fontName ] = list[i];
				trace( ":: Embedded font: > ", list[ i ].fontName );
			}
			
		}

		private var _embeddedFonts : Dictionary;

		//_____________________________________________________________________________
		//																		 STATIC
		
		public static function _start() : FontManagerClass {
			if (_instance == null)
				_instance = new FontManagerClass();
			return _instance;
		}
		
		private static var _instance : FontManagerClass;

	}
}
