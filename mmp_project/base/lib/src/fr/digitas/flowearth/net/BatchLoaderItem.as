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
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;	
	
	use namespace bi_internal;
	
	/**
	 * dispatché lorsque le loader est initialisé
	 */[Event(name="init", type="flash.events.Event")]	

	/**
	 * Loader batchable, egalement <code>IProgressor</code>
	 * 
	 * @author Pierre Lepers
	 */
	public class BatchLoaderItem extends AbstractBLoader {

		public var loader : Loader;
		
		/**
		 * if set to true item will be considered as complete when INIT event is dispatched.
		 */
		public var useInit : Boolean = false;
		
		
		public function BatchLoaderItem ( request : URLRequest, context : LoaderContext = null, params : Object = null, statusMessage : String = null, failOnError : Boolean = false ) : void {
			super( request, context, params, statusMessage, failOnError );
			loader = new Loader( );
			register( loader.contentLoaderInfo );
		}

		override public function execute () : void {
			super.execute();
			loader.load( _request, _context );
		}		

		
		override public function dispose () : void {
			try {	
				loader.close( );
				loader.unload( );
			} catch( e : Error ) {};
			unregister( );
			dispatchEvent( new BatchEvent( BatchEvent.DISPOSED, this ) );
			super.dispose();
		}

		override protected function onInit(e : Event) : void {
			super.onInit( e );
			if( useInit ) {
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
	}
}