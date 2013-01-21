package com.makemepulse.core {
	import flash.display.DisplayObjectContainer;
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * FlashVar
	 * 
	 * ----------------
	 * + usage
	 * ----------------
	 * 
	 * FlashVar.getValue( key );
	 * FlashVar.setValue( key, value );
	 * FlashVar.hasKey( key );
	 * 
	 * @author David Ronai
	 */
	public class FlashVars {
		
		private static var _vars:Dictionary = new Dictionary();
		private static var _stage:Stage;
		private static var _root:DisplayObjectContainer;
		
		public static const LOCALE:String='locale';
		public static const COUNTRY:String='country';
		public static const GATEWAY:String='gateway';
		public static const BASE_URL:String='baseurl';
		public static const CDN_URL:String='cdnUrl';
		
		public function FlashVars() {
			throw new Error("You can't create an instance of FlashVar");
		}
		
		public static function getValue( key:String, defaultValue:String="" ):String{
			if(_vars[key])
				return _vars[key];
			else if( _stage != null && _stage.loaderInfo.parameters[key] != null )
				return _stage.loaderInfo.parameters[key];
			else 
				return defaultValue;
		}
		
		public static function getURL():String{
			return _stage.loaderInfo.url;
		}
		
		public static function setValue( key:String, value:String="" ):void{
			_vars[key] = value;
		}
		
		public static function hasKey( key:String ):Boolean{
			return  getValue(key) ? true : false;
		}

		static public function set stage(value : Stage) : void{
			_stage = value;
		}

		static public function get stage() : Stage {
			return _stage;
		}

		static public function get root() : DisplayObjectContainer {
			return _root;
		}

		static public function set root(value : DisplayObjectContainer) : void {
			_root = value;
		}
	}

}