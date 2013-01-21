package com.makemepulse.core
{
	import fr.digitas.flowearth.text.fonts.fontsManager;
	import fr.digitas.flowearth.command.Batcher;
	import fr.digitas.flowearth.conf.Conf;
	import fr.digitas.flowearth.event.BatchEvent;
	import fr.digitas.flowearth.net.BatchLoaderItem;
	import fr.digitas.flowearth.net.BatchURLLoaderItem;
	import fr.digitas.flowearth.text.fonts.IFontsProvider;
	import fr.digitas.flowearth.text.styles.styleManager;

	import com.makemepulse.action.Action;
	import com.makemepulse.language.Translate;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;





	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class Application extends BasicApplication {
		
		
		private var _contextMenu:ContextMenuMMP;
		private static const _NS:String="http://www.makemepulse.com";
		private var _bIsCmMMP:Boolean=true;
		protected var _batcher : Batcher;
		
		public function Application( bIsCmMMP:Boolean=true ) 
		{
			_bIsCmMMP=bIsCmMMP;
		}
		
		override protected function _init():void 
		{
			super._init();
			
			_batcher = new Batcher();
			_batcher.addEventListener( ProgressEvent.PROGRESS, _handlerProgressLoading );
			_batcher.addEventListener( BatchEvent.ITEM_COMPLETE, _itemCompleteHandler );
			_batcher.addEventListener( Event.COMPLETE, _handlerCompleteLoading );
			
			if( _bIsCmMMP )
			{
				_contextMenu=new ContextMenuMMP(this);
				_contextMenu.addChildren("Powered by Make Me Pulse",0);
				_contextMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _handlerMenuItemSelect);
			}
			
			trace(this,"load conf---->"+Path.conf+Path.manifest);
			
			Conf.addEventListener( Event.COMPLETE, _handlerConfLoaded );
			Conf.loadXml( new URLRequest( Path.conf+Path.manifest ));
		}

		protected function _itemCompleteHandler(event : BatchEvent) : void {
			
		}

		private function _handlerMenuItemSelect( event:ContextMenuEvent ):void 
		{
			navigateToURL(new URLRequest(_NS));
		}

		private function _handlerConfLoaded( event:Event ) : void 
		{
			Conf.removeEventListener( Event.COMPLETE, _handlerConfLoaded );
			
			var default_locale:String = Conf.locales.@default.toString();
			var default_country:String = Conf.locales.@country.toString();
			Translate.locale = FlashVars.getValue( FlashVars.LOCALE, default_locale ) || "fr_FR";
			Translate.country = FlashVars.getValue( FlashVars.COUNTRY, default_country ) || "fr";

			trace(this,'Translate.locale----->'+Translate.locale);
			trace(this,'Translate.country----->'+Translate.country);
			
			Translate.getInstance().addEventListener(Event.COMPLETE,_handlerCompleteParseText);
			Translate.getInstance().parseMO();
		}

		private function _handlerCompleteParseText( event:Event ):void 
		{
			trace(this,"MO loaded and parsed");
			trace(this,Translate.getInstance().dict);
			
			var locale:String = XMLList( Conf.locales ).hasOwnProperty( Translate.locale ) ? Translate.locale : Conf.locales.@default.toString();
			var fontID:String=Conf.locales[ locale ].@fontID.toString();
			var styleID:String=Conf.locales[ locale ].@styleID.toString();
			var stylefile:String=Conf.styles.style.(@id==styleID).@file.toString();
			var fontfile:String=Conf.fonts.font.(@id==fontID).@file.toString();
			
			var requestFont : URLRequest = new URLRequest(Path.font+fontfile);
    		var itemFonts : BatchLoaderItem = new BatchLoaderItem( requestFont );
			itemFonts.addEventListener(Event.COMPLETE, _onFontsLoad);
    		_batcher.addItem(itemFonts);
			
			var requestCSS : URLRequest = new URLRequest(Path.styles+stylefile);
    		var itemCSS:BatchURLLoaderItem = new BatchURLLoaderItem( requestCSS );
			itemCSS.addEventListener(Event.COMPLETE, _onLoadCSS);
    		_batcher.addItem(itemCSS);
			
			_addItemsToLoad();
			
			trace(this,"load font---->"+Path.font+fontfile);
			trace(this,"load style---->"+Path.styles+stylefile);
			_batcher.execute();
		}

		protected function _addItemsToLoad():void
		{
		}
		
		private function _onFontsLoad( event:Event ):void 
		{
			var itemFonts : BatchLoaderItem = event.currentTarget as BatchLoaderItem;
			itemFonts.removeEventListener(Event.COMPLETE, _onFontsLoad);
			fontsManager.registerFonts( itemFonts.loader.content as IFontsProvider );
			trace(this,Font.enumerateFonts(false));
			trace(this, "loadedFONT");
		}

		private function _onLoadCSS( event:Event ):void 
		{			
			var itemCSS : BatchURLLoaderItem = event.currentTarget as BatchURLLoaderItem;
			itemCSS.removeEventListener( Event.COMPLETE, _onLoadCSS );
			styleManager.addCss( itemCSS.data );
			styleManager.autoEmbed = true;
			
			trace(this, "loadedCSS");
		}		

		protected function _handlerProgressLoading(event : ProgressEvent) : void {
			
		}

		private function _handlerCompleteLoading( event:Event ):void 
		{
			_batcher.removeEventListener( ProgressEvent.PROGRESS, _handlerProgressLoading );
			_batcher.removeEventListener( BatchEvent.ITEM_COMPLETE, _itemCompleteHandler );
			_batcher.removeEventListener( Event.COMPLETE, _handlerCompleteLoading );
			
			trace(this, "complete LOADING");
			_start();
		}
		
		protected function _start():void
		{
			//to override
		}
		
		protected function _pushCommandClass( eventName:String, command:Class ):Boolean 
		{
			return Action.getInstance().pushCommandClass( eventName, command );
		}
		
	}
}
