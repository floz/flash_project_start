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
	 * Useful traverser for deepely stop a tree structure of a batchers.
	 * 
	 * <listing version="3.0">
	 * rootBatcher.scan( new StopTraverser() );
	 * </listing>
	 * 
	 * @author Pierre Lepers
	 */
	public class StopTraverser implements IBatchTraverser {

		
		public function add(sub : IBatchTraverser) : IBatchTraverser {
			return this;
		}
		
		public function enter(b : Batcher) : IBatchable {
			b.stop();
			return b;
		}
		
		public function leave(b : Batcher) : void {
		}
		
		public function item(i : IBatchable) : IBatchable {
			return i;
		}
	}
}
