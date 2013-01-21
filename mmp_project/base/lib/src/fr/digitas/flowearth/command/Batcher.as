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
	import flash.errors.IllegalOperationError;	
	
	import fr.digitas.flowearth.command.traverser.IBatchTraverser;
	import fr.digitas.flowearth.command.traverser.nullTraverser;
	import fr.digitas.flowearth.core.IIterator;
	import fr.digitas.flowearth.core.IProgressor;
	import fr.digitas.flowearth.core.Iterator;
	import fr.digitas.flowearth.event.BatchErrorEvent;
	import fr.digitas.flowearth.event.BatchEvent;
	import fr.digitas.flowearth.event.BatchStatusEvent;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;		

	/**
	 * Dispatched when a descendant (<code>IBatchable</code>) is complete.
	 * This event is dispatched just after the "complete" Event of the target item.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>true. This event bubbles in a batchers structure</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>The object that is actively processing the Event object with an event listener.</th></tr>
	 * <tr><th>target</th><th>Always the Batcher containing the <code>IBatchable</code> whitch has complete</th></tr>
	 * <tr><th>item</th><th>The <code>IBatchable</code> whitch has complete</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#ITEM_COMPLETE
	 */

	[Event( name = "fdf_bitemComplete", type = "fr.digitas.flowearth.event.BatchEvent" )]

	/**
	 * Dispatched when a descendant (<code>IBatchable</code>) is about to be executed.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>true. This event bubbles in a batchers structure</th></tr>
	 * <tr><th>cancelable</th><th>true. you can use the preventDefault() method on this event to cancel the item execution. In this case, dispose() method will be called on item in place of execute()</th></tr>
	 * <tr><th>currentTarget</th><th>The object that is actively processing the Event object with an event listener.</th></tr>
	 * <tr><th>target</th><th>Always the Batcher containing the <code>IBatchable</code> about to be executed.</th></tr>
	 * <tr><th>item</th><th>The <code>IBatchable</code> about to be executed.</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#ITEM_START
	 */

	[Event( name = "fdf_bitemStart", type = "fr.digitas.flowearth.event.BatchEvent" )]

	/**
	 * dispatched when the last <code>IBatchable</code> of this Batcher's queue is complete.
	 * This event is dispatched after the "complete" Event of the last target item.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * </table>
	 * 
	 * @see Event#COMPLETE
	 */

	[Event( name = "complete", type = "flash.events.Event" )]

	/**
	 * dispatched when the batcher start. By "manualy" calling start() or execute() method, or if the batcher is started as an item of a parent batcher.
	 * This event will not be dispatched if the batcher is already in running mode.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false. Use BatchEvent#ITEM_START to handle item execution in parents batchers</th></tr>
	 * <tr><th>cancelable</th><th>true. you can use the preventDefault() method on this event to cancel the item execution. In this case, dispose() method will be called on item in place of execute()</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>item</th><th>Always the batcher itself.</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#START
	 * 
	 * @see Batcher#start()
	 * @see Batcher#run
	 * @see Batcher#execute()
	 */

	[Event( name = "fdf_bStart", type = "fr.digitas.flowearth.event.BatchEvent" )]

	/**
	 * Dispatched when the batcher leave running state. (if stop() methode is called).
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false.</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>item</th><th>Always the batcher itself.</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#STOP
	 * 
	 * @see Batcher#stop()
	 * @see Batcher#run
	 */

	[Event( name = "fdf_bStop", type = "fr.digitas.flowearth.event.BatchEvent" )]

	/**
	 * Distpatched when a descendant (<code>IBatchable</code>) dispatch the same <code>ProgressEvent#PROGRESS</code>.
	 * The progress value (<code>bytesLoaded</code>) is computed depending <code>weight</code> and progress values of each childs.
	 * The weight value of a <code>Batcher</code> is equal to the sum of all his childs.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false.</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>bytesLoaded</th><th>the progression of batcher depending of progression of all items. complete value is 10000 </th></tr>
	 * <tr><th>bytesTotal</th><th>Always 10000</th></tr>
	 * </table>
	 * 
	 * @see ProgressEvent#PROGRESS
	 * @see IBatchable#weight
	 */

	[Event( name = "progress", type = "flash.events.ProgressEvent" )]	

	/**
	 * Dispatched when this IBatchable is added to the queue of a <code>Batcher</code>.
	 * @copy IBatchable#event:fdf_baddedToBatch
	 */

	[Event( name = "fdf_baddedToBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	

	/**
	 * Dispatched when this IBatchable is removed from the queue of a <code>Batcher</code>.
	 * @copy IBatchable#event:fdf_bremovedFromBatch
	 */

	[Event( name = "fdf_bremovedFromBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	

	/**
	 * Dispatched after a <code>IBatchable</code> has been added to the queue of this Batcher.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false.</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>item</th><th>The IBatchable has been added to the queue.</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#ITEM_ADDED
	 */

	[Event( name = "fdf_bitemaddedToBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	

	/**
	 * Dispatched after a <code>IBatchable</code> has been removed from the queue of this Batcher.
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false.</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>target</th><th>Always the batcher itself.</th></tr>
	 * <tr><th>item</th><th>The IBatchable has been removed from the queue.</th></tr>
	 * </table>
	 * 
	 * @eventType BatchEvent#ITEM_REMOVED
	 */

	[Event( name = "fdf_bitemremovedFromBatch", type = "fr.digitas.flowearth.event.BatchEvent" )]	

	/**	 * Dispatched when an error occur while current <code>IBatchable</code> is processed.
	 * <p><code>ErrorEvent#ERROR</code> is handle by the Batcher in order to avoid batch to freeze. When a child error is handled, the item is removed form queue, except if the child is a Batcher itself.</p>
	 * <p>When a "error" event id dispatched by the current IBatchable, the Batcher dispatch this same event. triggered by his parent batcher, redispatched and so on.</p>
	 * <p>This lets you to listen all Errors Events on the root batcher of a batch structure.</p>
	 * <p>Even if the type of event is ErrorEvent.ERROR, <b>the event is an instance of BatchErrorEvent</b>, and provide you information about in witch item an error has occured.</p>
	 * <p>Note that Batcher only handle global ErrorEvent.ERROR type. Implementation of IBatchable should convert specific errors types (IOErrorEvent.IO_ERROR, SecurityErrorEevnt.SECURITY_ERROR) to ErrorEvent.ERROR.</p>
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>true</th></tr>
	 * <tr><th>cancelable</th><th>false. Find another way to prevent errors!</th></tr>
	 * <tr><th>currentTarget</th><th>the Batcher itself</th></tr>
	 * <tr><th>target</th><th>The IBatchable at the origin of the error</th></tr>
	 * <tr><th>item</th><th>The IBatchable at the origin of the error</th></tr>
	 * <tr><th>failOnError</th><th>A boolean value indiquate if the batcher should stop if the error occur</th></tr>
	 * </table>
	 * 
	 * @eventType ErrorEvent#ERROR
	 */

	[Event( name = "error", type = "fr.digitas.flowearth.event.BatchErrorEvent" )]	

	/**
	 * Dispatched when an error occur while current <code>IBatchable</code> is processed.
	 * <p>contrary to ErrorEvent.ERROR, this event not bubble in whole batcher parents.</p>
	 * <p>Note that you don't need to listen this event to avoid runtime error: if no listener are registered, this event isn't dispatched.</p>
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>false</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>the Batcher itself</th></tr>
	 * <tr><th>target</th><th>The IBatchable at the origin of the error</th></tr>
	 * <tr><th>item</th><th>The IBatchable at the origin of the error</th></tr>
	 * <tr><th>failOnError</th><th>A boolean value indiquate if the batcher should stop if the error occur</th></tr>
	 * </table>
	 * 
	 * @eventType BatchErrorEvent#ITEM_ERROR
	 */

	[Event( name = "fdf_bitemError", type = "fr.digitas.flowearth.event.BatchErrorEvent" )]	

	/**
	 * dispatched each time a descendant dispatch a StatusEvent. 
	 * <p>Even if the type is <code>StatusEvent#STATUS</code>, this event is an instance of <code>BatchStatusEvent</code></p>
	 * 
	 * <p>This event has the following properties :</p>
	 * <table class='innertable'>
	 * <tr><th>bubbles</th><th>true. this event can be listened on the parent batcher. status code are concat.</th></tr>
	 * <tr><th>cancelable</th><th>false</th></tr>
	 * <tr><th>currentTarget</th><th>the Batcher itself</th></tr>
	 * <tr><th>target</th><th>The IBatchable at the origin of the status</th></tr>
	 * <tr><th>item</th><th>The IBatchable at the origin of the status</th></tr>
	 * <tr><th>messages</th><th>An array containing all concatenated status codes, grabbed during bubbling.</th></tr>
	 * </table>
	 * 
	 * @eventType StatusEvent#STATUS
	 * @see statusMessage
	 */

	[Event( name = "status", type = "fr.digitas.flowearth.event.BatchStatusEvent" )]

	/**
	 * Execute a queue of actions represented by <code>IBatchable</code> items. Each item is executed when the previous one has dispatched a <code>Event.COMPLETE</code>.
	 * <p>Batcher class implement itself IBatchable, in other hand, a batcher can be added as an IBatchable item of a parent batcher.</p>
	 * <p>Batcher events flow is designed to can be use with deep batcher structure. Most of events bubbles into batchers structure, and provide reference to the "leaf" having initiate this event. In most of case, this lets you listening events on the only root batcher to handle all items events.</p>
	 * </br>
	 * <p>Batcher internaly use <code>Pile</code> to store his IBatchables collection. <code>Pile</code>'s methods are implemented by <code>Batcher</code> to manipulate queue of IBatchables.</p>
	 * <ul>
	 * 	<li>addItem()</li>
	 * 	<li>addItemAt()</li>
	 * 	<li>removeItem()</li>
	 * 	<li>removeItemAt()</li>
	 * 	<li>swapItems()</li>
	 * 	<li>setItemIndex()</li>
	 * 	<li>...</li>
	 * </ul>
	 * 
	 * <p>Note that a <code>IBatchable</code> cannot be into more than one batcher at the same time. If you add an item already in a batcher into another batcher, it will automatically removed from the first one.
	 * if you try to move the currently executed of the first batcher, an IllegalOperationError is thrown.
	 * </p>
	 * 
	 * @author Pierre Lepers
	 * 
	 * @example The following example show a simple implementation of batcher
	 * buildBatcher() create a batcher, add 4 <code>BatchLoaderItem</code> and listen some events on it. 
	 * @includeExample BatcherSampleA.as
	 * 
	 * @see IBatchable
	 * @see fr.digitas.flowearth.core.Pile
	 */
	public class Batcher extends EventDispatcher implements IProgressor, IBatchable {

		
		//____________________________________________________________________________
		//																		EVENTS
		/**
		 * batch order (FIFO ou LIFO)
		 * 
		 * <p>default is FIFO (0)</p>
		 * @param Number 0 pour une pile FIFO, 1 pour LIFO
		 * @default 0
		 * @see Batch
		 * @see Batch#FIFO
		 * @see Batch#LIFO
		 */
		public function set type( val : Number) : void { 
			_batch.type = val;
		}

		/** 
		@private */
		public function get type() : Number { 
			return _batch.type ; 
		}

		/**
		 * define if the batcher should be stopped when an error occured in items.
		 * 
		 * <p>Note that the batcher should also be stopped if the BatchErrorEvent received has his <code>BatchErrorEvent#failOnError</code> property set to true.</p>
		 * @default false
		 * @see BatchErrorEvent#failOnError
		 */
		public var failOnError : Boolean = false;

		/**
		 * <code>IBatchTraverser</code> called in sync with batcher execution.
		 * <p>contrary to <code>IBatchTraverser</code> provide as parameter of <code>scan</code> method, witch immediatly run through the whole structure. 
		 * This <code>IBatchTraverser</code> is called just before execution of an item (<code>IBatchTraverser.enter()</code> or <code>IBatchTraverser.item()</code>) and just after his completion (<code>IBatchTraverser.leave()</code>).</p>
		 * 
		 * <p><b>this property cannot be null</b>. Use the <code>nullTraverser</code> constant to provide a neutral traverser witch will not affect the batch.</p>
		 * 
		 * <p>Note that a traverser has the possibility to replace/remove items form a batcher. Implement IBatchTraverser carefully.</p>
		 * 
		 * @default <code>nullTraverser</code>. A neutral traverser which has no effect.
		 * @throws ArgumentError - if traverser is set to null.
		 * @see #scan()
		 * @see fr.digitas.flowearth.command.traverser.IBatchTraverser
		 */
		public function set traverser( t : IBatchTraverser ) : void {
			if( t == null ) throw new Error( "fr.digitas.flowearth.command.Batcher - traverser cannot be set to 'null'" );
			_traverser = t;
		}

		/**
		 * @private */
		public function get traverser() : IBatchTraverser {
			return _traverser;
		}

		
		/**
		 * Constructors
		 */
		public function Batcher() {
			_batch = new Batch( );
		}

		/**
		 * return the current executed <code>IBatchable</code>, or null if the batch doesn't currently execute items. 
		 * <p>This property is accessible just after <code>BatchEvent#ITEM_START</code> event.</p>
		 */
		public function getCurrentItem() : IBatchable {
			return _item;
		}

		/**
		 * Append the given <code>IBatchable</code> to the batcher queue.
		 * Item is immediately executed if the queue is empty when this method is called and the batcher is running (<code>run</code> is true, <code>start()</code> has been called )
		 * 
		 * <p>Note that an error can be thrown if the <code>IBatchable</code> you try to add is the current item running in another batcher.</p>
		 * 
		 * @param item : IBatchable , IBatchable to add
		 * @throws ArgumentError if the item param is <code>null</code>.
		 */
		public function addItem( item : IBatchable ) : void {
			if( _batch.addItem( item ) > - 1 ) itemAddingIn( item );
			next( ); 
		}
		
		public function addItemWithId( item:IBatchable, id:String ):void
		{
			_itemsById[ id ] = item;
			addItem( item );
		}

		/**
		 * Add the given <code>IBatchable</code> to the batcher queue, at the specified index.
		 * If the index is out of queue's bounds, item is append at the end of the queue.
		 * Item is immediately executed if the queue is empty when this method is called and the batcher is running (<code>run</code> is true, <code>start()</code> has been called )
		 * 
		 * <p>Note that an error can be thrown if the <code>IBatchable</code> you try to add is the current item running in another batcher.</p>
		 * 
		 * @param item : IBatchable to add
		 * @param index : index in the queue where the item will be added.
		 * @throws ArgumentError if the item param is <code>null</code>.
		 */
		public function addItemAt( item : IBatchable, index : uint ) : void {
			var nexist : Boolean = _batch.indexOf( item ) == - 1;
			_batch.addItemAt( item , index );
			if( nexist ) itemAddingIn( item );
			next( ); 
		}

		
		
		
		/**
		 * Remove an <code>IBatchable</code> from the queue.
		 * <p>The current item cannot be removed from a bacther.</p>
		 * 
		 * @param item l'<code>IBatchable</code> a supprimer
		 * @return index of the removed item or -1 if the item isn't in the queue.
		 */
		public function removeItem( item : IBatchable ) : int {
			
			var i : int = _batch.removeItem( item );
			if( i > - 1 ) itemRemoving( item );
			return i;
		}

		
		
		/**
		 * Remove the <code>IBatchable</code> at the given index, from the queue.
		 * 
		 * if index is out of queue's bounds, nothing is removed and <code>null</code> is returned.
		 * @param index index of the <code>IBatchable</code> to removed from queue.
		 * @return <code>IBatchable</code> removed from queue, or null if index is out of bounds.
		 */
		public function removeItemAt( index : uint ) : IBatchable {
			var item : IBatchable = _batch.removeItemAt( index );
			if( item ) itemRemoving( item );
			return item;
		}

		
		/**
		 * Change position of the given <code>IBatchable</code> to the new given index.
		 * 
		 * If the item doesn't exist in queue, nothing happen. 
		 * If index is out of queue's bounds, item is moved to the end of the queue.
		 * @param item <code>IBatchable</code> to move
		 * @param index the new position of item.
		 */
		public function setItemIndex( item : IBatchable , index : uint ) : void {
		
			_batch.setItemIndex( item , index );
		}

		
		/**
		 * Swap position of two items in the queue.
		 * 
		 * If one of items doesn't exist in queue, nothing happen. 
		 * @param item1 item to swap to 'item2' position
		 * @param item2 item to swap to 'item1' position
		 */
		public function swapItems( item1 : IBatchable, item2 : IBatchable ) : void {
			_batch.swapItems( item1 , item2 );
		}

		
		/**
		 * Swap positions of <code>IBatchable</code> at the two given index positions
		 * 
		 * If one of the given index is out of queue's bounds, nothing happen.
		 * @param index1 index of the first item to swap.
		 * @param index2 index of the second item to swap.
		 */
		public function swapItemsAt( index1 : uint, index2 : uint ) : void {
			_batch.swapItemsAt( index1 , index2 );
		}

		
		/**
		 * return the position of the given <code>IBatchable</code>.
		 * return -1 if item doesn't exist in the queue.
		 * 
		 * @param item object to find.
		 * @param fromIndex parametre facutlatif. indique l'index de debut de recherche.
		 * @return index of the given item, -1 if item doesn't exist in teh queue.
		 */
		public function indexOf( item : IBatchable, fromIndex : int = 0 ) : int {
			return _batch.indexOf( item , fromIndex );
		}

		
		/**
		 * return the <code>IBatchable</code> at the given position.
		 * return null if the index is out of of bounds.
		 * 
		 * @param index position of the object to find.
		 * @return item at the given position or null if index is out of bounds.
		 */
		public function getItemAt( index : uint ) : IBatchable {
			return _batch.getItemAt( index );
		}
		
		public function getItemWithId( id:String ):IBatchable
		{
			return _itemsById[ id ];
		}

		/**
		 * Replace one item by another one.
		 * If new item is <code>null</code>, teh old one is simply removed.
		 * If oldItem doesn't exist in queue, nothing  happen.
		 * 
		 * @param oldItem the item to replace
		 * @param newItem the new item
		 */
		public function replaceItem( oldItem : IBatchable, newItem : IBatchable ) : void {
			if( newItem == null ) removeItem( oldItem );
			else if( _batch.replaceItem( oldItem , newItem ) ) {
				itemAddingIn( newItem );
				itemRemoving( oldItem );
			}
		}

		
		/**
		 * return an <code>fr.digitas.flowearth.core.IIterator</code> of the queue.
		 * <p>Note that the item currently executed isn't in the iterator. </p>
		 * @return IIterator 
		 */
		public function getIterator() : IIterator {
			return new Iterator( _batch.array( ) );	
		}

		/** @private */
		public function get statusMessage() : String {
			return _statusMessage;
		}

		/**
		 * Status message of this batcher. 
		 * <p>if not null, message will be append to the list of messages grabbed by <code>BatchStatusEvent</code> during bubbling through batchers structure.</p>
		 * 
		 * @param statusMessage the status message.
		 * @see fr.digitas.flowearth.events.BatchStatusEvent
		 */
		public function set statusMessage(statusMessage : String) : void {
			_statusMessage = statusMessage;
		}

		/**
		 * Run the batcher.
		 * <p>The initial <code>run</code> value of a Batcher is false (pause mode). This mean that it will not execute his <code>IBatchable</code>.
		 * This method put the batcher in run mode (run=true). If queue contain at least one <code>IBatchable</code>, the first item is execute. Othewise, batcher stay in run mode and the next item added to queue will be executed.</p>
		 * 
		 * <p>Note that the only way to put the batcher in pause mode (run=false) is to manually call stop() method, or if an ErrorEvent occur with failOnError=true.
		 * Even if batcher has complete, it stay in run mode, and will execute newly added items. 
		 * By extension, a batcher added to a parent batcher, will execute items added after his own complete, out of the parent's control ( parent will not receved bubble events). And this because items witch are removed form the batcher queue.</p>
		 * 
		 * <code>BatchEvent#START</code> is dispatched after this method was called, if batcher was previously in pause mode.
		 * 
		 * @see Batcher#stop()
		 * @see Batcher#execute()
		 * @see Batcher#run
		 */
		public function start() : void {
			_startLen = _getChildsLenght( );
			if( _run ) return;
			addEventListener( BatchEvent.START , onDispatchStart , false , int.MAX_VALUE );
			_run = true;
			sendOpen( new Event( Event.OPEN ) );
			next( );
		}

		/**
		 * Put the batcher in pause mode (run=false).
		 * <p>Note that call this method has no effect on the item currently executed. This current item continue until his completion.
		 * That mean that <b>if the current item is itself a batcher, it will completely flush his queue.</b></p>
		 * 
		 * <code>BatchEvent#STOP</code> is dispatched after this method was called, if batcher was previously in run mode.
		 * 
		 * @example  
		 * <p>You can use a <code>StopTraverser</code> in order to deeply stop batchers structure :</p>
		 * <listing version="3.0"> 
		 *	rootBatcher.scan( new StopTraverser() );
		 * </listing>
		 * 
		 * @see Batcher#start()
		 * @see Batcher#run
		 */
		public function stop() : void {
			var r : Boolean = _run;
			_run = false;
			removeEventListener( BatchEvent.START , onDispatchStart );
			if( r ) dispatchEvent( new BatchEvent( BatchEvent.STOP , this , this ) );
		}

		
		/**
		 * return the state of the batch. this property is read only use <code>start()</code> and <code>stop()</code> to change this state.
		 * @return true if the start() method has been called and the batcher will execute items, false if the batcher is in "pause" mode.
		 */
		public function get run() : Boolean {
			return _run;
		}

		/**
		 * Remove all enqueued items, and call <code>IBatchable#dispose()</code> on the the item currently executed (if exist).
		 * 
		 * <p>batcher dispatch <code>BatcheEvent.DISPOSED</code> immediately after this method call, and is eventualy removed from a parent batcher.</p>
		 * 
		 * @inheritDoc
		 */
		public function dispose() : void {
			while ( _batch.hasNext( ) ) _batch.next( );
			if( _item != null ) {
				unregisterItem( _item );
				_item.dispose( );
			}
			
			var s:String;
			for( s in _itemsById )
				delete _itemsById[ s ];
			_itemsById = null;
			
			dispatchEvent( new BatchEvent( BatchEvent.DISPOSED , this ) );
		}

		
		/**
		 * Return the sum of children's weight. Used to compute overall progression of the batcher. 
		 * <p>This recursively get child's weight at each ProgressEvent, so the value is stored in private prop <code>_startLen</code>.</p>
		 * @TODO this _startLen value should be updated when items are removed or added form the batch after this accessor call.
		 * 
		 * @return Number the sum of the batcher's childs weight.
		 * @internal
		 */
		public function get weight() : Number {
			if( _startLen < 0 )
				_startLen = _getChildsLenght( );
			return _startLen;
		}

		/**
		 * Run a <code>IBatchTraverser</code> through all childs items, recursively. (Batcher child are scanned too an so on ).
		 * <p>Note that a traverser has the possibility to replace/remove items form a batcher. Implement IBatchTraverser carefully.</p>
		 * 
		 * @return IBatchable the result of the <code>IBatchTraverser#leave</code> method on this batcher.
		 * 
		 * @see Batcher#traverser
		 * @see fr.digitas.flowearth.command.traverser.IBatchTraverser
		 * @see IBatchTraverser
		 */
		public function scan( traverser : IBatchTraverser ) : IBatchable {
			var result : IBatchable = traverser.enter( this );
			var item : IBatchable;
			
			if( _item is Batcher )( _item as Batcher ).scan( traverser ) ;
			else if( _item ) traverser.item( _item );
				
			var list : Array = _batch.array( );
			for ( var i : Number = 0; i < list.length ; i ++ ) { 
				item = list[i];
				if( item is Batcher ) replaceItem( item , ( item as Batcher ).scan( traverser ) );
				else replaceItem( item , traverser.item( item ) );
			}
			traverser.leave( this );
			return result;
		} 

		//____________________________________________________________________________
		//																	  INTERNAL
		
		/**
		 * return the realtime weight. only item in queue + current item (recursively)
		 * contrary to weight getter whitch return the stored weight at batch start.
		 * @return l - realtime weight
		 */
		internal function _getChildsLenght() : uint {
			var l : uint = 0;
			
			for ( var i : Number = 0; i < _batch.length ; i ++ ) 
				l += _batch.getItemAt( i ).weight;
			
			if( _item ) l += _item.weight;
			return l;
		}

		//____________________________________________________________________________
		//																	  PRIVATES

		private function next() : void {
			if( _isRunning || ! _run ) return;
			if( _isRunning = _batch.hasNext( ) ) {
				_item = IBatchable( _batch.next( ) );
				_item = integrateTraverser( _item );
				if( ! _item ) next( );
				registerItem( _item );
				_executeItem( _item );
			} else {
				_item = null;
				sendComplete( new Event( Event.COMPLETE ) );	
			}
		}

		private function _executeItem(_item : IBatchable) : void {
			if( ! _item.dispatchEvent( new BatchEvent( BatchEvent.START , _item , _item , false , true ) ) )
				_item.dispose( ); 
			else 			
				_item.execute( );
		}

		private function registerItem( item : IBatchable ) : void {
			item.addEventListener( Event.COMPLETE , onItemComplete );
			item.addEventListener( BatchEvent.START , onItemStart );
			item.addEventListener( BatchEvent.ITEM_COMPLETE , onSubComplete );
			item.addEventListener( BatchEvent.ITEM_START , onSubItemStart );
			item.addEventListener( BatchEvent.DISPOSED , onCurrentItemDisposed );
			item.addEventListener( BatchEvent.ITEM_ADDED , onSubAdded );
			item.addEventListener( BatchEvent.ITEM_REMOVED , onSubRemoved );
			item.addEventListener( StatusEvent.STATUS , onItemStatus );
			item.addEventListener( BatchErrorEvent.ERROR , onItemError );
			item.addEventListener( ProgressEvent.PROGRESS , onItemProgress );
		}

		private function unregisterItem( item : IBatchable ) : void {
			item.removeEventListener( Event.COMPLETE , onItemComplete );
			item.removeEventListener( BatchEvent.START , onItemStart );
			item.removeEventListener( BatchEvent.ITEM_COMPLETE , onSubComplete );
			item.removeEventListener( BatchEvent.ITEM_START , onSubItemStart );
			item.removeEventListener( BatchEvent.DISPOSED , onCurrentItemDisposed );
			item.removeEventListener( BatchEvent.ITEM_ADDED , onSubAdded );
			item.removeEventListener( BatchEvent.ITEM_REMOVED , onSubRemoved );
			item.removeEventListener( StatusEvent.STATUS , onItemStatus );
			item.removeEventListener( BatchErrorEvent.ERROR , onItemError );
			item.removeEventListener( ProgressEvent.PROGRESS , onItemProgress );
		}

		private function itemAddingIn( item : IBatchable ) : void {
			if( _startLen > 0 ) _startLen += item.weight;
			item.dispatchEvent( new BatchEvent( BatchEvent.ADDED , this , item ) );
			item.addEventListener( BatchEvent.ADDED , itemAddingOut );
			item.addEventListener( BatchEvent.DISPOSED , onItemDisposed );
			dispatchEvent( new BatchEvent( BatchEvent.ITEM_ADDED , item , this ) );
		}

		private function itemAddingOut(event : BatchEvent) : void {
			var item : IBatchable = event.target as IBatchable;
			if( item == _item ) 
				throw new IllegalOperationError( "Batcher try to remove the currently running IBatchable." );
			removeItem( item );
		}		

		private function itemRemoving( item : IBatchable ) : void {
			if( _item != item && _startLen > 0 ) _startLen -= item.weight;
			item.dispatchEvent( new BatchEvent( BatchEvent.REMOVED , this , item ) );
			item.removeEventListener( BatchEvent.ADDED , itemAddingOut );
			item.removeEventListener( BatchEvent.DISPOSED , onItemDisposed );
			dispatchEvent( new BatchEvent( BatchEvent.ITEM_REMOVED , item , this ) );
		}

		/**
		 * prevent to dispatch BatchEvent.START if batcher already running
		 */
		private function onDispatchStart(event : BatchEvent) : void {
			event.stopImmediatePropagation( );
		}

		//______________________________________________________________
		//													  TRAVERSING
		
		private function integrateTraverser( item : IBatchable ) : IBatchable {
			if ( item is Batcher ) {
				var b : Batcher = ( item as Batcher );
				b.traverser = b.traverser.add( traverser );
				return traverser.enter( b );
			} else 
				return traverser.item( _item );
		}

		
		//_____________________________________________________________________________
		//																 ITEMS HANDLERS
		/** @private */
		protected function flushItem( ) : void {
			if( traverser && _item is Batcher ) traverser.leave( _item as Batcher ); 
			if( _item ) {
				unregisterItem( _item );
				itemRemoving( _item );
			}
			_isRunning = false;
			next( );
		}

		/** @private */
		protected function onItemComplete( e : Event ) : void {
			dispatchEvent( new BatchEvent( BatchEvent.ITEM_COMPLETE , _item , this , true ) );
			flushItem( );
		}

		/** @private */
		protected function onItemDisposed( e : BatchEvent ) : void {
			var item : IBatchable = e.currentTarget as IBatchable;
			removeItem( item );
		}

		/** @private */
		protected function onCurrentItemDisposed( e : BatchEvent ) : void {
			flushItem( );
		}

		/** @private */
		protected function onItemStart( e : BatchEvent ) : void {
			if ( ! dispatchEvent( new BatchEvent( BatchEvent.ITEM_START , _item , this , true , true ) ) )
				e.preventDefault( );
		}

		/** @private */
		protected function onItemProgress( e : ProgressEvent ) : void {
			var item : IBatchable = e.currentTarget as IBatchable;
			var l : uint = weight;
			var ppart : Number = e.bytesLoaded / e.bytesTotal * ( item.weight / l ) + 1 - _getChildsLenght( ) / l;
			sendProgress( new ProgressEvent( ProgressEvent.PROGRESS , false , false , ppart * 10000 , 10000 ) );
		}

		/** @private */
		protected function onItemError( evt : ErrorEvent ) : void {
			var e : BatchErrorEvent = BatchErrorEvent.getAdapter( evt );
			if( e.failOnError || failOnError ) stop( );
			sendError( new BatchErrorEvent( ErrorEvent.ERROR , e.item , e.text , e.failOnError || failOnError ) );
			if( ! ( _item is Batcher ) ) {
				if( hasEventListener( BatchErrorEvent.ITEM_ERROR ) )
					sendError( new BatchErrorEvent( BatchErrorEvent.ITEM_ERROR , _item , e.text , e.failOnError , false ) );
				flushItem( );
			}
		}

		/** @private */
		protected function onItemStatus( e : StatusEvent ) : void {
			sendStatus( new BatchStatusEvent( StatusEvent.STATUS , e.target as IBatchable , _statusMessage , e.code ) );
		}

		//_____________________________________________________________________________
		//																		Bubbles
		
		/** @private */
		protected function onSubItemStart( e : BatchEvent ) : void {
			if( ! dispatchEvent( e ) ) e.preventDefault( );
		}

		/** @private */
		protected function onSubComplete( e : BatchEvent ) : void {
			dispatchEvent( e );
		}

		/** @private */
		protected function onSubAdded( e : BatchEvent ) : void {
			dispatchEvent( e );
		}

		/** @private */
		protected function onSubRemoved( e : BatchEvent ) : void {
			dispatchEvent( e );
		}

		
		
		//_____________________________________________________________________________
		//												  IMPLEMENTATION DE IProgressor
		/** @private */
		public function sendStatus( e : StatusEvent ) : void { 
			dispatchEvent( e );	
		}		

		/** @private */
		public function sendProgress( e : ProgressEvent	) : void { 
			dispatchEvent( e ); 
		}		

		/** @private */
		public function sendError( e : ErrorEvent ) : void { 
			dispatchEvent( e ); 
		}		

		/** @private */
		public function sendOpen( e : Event ) : void { 
			dispatchEvent( e ); 
		}

		/** @private */
		public function sendComplete( e : Event ) : void { 
			dispatchEvent( e ); 
		}

		//_____________________________________________________________________________
		//												  IMPLEMENTATION DE IBatchable
		
		/** @private */
		public function execute() : void {	
			start( ); 
		}

		private var _traverser : IBatchTraverser = nullTraverser;

		private var _statusMessage : String;

		private var _batch : Batch;

		private var _item : IBatchable;

		private var _isRunning : Boolean = false;

		private var _run : Boolean = false;

		private var _startLen : Number = - 1;
		
		private var _itemsById:Object = {};

	}}