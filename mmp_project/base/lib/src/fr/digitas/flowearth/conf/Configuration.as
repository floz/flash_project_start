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
	import fr.digitas.flowearth.bi_internal;
	import fr.digitas.flowearth.command.Batcher;
	import fr.digitas.flowearth.core.IProgressor;
	import fr.digitas.flowearth.event.BatchEvent;
	import fr.digitas.flowearth.net.BatchURLLoaderItem;
	
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;	

	/**
	 * dispatched after <code>loadXml</code> or <code>parseXml</code> has been called. To notify that all files (externalsXmlConf and externalData ) has been loaded and conf is ready.
	 * 
	 * @eventType Event#COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Dispatched when a file's loading begin (including externalsXmlConf and externalData ) 
	 * @eventType StatusEvent#STATUS
	 */
	[Event( name = "status", type = "fr.digitas.flowearth.event.BatchStatusEvent" )]

	/**
	 * dispatch the overall progression of loading.
	 * @eventType ProgressEvent#PROGRESS
	 * @private progression value can be wrong in most of case, because we don't know in advance the complete dependancy tree of initial conf file.
	 */
	[Event( name = "progress", type = "flash.events.ProgressEvent" )]	

	/** 
	 * Dispatched when an error occur while loading conf files (including externalsXmlConf and externalData ) 
	 * @see ErrorEvent#ERROR
	 */
	[Event( name = "error", type = "flash.events.ErrorEvent" )]	
	
	/**
	 * Dispatch when the loading start
	 * @see Event#OPEN
	 */
	[Event( name = "open", type = "flash.events.Event" )]

	/**
	 * @inheritDoc
	 * 
	 * @example 
	 * Here is a basic sample of Configuration usage :
	 * 
	 * <ul>
	 * 	<li>°1 The property 'basepath' is added to configuration. This property wil be used to solve other properties.</br>
	 * 	this 'basepath' property can be overrided by the grabParam method, lets you change the default value "." - used in standalone-  when swf is embed in html.
	 * 	</li>
	 * 	<li>°2 Listen to "complete" event, and start loading of xml file.</li>
	 * 	<li>°3 The Property "assets_dir" is solved. using dependancy 'basedir' and 'local'.</li>
	 * 	<li>°4 Modification of property 'local' invalidate 'assets_dir', it will be solved again to return the expected value.</li>
	 * 	<li>°5 the 'basepath' property can change depending you run the swf in this html page or in standalone</li>
	 * </ul>
	 *
	 * @includeExample confSampleA.conf -noswf
	 * 
	 * @includeExample ConfSampleA.as
	 * @author Pierre Lepers
	 */
	dynamic final public class Configuration extends AbstractConfiguration implements IProgressor {

		
		private static var instance : Configuration;

		
		/**
		 * Acces to the singleton instance of Configuration.
		 * <p>You can also use public constant <code>Conf</code>.</p>
		 * 
		 * @return singleton instance of Configuration
		 * @see Conf
		 */
		public static function getInstance () : Configuration {
			if (instance == null)
				instance = new Configuration( );
			return instance;
		}
		
		/**
		 * @private
		 * Constructor
		 */
		public function Configuration () {
			super( );
			if( instance != null ) throw new Error( "[bi.conf.Configuration] deja instancié" );
			
			_ed = new EventDispatcher( this );
			init();
		}

	

		
		//________________________________________________________________________________________________________________________
		//																								  RÉCUPERATION DES DONNÉES
		
		

		
		/**
		 * return a URLRequest object base on property String.
		 * @param propName : Object : a String or the QName of the property to retreive
		 * @return URLRequest - URLRequest
		 * @deprecated may be removed in furtur release
		 * @throws Error if the property with the given name doesn't exist
		 */	
		public function getURLRequest ( name : Object ) : URLRequest {
			var split : Array = getString( name ).split( "?" );
			var request : URLRequest = new URLRequest( split[0] );
			
			if( split[1] != undefined ) request.data = new URLVariables( split[1] );
			
			return request;
		}
		
		
		
	
		
		/**
		 * Convert <code>LoaderInfo.parameters</code> in Configuration properties.
		 * @param LoaderInfo - <code>LoaderInfo</code> to read.
		 */
		public function grabParam ( loaderInfo : LoaderInfo ) : void 
		{
			var params : Object = loaderInfo.parameters;
			for(var i:String in params) setProperty( i, params[i] );
		}
		
		
	
		
		//________________________________________________________________________________________________________________________
		//________________________________________________________________________________________________________________________
		//																												  PRIVATES

		
		bi_internal function getBatcher () : Batcher {
			return _globalBatch;
		}

		private function init () : void {
			_globalBatch = new Batcher(  );
			
			this.statusMessage = "Load Configuration";
			_globalBatch.addEventListener( Event.COMPLETE			, sendComplete );
			_globalBatch.addEventListener( ErrorEvent.ERROR			, sendError );
			_globalBatch.addEventListener( StatusEvent.STATUS		, sendStatus );
			_globalBatch.addEventListener( ProgressEvent.PROGRESS	, sendProgress );
			_globalBatch.addEventListener( Event.OPEN				, sendOpen );
			
			_globalBatch.addEventListener( BatchEvent.ADDED			, _addedToBatch );
			_globalBatch.addEventListener( BatchEvent.REMOVED		, _removedFromBatch );
		}		

		
		override protected function addExternalRequest(req : URLRequest, params : Object, index : int = -1) : void {
			var l : BatchURLLoaderItem = new BatchURLLoaderItem( req, params, "load configuration file : " + req.url );
			l.addEventListener( Event.COMPLETE, _onExternalComplete, false, 10 );
			if ( index > -1)
				_globalBatch.addItemAt( l, index );
			else
				_globalBatch.addItem( l );

			if( !_batched ) _globalBatch.start( );
		}

		override protected function addDataRequest(req : URLRequest, params : Object, index : int = -1) : void {
			var l : BatchURLLoaderItem = new BatchURLLoaderItem( req, params, "load data file : " + req.url );
			l.addEventListener( Event.COMPLETE, _onDataToPreloadComplete, false, 10 );
			if ( index > -1)
				_globalBatch.addItemAt( l, index );
			else
				_globalBatch.addItem( l );

			if( !_batched ) _globalBatch.start( );
		}

		
		
		private function _onExternalComplete ( e : Event ) : void 
		{
			var item : BatchURLLoaderItem = e.currentTarget as BatchURLLoaderItem;
			item.removeEventListener( Event.COMPLETE, _onExternalComplete );
			_handleExt( XML( item.data ), item.params.space );
		}
		
		
		
		private function _onDataToPreloadComplete ( e : Event ) : void 
		{
			var item : BatchURLLoaderItem = e.currentTarget as BatchURLLoaderItem;
			item.removeEventListener( Event.COMPLETE, _onDataToPreloadComplete );
			var node : XML = item.params.node as XML;
			_handleDtl( item.data, node);
		}

		
		private function _addedToBatch ( e : BatchEvent ) : void {
			_batched = true;
		}		

		private function _removedFromBatch ( e : BatchEvent ) : void {
			_batched = false;
		}
			


		//_____________________________________________________________________________
		//														  IMPLEMENT IProgressor
		
		/** @private */
		public function sendStatus( e : StatusEvent ) 		: void {	dispatchEvent( e );	}		
		/** @private */
		public function sendProgress( e : ProgressEvent	) 	: void {	dispatchEvent( e ); }		
		/** @private */
		public function sendError	( e : ErrorEvent	) 	: void {	dispatchEvent( e ); }		
		/** @private */
		public function sendOpen (e : Event) 				: void {	dispatchEvent( e );}
		/** @private */
		public function sendComplete (e : Event)			: void {	
			_globalBatch.stop();	
			dispatchEvent( e );
		}
		

		
		
		//_____________________________________________________________________________
		//													 IMPLEMENT IEventDispatcher
		/** @private */
		public function dispatchEvent (event : Event) : Boolean {
			return _ed.dispatchEvent( event );
		}		
		/** @private */
		public function hasEventListener (type : String) : Boolean {
			return _ed.hasEventListener( type );
		}		
		/** @private */
		public function willTrigger (type : String) : Boolean {
			return _ed.willTrigger( type );
		}		
		/** @private */
		public function removeEventListener (type : String, listener : Function, useCapture : Boolean = false) : void {
			_ed.removeEventListener( type, listener, useCapture );
		}		
		/** @private */
		public function addEventListener (type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_ed.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		private var _globalBatch : Batcher;
		private var _batched : Boolean = false;
		private var _ed : EventDispatcher;
		
		
	}
}




