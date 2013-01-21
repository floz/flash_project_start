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

package fr.digitas.flowearth.event {
	import fr.digitas.flowearth.core.IDisposable;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;	

	/**
	 * Internally store list of listeners and add ability to remove them all.
	 * 
	 * @author Pierre Lepers
	 */
	public class DisposableEventDispatcher extends EventDispatcher implements IDisposable {

		
		public function DisposableEventDispatcher(target : IEventDispatcher = null) {
			super( target );
			_ls = new Array( );
		}
		
		/**
		 * remove all listeners added
		 */
		public function dispose() : void {
			var list : Listener;
			while( _ls.length > 0 ) {
				list = _ls.pop() as Listener;
				super.removeEventListener( list._type, list._listener, list._useCapture );
			}
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			var l : int = _ls.length;
			// TODO should be optimized with Array.filter() or stuff like that
			while( --l > - 1 ) 
				if( _ls[l].equal(type, listener, useCapture ) )
					_ls.splice( l, 1 );
			super.removeEventListener( type, listener, useCapture );
		}

		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			if( useWeakReference ) throw new Error( "bi.event.dispatcher.DisposableEventDispatcher - addEventListener : cannot useWeakReference" );
			_ls.push( new Listener( type, listener, useCapture ) );
			super.addEventListener(type, listener, useCapture, priority, false );
		}

		protected var _ls : Array;
	}
}

final class Listener {

	internal var _type : String;
	internal var _listener : Function;
	internal var _useCapture : Boolean;

	
	function Listener( type : String, listener : Function, useCapture : Boolean ) {
		_useCapture = useCapture;
		_listener = listener;
		_type = type;
	}

	
	internal function equal( type : String, listener : Function, useCapture : Boolean ) : Boolean {
		return ( type == _type && listener == _listener && useCapture == _useCapture );
	}
}
