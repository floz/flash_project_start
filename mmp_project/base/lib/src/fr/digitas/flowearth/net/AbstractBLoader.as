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
	import fr.digitas.flowearth.command.BatchableDecorator;
	import fr.digitas.flowearth.command.IBatchable;
	import fr.digitas.flowearth.core.IProgressor;
	import fr.digitas.flowearth.event.BatchErrorEvent;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;	
	
	use namespace bi_internal;
	
	/**
	 * dispatché lorsque le loading est terminé
	 */[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * dispatché lorsque l'item a été annulé
	 * @see BatchEvent#DISPOSED
	 */[Event(name="dispose", type="fr.digitas.flowearth.event.BatchEvent")]
	
	/**
	 * dispatch la progression du loading
	 * @see BatchEvent#ITEM_PROGRESS
	 */[Event(name="bitemProgress", type="flash.events.ProgressEvent")]
	
	/**
	 * dispatch un message status au demarrage, centralisé par le batcher
	 * @see StatusEvent#STATUS
	 */[Event(name="status", type="fr.digitas.flowearth.event.BatchStatusEvent")]	
	
	/**
	 * dispatch une eventuelle erreur sur le loading
	 */[Event(name="batchError", type="fr.digitas.flowearth.event.BatchErrorEvent")]	
	 
	/**
	 * dispatché lorsque l'Ibatchable est ajouté a un  batcher, le batcher est en parametre de l'event( BatchEvent.item )
	 * @see BatchEvent#ADDED
	 */[Event( name = "addedToBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	
	 
	/**
	 * dispatché lorsque l'Ibatchable est supprimé d'un batcher. dispatché aussi juste apres le COMPLETE
	 * @see BatchEvent#REMOVED
	 */[Event( name = "removedFromBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	

	/**
	 * Classe de base pour BatchURLLoaderItem et BatchLoaderItem
	 * @author Pierre Lepers
	 */
	public class AbstractBLoader extends BatchableDecorator implements IBatchable, IProgressor {

		/**
		 * URLRequest utilisé pour lancer le loading
		 */
		public function get request() : URLRequest {	return _request;}
		 
		 /**
		  * LoaderContext utiliser pour lancer le loading
		  */
		public function get context() : LoaderContext {	return _context;}
		
		/**
		 * parametres Arbitraires sous forme d'Object
		 */
		public var params : Object;

		/**
		 * taille en octet du fichier a charger
		 * @default 1.
		 */
		
		
		public function AbstractBLoader ( request : URLRequest, context : LoaderContext = null, params : Object = null, statusMessage : String = null , failOnError : Boolean = false ) : void {
			super( null );
			_failOnError = failOnError;
			_request = request;
			_context = context;
			_statusMessage = statusMessage;
			this.params = params;
		}
		
		
		/**
		 * Lance le loading
		 */
		public override function execute () : void {
			if( request.url == "" )
				throw new Error( "fr.digitas.flowearth.net.AbstractBLoader - execute : empty url" );
			sendStatus(  new StatusEvent ( StatusEvent.STATUS, false, false, _statusMessage || ( "loading media : "+request.url ), "status" ) );
		}
		
		override public function toString() : String {
			return "["+getQualifiedClassName( this ) + "] url " + (( _request != null ) ? _request.url : "null" );
		}
		
		
		//_____________________________________________________________________________
		//																	   PRIVATES
		
		
		protected function register ( ed : IEventDispatcher ) : void {
			if( _ed ) unregister();
			_ed = ed;
			//TODO verifier que LoaderInfo ne dispatch pas une SECURITY_ERROR (ca parait bizarre)
			ed.addEventListener( Event.INIT							, onInit );
			ed.addEventListener( Event.COMPLETE						, sendComplete );
			ed.addEventListener( ProgressEvent.PROGRESS				, sendProgress ) ;
			ed.addEventListener( IOErrorEvent.IO_ERROR				, sendError );
			ed.addEventListener( SecurityErrorEvent.SECURITY_ERROR	, sendError );
			ed.addEventListener( Event.OPEN							, sendOpen );
		}
		
		protected function unregister ( ) : void {
			if( ! _ed ) return;
			_ed.removeEventListener( Event.INIT							, onInit );
			_ed.removeEventListener( Event.COMPLETE						, sendComplete );
			_ed.removeEventListener( ProgressEvent.PROGRESS				, sendProgress ) ;
			_ed.removeEventListener( IOErrorEvent.IO_ERROR				, sendError );
			_ed.removeEventListener( SecurityErrorEvent.SECURITY_ERROR	, sendError );
			_ed.removeEventListener( Event.OPEN							, sendOpen );
			_ed = null;
		}
		
		//_____________________________________________________________________________
		//																	   Dispatch
		
		/**
		 * specifique a Loader
		 */
		protected function onInit( e : Event ) : void {
			dispatchEvent( e );
		}
		
		
		
		bi_internal var _request 			: URLRequest;
		bi_internal var _context 			: LoaderContext;
		bi_internal var _statusMessage 	: String;
		bi_internal var _failOnError : Boolean;
		
		//_____________________________________________________________________________
		//																		Implement IProgressor
		
		public function sendError ( e : ErrorEvent ) : void {
			dispatchEvent( new BatchErrorEvent( ErrorEvent.ERROR, this, e.text, _failOnError ) );
		}
		
		public function sendProgress (e : ProgressEvent) : void {
//			dispatchEvent( new BatchProgressEvent( BatchProgressEvent.ITEM_PROGRESS, false, e.bytesLoaded, e.bytesTotal ) );
			dispatchEvent( e );
		}
		
		public function sendOpen (e : Event) : void {
			dispatchEvent( e );
		}
		
		public function sendComplete (e : Event) : void {
			unregister( );
			dispatchEvent( e );
		}

		public function sendStatus ( e : StatusEvent ) : void {
			dispatchEvent( new StatusEvent ( StatusEvent.STATUS, false, false, _statusMessage || ("loading "+request.url ) ) );
		}

		private var _ed : IEventDispatcher;

	}
}
