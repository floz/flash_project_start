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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;	

	/**
	 * IProgressor peut etre ecouté par une <code>ILoadingView</code> pour gerer l'affichage de la progression.
	 * 
	 * 
	 * 
	 * @author Pierre Lepers
	 */
	public interface IProgressor extends IEventDispatcher {		
		
		/**		 * doit dispatcher un StatusEvent.STATUS		 */		function sendStatus( e : StatusEvent ) : void;
				/**		 * doit dispatcher un ErrorEvent.ERROR		 */		function sendError( e : ErrorEvent ) : void;				/**		 * doit dispatcher un ProgressEvent.PROGRESS		 */		function sendProgress( e : ProgressEvent ) : void;
		/**		 * doit dispatcher un Event.OPEN		 */		function sendOpen ( e : Event ) : void;
		/**		 * doit dispatcher un Event.COMPLETE		 */		function sendComplete ( e : Event ) : void;		
	}
}
