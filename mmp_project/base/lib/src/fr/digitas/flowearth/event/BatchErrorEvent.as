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
	
	import flash.events.ErrorEvent;
	import flash.events.Event;	

	/**
	 * Event dispatché par les IBatchable en cas d'erreur.
	 * 
	 * permet d'arreter le batch en cas d'erreur, via la propriété failOnError.
	 * 
	 * @author Pierre Lepers
	 */
	final public class BatchErrorEvent extends ErrorEvent implements IBatchEvent {

		
		public static const ITEM_ERROR : String = "fdf_bitemError";

		public static const ERROR : String = ErrorEvent.ERROR;

		
		/**
		 * indique au batcher si il doit arreter le batch en cas d'erreur
		 * @see Batcher#failOnError
		 */
		public function get failOnError () : Boolean {
			return _failOnError;	
		}

		/**
		 * item d'origine qui a provoqué l'erreur dans le batcher
		 * 
		 * different de target si il a des batcher imbriqué
		 * 
		 * en cas de decoration d'item ( UnsecureBatchItem, CryptedBLoader etc ), 'item' doit etre le decorateur, alors que target peut etre le décoré (item d'origine );
		 */
		public function get item () : IBatchable {
			if( _item )return _item;
			return target as IBatchable;	
		}

		override public function get target() : Object {
			return _item;
		}

		/**
		 * Event dispatché par les IBatchable en cas d'erreur.
		 * 
		 * permet d'arreter le batch en cas d'erreur, via la propriété failOnError.
		 * 
		 * @param type type d'Event
		 * @param text text d'info sur l'erreur
		 * @param failOnEror indique si le batcher doit s'arreter ou non en cas d'erreur (true), ou passer a l'item suivant (false). false par defaut
		 * @param item Ibatchable a l'origine de l'erreur. Automatiquement definie a e.target si le parametre n'est pas specifié ( en gros pas besoin de s'en occuper ) 
		 */
		public function BatchErrorEvent (type : String, item : IBatchable, text : String = "", failOnEror : Boolean = false, bubbles : Boolean = true ) {
			super( type, bubbles, false, text );
			_failOnError = failOnEror;
			_item = item;
		}
		
		override public function clone() : Event {
			return new BatchErrorEvent( type, item, text, failOnError, bubbles );
		}
		
		
		private var _failOnError : Boolean;
		private var _item : IBatchable;
		
		public static function getAdapter( e : ErrorEvent ) : BatchErrorEvent {
			if( e is BatchErrorEvent ) 
				return e as BatchErrorEvent;
			return new BatchErrorEvent( e.type, e.target as IBatchable , e.text, false, e.bubbles );
		}
	}
}
