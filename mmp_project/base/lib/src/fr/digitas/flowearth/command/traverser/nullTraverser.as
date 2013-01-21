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

package fr.digitas.flowearth.command.traverser 
{
/**
 * Constant for a <code>IBatchTraverser</code> witch has no effect.
 * @author Pierre Lepers
 */
	public const nullTraverser : IBatchTraverser = new NullTraverser();
}

import fr.digitas.flowearth.command.Batcher;
import fr.digitas.flowearth.command.IBatchable;
import fr.digitas.flowearth.command.traverser.IBatchTraverser;

class NullTraverser implements IBatchTraverser {

	public function enter (b : Batcher) : IBatchable {
		return b;
	}
	
	public function add( sub : IBatchTraverser ) : IBatchTraverser {
		return sub;
	}
	
	public function leave (b : Batcher) : void {
	}
	
	public function item (i : IBatchable) : IBatchable {
		return i;
	}
}

