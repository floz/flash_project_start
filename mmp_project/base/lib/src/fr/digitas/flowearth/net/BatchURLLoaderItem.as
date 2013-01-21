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

package fr.digitas.flowearth.net {
	import fr.digitas.flowearth.bi_internal;
	import fr.digitas.flowearth.event.BatchEvent;
	import fr.digitas.flowearth.net.AbstractBLoader;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
	
	use namespace bi_internal;	

	/**
	 * URLLoader batchable, egalement <code>IProgressor</code>
	 * 
	 * @author Pierre Lepers
	 */
	public class BatchURLLoaderItem extends AbstractBLoader {
		

		/**
		 * Type de données a recuperer
		 * @see URLLoaderDataFormat
		 * @see URLLoader#dataFormat
		 */
		public var dataFormat : String;
		
		/**
		 * renvoi les data loadé par le BatchURLLoaderItem;
		 * @return les data ( correspondant au URLLoader.data ), null si le loading n'est pas terminé
		 * @see URLLoader#data
		 */
		public function get data() : * {
			if( _loader ) return _loader.data;
			return null;
		}
		
		/**
		 * Crée un nouveau BatchURLLoaderItem
		 * @param request requete pour le loading
		 * @param params parametres arbitraires, recuperable via <code>BatchURLLoaderItem.params</code>
		 */
		function BatchURLLoaderItem( request : URLRequest, params : Object = null, statusMessage : String = null, failOnError : Boolean = false ) : void {
			super( request, context, params, statusMessage, failOnError );
		}
		
		
		override public function execute() : void {
			super.execute();
			_loader = new URLLoader();
			if( dataFormat ) _loader.dataFormat = dataFormat;
			register( _loader );
			_loader.load( _request );
		}
		
		override public function dispose() : void {
			try {_loader.close( );
			} catch( e : Error ) {};
			
			unregister();
			dispatchEvent( new BatchEvent( BatchEvent.DISPOSED, this ) );
		}
		
		
		//_____________________________________________________________________________
		//																	   PRIVATES
		
		bi_internal var _loader : URLLoader;
		
	}
}