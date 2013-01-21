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


package fr.digitas.flowearth.command.traverser {
	import fr.digitas.flowearth.command.Batcher;
	import fr.digitas.flowearth.command.IBatchable;
	import fr.digitas.flowearth.command.traverser.IBatchTraverser;	

	/**
	 * Abstract traverser, decorator implementation
	 * @author Pierre Lepers
	 */
	public class BaseTraverser implements IBatchTraverser {
		
		
		public function BaseTraverser( sub : IBatchTraverser = null ) {
			if( !sub ) sub = nullTraverser;
			_subTraverser = sub;
		}
		
		public function add( sub : IBatchTraverser ) : IBatchTraverser {
			_subTraverser =	_subTraverser.add( sub );
			return this;
		}

		public function enter (b : Batcher) : IBatchable {
			return _subTraverser.enter(b);
		}
		
		public function leave (b : Batcher) : void {
			_subTraverser.leave(b);
		}

		public function item (i : IBatchable) : IBatchable {
			return _subTraverser.item(i);
		}

		public function get subTraverser() : IBatchTraverser {
			return _subTraverser;
		}

		protected var _subTraverser : IBatchTraverser;
		
	}
}
