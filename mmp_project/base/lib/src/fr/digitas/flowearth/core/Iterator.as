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

package fr.digitas.flowearth.core 
{

	/**
	 * Provide an iterator object for a given <code>Array</code>.
	 * 
	 * Usefull to provide read-only acces to Array's elements.
	 * 
	 * <listing version="3.0">
	 * var iter : IIterator = new Iterator( myArray );
	 * 
	 * while( iter.hasNext() ) {
	 *    trace( iter.next() );
	 * }
	 * 
	 * //////////////
	 * 
	 * var iter : IIterator = new Iterator( myArray );
	 * 
	 * while( var item : Object = iter.next() ) {
	 *    trace( item );
	 * }
	 * 
	 * </listing>
	 * 
	 * @author Pierre Lepers
	 */
	public final class Iterator implements IIterator {
		
		public function Iterator( a : Array ) {
			_a = a;
			_c = 0;
		}
		
		public function next () : Object {
			return _a[_c++];
		}
		
		public function hasNext () : Boolean {
			return _a.length > _c;
		}
		
		private var _a : Array;
		private var _c : int;
		
	}
}
