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

package fr.digitas.flowearth.core {
	import flash.display.DisplayObject;						

	/**
	 * @author Pierre Lepers
	 */
	public interface IDisplayObjectContainer {
		
		function addChild(child : DisplayObject) : DisplayObject;

		function getChildByName(name : String) : DisplayObject;

		function getChildIndex(child : DisplayObject) : int;

		function setChildIndex(child : DisplayObject, index : int) : void;

		function addChildAt(child : DisplayObject, index : int) : DisplayObject;

		function contains(child : DisplayObject) : Boolean;

		function get numChildren() : int;

		function swapChildrenAt(index1 : int, index2 : int) : void;

		function getChildAt(index : int) : DisplayObject;

		function swapChildren(child1 : DisplayObject, child2 : DisplayObject) : void;

		function removeChildAt(index : int) : DisplayObject;

		function removeChild(child : DisplayObject) : DisplayObject;
		
	}
}
