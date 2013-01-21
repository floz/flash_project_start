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
	import flash.media.SoundLoaderContext;
	import fr.digitas.flowearth.bi_internal;
	import fr.digitas.flowearth.event.BatchEvent;
	import fr.digitas.flowearth.net.AbstractBLoader;

	import flash.media.Sound;
	import flash.net.URLRequest;
	
	use namespace bi_internal;
	
	/**
	 * dispatched when completed
	 */[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Batchable loader for Sound objects.
	 * 
	 * @author Romain PRACHE
	 */
	public class BatchSoundLoaderItem extends AbstractBLoader
	{

        
        /**
         * return the sound loaded by BatchSoundLoaderItem;
         * @return the sound or null if loading is still progressing
         */
        public function get sound() : Sound {
            if( _loader ) return  _loader;
            return null;
        }
        
        /**
         * Create a new BatchSoundLoaderItem
         * @param request : request for loading
         * @param soundContext : indicates the context (cf <code>SoundLoaderContext</code>)
         */
        function BatchSoundLoaderItem( request : URLRequest, soundContext : SoundLoaderContext = null, params : Object = null, statusMessage : String = null, failOnError : Boolean = false ) : void {
            super( request, context, params, statusMessage, failOnError );
			_scontext = soundContext;
		}

		
		override public function execute() : void {
            super.execute();
            _loader = new Sound();
            register( _loader );
			_loader.load( _request, _scontext );
        }
        
        override public function dispose() : void {
            try {_loader.close( );
            } catch( e : Error ) {};
            
            unregister();
            dispatchEvent( new BatchEvent( BatchEvent.DISPOSED, this ) );
        }
        
        
        //_____________________________________________________________________________
        //                                                                                                                                         PRIVATES
        
        bi_internal var _loader 	: Sound;
        bi_internal var _scontext	: SoundLoaderContext;
		
	}
}
