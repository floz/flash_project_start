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

	/**
	 * Event a dispatcher par les <code>IBatchable</code>, passe un Ibatchable en parametre 
	 * 
	 * @author Pierre Lepers
	 */
	final public class BatchEvent extends Event implements IBatchEvent  {		
		//_____________________________________________________________________________
		//																   EVENTS TYPES
		
		public static const START : 	String = "fdf_bStart";
		
		public static const STOP : 	String = "fdf_bStop";
		
		public static const ITEM_START : 	String = "fdf_bitemStart";
		
		public static const ITEM_COMPLETE : String = "fdf_bitemComplete";

		public static const DISPOSED : String = "fdf_bdisposed";

		public static const ADDED : String = "fdf_baddedToBatch";

		public static const ITEM_ADDED : String = "fdf_bitemaddedToBatch";

		public static const REMOVED : String = "fdf_bremovedFromBatch";	

		public static const ITEM_REMOVED : String = "fdf_bitemremovedFromBatch";	

		public static const ADDED_TO_GROUP : String = "fdf_addedToGroup";

		public static const REMOVED_FROM_GROUP : String = "fdf_removedFromGroup";	

		
		
//		public static const BATCH_PROGRESS : String = "batchProgress";
		
		
		//_____________________________________________________________________________
		//																		EVENT
		
		
		public function get item () : IBatchable {
			return _item;	
		}

		override public function get target() : Object {
			if( _target ) return _target;
			return super.target;
		}

		public function BatchEvent (type : String, item : IBatchable, target : IBatchable = null, bubbles : Boolean = false, cancelable : Boolean = false ) {
			_target = target;			super(type, bubbles, cancelable );
			_item = item;
		}		
		override public function clone () : Event {
			return new BatchEvent( type, _item, target as IBatchable, bubbles, cancelable );
		}
		
		private var _item : IBatchable;

		private var _target : IBatchable;
			}}