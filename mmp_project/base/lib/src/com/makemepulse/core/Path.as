package com.makemepulse.core {
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class Path {
	
		static private var _url:String = '';
		
		static private var _base:String = '../../';
		//static private var _medias:String='medias/';
		static private var _medias:String='medias/';
		static private var _xml:String = _medias+'xml/';
		static private var _conf:String = _medias+'xml/conf/';
		static private var _images:String = _medias+'images/';
		static private var _sound:String = _medias+'sound/';
		static private var _swf : String = _medias+'swf/';
		static private var _styles : String = _medias+'styles/';
		static private var _videos : String = _medias+'videos/';
		static private var _pdf : String = _medias+'pdf/';
		static private var _locale : String = 'locales/';
		static private var _font:String=_medias+'fonts/';
		static private var _root : String = '';
		static private var _gateway : String = '';
		
		static private var _manifest:String='manifest.xml';

		static public function get url() : String {
			return _url;
		}

		static public function set url(value : String) : void {
			var pattern:RegExp = /(.*)\/w*/gi;
			_url = value.match(pattern)[0];
			if( _url.indexOf('file:///')!=-1 ) _root=_base;
			if( _url.indexOf('http://')!=-1 ) _root=_url+_base;	
		}

		static public function get xml() : String {
			return _root+_xml;
		}
		
		static public function get images() : String {
			return _root+_images;
		}
		
		static public function get videos() : String {
			return _root+_videos;
		}
		
		static public function get pdf() : String {
			return _root+_pdf;
		}

		static public function get sound() : String {
			return _root+_sound;
		}

		static public function get swf() : String {
			return _root+_swf;
		}
		
		static public function get font() : String {
			return _root+_font;
		}

		static public function get styles() : String {
			return _root+_styles;
		}
		
		static public function get locale() : String {
			return _root+_locale;
		}

		static public function set root(value : String) : void {
			_root = value;
		}

		static public function get root() : String {
			return _root;
		}

		static public function get gateway() : String {
			return _gateway;
		}

		static public function set gateway(value : String) : void {
			_gateway = value;
		}

		static public function get conf() : String {
			return  _root + _conf;
		}

		static public function get manifest() : String {
			return _manifest;
		}
		
		static public function set cdn(value : String) : void {
			_root=value;
			_medias="";
		}
		
		
		
        
       
    }
}