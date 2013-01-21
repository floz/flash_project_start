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

package fr.digitas.flowearth.command {
	import fr.digitas.flowearth.command.IBatchable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;		

	/**
	 * This class can be used to extend capabilities of an existing <code>IBatchable</code>.
	 * 
	 * 
	 * 
	 * @author Pierre Lepers
	 */
	public class BatchableDecorator extends EventDispatcher implements IBatchable {

		
		
		public function BatchableDecorator( sub : IBatchable ) {
			super( null );
			if( !_sub ) _sub = sub;
			if( !_sub ) _sub = new NullBatchable( this );
		}
		
		public function decorate( sub : IBatchable ) : void {
			_sub = sub;
		}
		
		public function execute () : void {
		}
		
		public function valueOf() : IBatchable {
			return _sub;
		}

		public function set weight( val : Number ) : void {
			_size = val;
		}

		public function get weight() : Number {
			if( _size >= 0 ) return _size;
			return _sub.weight;
		}
		
		public function dispose () : void {
			_sub.dispose( );
		}
		
		public function findType( type : * ) : * {
			if( this is type ) 
				return this;
			else if( _sub is BatchableDecorator ) 
				return ( _sub as BatchableDecorator ).findType(type);
			else if( _sub is type )
				return _sub;
			return null;
		}

		
		
		override public function dispatchEvent ( event : Event ) : Boolean {
			return _sub.dispatchEvent( event );
		}
	
		override public function removeEventListener (type : String, listener : Function, useCapture : Boolean = false) : void {
			super.removeEventListener( type, listener, useCapture );
			if( ! hasEventListener(type) ) _sub.removeEventListener( type, proxyListener, useCapture );
		}

		override public function addEventListener (type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_sub.addEventListener( type, proxyListener, useCapture, priority, useWeakReference );
			super.addEventListener(type, listener, useCapture, priority, useWeakReference );
		}

		private function proxyListener( e : Event ) : void {
			super.dispatchEvent( e );
		}

		protected var _size : Number = -1;

		protected var _sub : IBatchable;
		
	}
}


//_____________________________________________________________________________
//																  NullBatchable

import fr.digitas.flowearth.command.IBatchable;
import fr.digitas.flowearth.event.DisposableEventDispatcher;

import flash.events.IEventDispatcher;

class NullBatchable extends DisposableEventDispatcher implements IBatchable {

	
	public function NullBatchable( target : IEventDispatcher ) {
		super( target );
	}
	
	public function get weight() : Number {
		return 1;
	}
	
	public function execute () : void {}	
}
