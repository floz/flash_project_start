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
	import flash.events.StatusEvent;	
	/**
	 * Permet de recuperer le status d'un IBatchable sous forme d'un tableau.
	 * 
	 * Si plusieur batcher sont imbriqués, le tableau contient les status de toute la hierarchie.
	 * 
	 * exemple:
	 * <pre>
	 * -- Batcher		 --> [ 0 : load image , 1 : load externals, 2 : load site]
	 *  |
	 *  |-- Batcher			 --> [ 0 : load image , 1 : load externals]
	 *    |
	 *    |-- BatchLoaderItem 		--> [ 0 : load image 2 ]
	 *   
	 * </pre>
	 * @author Pierre Lepers
	 */
	final public class BatchStatusEvent extends StatusEvent {
		
		
		public static const STATUS : String = StatusEvent.STATUS;
		
		/**
		 * liste des status recuperer dans la hierarchie de batch
		 */
		public function get messages() : Array {
			if(  _messages == null ) _messages = code.split( "||" );
			return _messages;	
		}

		
		public function get item() : IBatchable {
			return _item;
		}

		override public function get target() : Object {
			return _item;
		}

		/**
		 * Constructeur
		 * @param type type d'event
		 * @param message status du l'item qui dispatch
		 * @param baseStatus liste de status de l'evenuel sous item.
		 */
		public function BatchStatusEvent (type : String, item : IBatchable, message : String = null ,baseStatus : String = null, level : String = "status" ) {
			_item = item;
			if( baseStatus == null ) {
				baseStatus = "";
				if( message != null )
					baseStatus+= message;
			} else {
				if( message != null )
					baseStatus+= "||" + message;
				
			}
			
			
			
			super( type, true, false , baseStatus , level );
			
		}

		override public function clone () : Event {
			return new BatchStatusEvent (type, _item, null, code, level );
		}

		private var _item : IBatchable;
		
		private var _messages : Array;
	}
}
