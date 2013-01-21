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
	import fr.digitas.flowearth.command.IBatchable;	
	
	import flash.events.Event;
	import flash.events.ProgressEvent;	

	/**
	 * Dispatché par les Ibatchable.
	 * 
	 * Etend <code>ProgressEvent</code> mais gere la ponderation des items pour avoir une progression lineaire du batcher
	 * 
	 * @author Pierre Lepers
	 */
	public class BatchProgressEvent extends ProgressEvent {
		
		
		public static const ITEM_PROGRESS : String = "fdf_bitemProgress";
		
		public function get item() : IBatchable {
			return _item;
		}

		public function BatchProgressEvent (type : String, item : IBatchable, bubbles : Boolean = false, bytesLoaded : uint = 0, bytesTotal : uint = 0 ) {
			_item = item;
			super( type, bubbles, false, bytesLoaded, bytesTotal );
		}

		public override function clone () : Event {
			return new BatchProgressEvent( type, _item, bubbles, bytesLoaded, bytesTotal );
		}

		private var _item : IBatchable;
	}
}
