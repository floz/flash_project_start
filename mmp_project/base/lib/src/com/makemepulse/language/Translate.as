package com.makemepulse.language
{
	//import com.adobe.serialization.json.JSON;
	import com.adobe.webapis.gettext.GetText;
	import com.makemepulse.core.Path;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	

	public class Translate extends EventDispatcher{
		
		private var _dict:Dictionary;
		public static var locale:String;
		public static var country:String;
		
		private var _bUseGetText:Boolean=false;
		
		private static var _oI:Translate=null;
		
		public function Translate(o : ConstructorAccess) {
			_dict= new Dictionary();
			_bUseGetText=false;
		}
		
		public static function getInstance() : Translate {
			if ( Translate._oI is Translate ) return Translate._oI;
			Translate._oI = new Translate(new ConstructorAccess());
			return  Translate._oI;
		}
		
		public function getValue( key:String ):String{
			if(_bUseGetText==true){
				return GetText.translate(key);
			}
			if( _dict[key] )
				return _dict[key];
			else 
				return key;
		}
		
		public function addKey(key:String, translation:String):void{
			_dict[key] = translation;
		}
		
		public function removeKey(key:String):void {
			delete _dict[key];
		}
		
		public function removeAll():void{
			_dict = null; 
			_dict = new Dictionary();
		}
		
		public function parseJSON(s:String):void{
			//trace( s );
			var o:Object= JSON.parse( s );//JSON.decode(s);
			for (var key:String in o) {
				addKey(key, o[key]);
			}
		}
		
		public function parseMO():void{
			_bUseGetText=true;
			GetText.getInstance().addEventListener(Event.COMPLETE, _handlerGetTextComplete);
			GetText.getInstance().addEventListener(IOErrorEvent.IO_ERROR, _handlerGetTextIOError);
			GetText.getInstance().addEventListener(SecurityErrorEvent.SECURITY_ERROR,_handlerGetTextSecurityError);
			GetText.getInstance().translation("default", Path.locale, locale);
			
			GetText.getInstance().install();
		}

		private function _handlerGetTextComplete(event : Event) : void {
			trace(this,"GET TEXT IS LOADED");
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function _handlerGetTextIOError(event : IOErrorEvent) : void {
			trace(this,"GET TEXT IO ERROR");
		}

		private function _handlerGetTextSecurityError(event : SecurityErrorEvent) : void {
			trace(this, "GET TEXT SECURITY ERROR");
		}

		public function get dict() : Dictionary {
			return _dict;
		}
	
	}
}

internal class ConstructorAccess {}

