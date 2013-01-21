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

package fr.digitas.flowearth.command {
	import fr.digitas.flowearth.core.IDisposable;
	
	import flash.events.IEventDispatcher;	

	/**
	 * Dispatched when this IBatchable is added to the queue of a <code>Batcher</code>.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>this IBatchable</th></tr>
	 * <tr><th>target</th><th>this IBatchable</th></tr>
	 * <tr><th>item</th><th>The Batcher in witch this IBatchable is added</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#ADDED
	 * @see Batcher#event:fdf_bitemaddedToBatch
	 */[Event( name = "fdf_baddedToBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	
	

	/**
	 * Dispatched when this IBatchable is removed from the queue of a <code>Batcher</code>.
	 * <p>this event is also dispatched after his Event.COMPLETE event. (when an item is complete, it is removed from the batcher's queue)</p>
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>this IBatchable</th></tr>
	 * <tr><th>target</th><th>this IBatchable</th></tr>
	 * <tr><th>item</th><th>The Batcher from witch this IBatchable is removed</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#REMOVED
	 */[Event( name = "fdf_bremovedFromBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	
	
	 
	/**
	 * Interface implemented by object that can be added to a <code>Batcher</code>'s queue.
	 * <p>It describe a simple (asynchronous) action. <code>Batcher</code> request the beginning of action by calling <code>#execute()</code> methode on this interface.
	 * Then wait for the completion of this action to execute the next items</p>
	 * 
	 * <p>In order to not freeze the batcher execution, this interface must dispatch one of these events to notify his completion :
	 * <ul>
	 * 	<li><code>ErrorEvent.ERROR</code></li>
	 * 	<li><code>Event.COMPLETE</code></li>
	 * 	<li><code>BatchEvent.DISPOSE</code></li>
	 * </ul>
	 * </p>
	 * <p>It can also dispatch following event to provide additionnal information to a batchers structure :
	 * <ul>
	 * <li><code>ProgressEvent.PROGRESS</code>, bubbles in <code>Batcher</code></li>
	 * <li><code>StatusEvent.STATUS</code>, bubble too.</li>
	 * </ul>
	 * </p>
	 * <p>Note that you don't have to dispatch <code>BatchEvent#ADDED</code> and <code>BatchEvent#REMOVED</code>. Dispatch of these events are automaticaly managed by container Batcher.</p>
	 * 
	 * 
	 * @author Pierre Lepers
	 * 
	 * @see Batcher
	 */
	public interface IBatchable extends IEventDispatcher, IDisposable {
		
		/**
		 * This method is called by <code>Batcher</code> when his previous item is complete and to run this new one.
		 * <p><b>After calling of this method, this item should dispatch one of these events</b> (synchronously or asynchronously) :
		 * <ul>
		 * 	<li><code>ErrorEvent.ERROR</code></li>
		 * 	<li><code>Event.COMPLETE</code></li>
		 * 	<li><code>BatchEvent.DISPOSE</code></li>
		 * </ul>
		 * in order to let following batcher's items be executed.</p>
		 * 
		 * You should not called this method directly.
		 */
		function execute() : void;
		
		/**
		 * A value with abstract unit, to describe weight of this <code>IBatchable</code>.
		 * <p>This value is used by <code>Batcher</code> to compute his overall progression.</p>
		 * 
		 * The default values for framework's implementations are 1.
		 */
		function get weight() : Number;
			}}