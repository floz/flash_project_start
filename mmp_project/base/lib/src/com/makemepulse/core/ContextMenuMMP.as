package com.makemepulse.core {
	import flash.ui.ContextMenu;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;

	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */

	public class ContextMenuMMP extends EventDispatcher{

		private var _contextmenu : ContextMenu;
		
		private var _container : DisplayObjectContainer;

		private var _itemByCode : Dictionary;
		private var _aItems : Array;

		function ContextMenuMMP( pContainer : DisplayObjectContainer ) {
			_container = pContainer;
			init();
		}

		/**
		* 
		* @usage
		*/
		
		public function init () : void{			
			_contextmenu = new ContextMenu();
			_contextmenu.hideBuiltInItems();
			
			_container.contextMenu = _contextmenu;
			
			_itemByCode = new Dictionary();
			_aItems = new Array();
		}
		
		/**
		* 
		* @usage
		*/

		public function addChildren( pLabel : String, pIdx : int = -1, pData : Object = null, pSep : Boolean = false, pEnabled : Boolean = true ) : void {
			var item : ContextMenuItem = new ContextMenuItem( pLabel, pSep, pEnabled );
			
			if( pIdx > -1 ) _contextmenu.customItems.splice( pIdx, 0, item );
			else _contextmenu.customItems.push( item );
			
			_itemByCode[ item ] = pData;
			
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onSelectItem );
		}
		
		/**
		* 
		* @usage
		*/
		
		protected function onSelectItem( e : ContextMenuEvent ) :void{
			dispatchEvent( e );
		}
		
		/**
		* 
		* @usage
		*/
		
		public function getDataByLabel ( pLabel : String ) : Object{
			var n:int = _itemByCode.length();
			for (var i:int=0; i<n; i++) 
			{
				if( _itemByCode[i].label == pLabel )
					return _itemByCode[i];
			}
			
			return null;
		}
		
		/**
		* 
		* @usage
		*/
		
		public function getDataByItem ( pItem : ContextMenuItem ) : Object{
			return _itemByCode[ pItem ] as Object;
		}
		
		/**
		* 
		* @usage
		*/
		
		public function update () : void{
			init();
		}
		
		/**
		* 
		* @usage
		*/
		
		public function get contextmenu(  ) : ContextMenu
		{
			return _contextmenu;
		}

	}
}