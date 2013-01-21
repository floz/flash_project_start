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
	import fr.digitas.flowearth.core.IIterator;
	import fr.digitas.flowearth.core.Pile;	

	/**
	 * Batcher's queue.
	 * 
	 * @author Pierre Lepers
	 */
	internal final class Batch extends Pile implements IIterator {
	
		public static const FIFO : Number = 0;
		public static const LIFO : Number = 1;
		
		
		public function get type () : Number { 
			return _type ; 
		}
		public function set type ( val : Number ) : void { _type = (val ==1 ) ? 1 : 0; }
		
		
		public function Batch() {
			super();
		}
	
		
		public function next() : Object {
			if( _type == 1 ) return removeItemAt( length-1 );
			return removeItemAt( 0 );
		}
	
		public function hasNext() : Boolean {
			return ( length > 0 );
		}
		
		
		override public function addItem( item : * ) : int {
			if( ! item ) throw new ArgumentError( "the item parameter must be not null." );
			if( indexOf(item) > -1 ) return -1;
			return super.addItem( item );
		}

		override public function addItemAt( item : * , index : uint ) : void {
			if( ! item ) throw new ArgumentError( "the item parameter must be not null.");
			if( indexOf(item) > -1 ) return;
			super.addItemAt( item, index );
		}
		
		private var _type : Number = 0;
		
	}
}
