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

package fr.digitas.flowearth.conf {
	import fr.digitas.flowearth.conf.AbstractConfiguration;	
		import flash.net.URLRequest;		/**
	 * @author Pierre Lepers
	 */
	public class ExternalFile {

		public var id 		: String;
		public var size 	: uint;
		public var request 	: URLRequest;
		public var datas 	: XMLList;
		
		public function ExternalFile( node : XML, conf : AbstractConfiguration ) {
			parse( node, conf );
		}
		
		private function parse ( node : XML, conf : AbstractConfiguration ) : void {
			var url : String;
			var _currentURI : String = node.namespace().uri;
			
			if( node.@url.length() > 0 )	url = conf.getString( new QName( _currentURI, node.@url ) );
			else url = conf.solve( node.text( )[0], node.namespace() );
			
			if( node.@size.length() > 0 )	size = node.@size;
			else size = 1;
			
			if( node.@id.length() > 0 )		id = node.@id;
			datas = node.children( );
			request = new URLRequest( url );
		}
	}
}
