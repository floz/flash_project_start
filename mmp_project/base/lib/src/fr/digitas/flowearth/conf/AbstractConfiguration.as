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

package fr.digitas.flowearth.conf {
	import fr.digitas.flowearth.conf.ExternalFile;
	
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;	
	
	use namespace AS3;
	
	/**
	 * The <code>Configuration</code> is designed to store properties parsed from a specific xml format.
	 * see <a href="http://code.google.com/p/flowearth/wiki/ConfigurationUsage">wiki</a> for details about Configuration.
	 * 
	 * @example The most basic example about configuration 
	 * @includeExample ConfSampleA.as
	 * 
	 * @author Pierre Lepers
	 * @see http://code.google.com/p/flowearth/wiki/ConfigurationUsage
	 */
	public class AbstractConfiguration extends Proxy {

		
		private static const DATA_TO_LOAD_NODE : String = "externalData";
		private static const EXTERNAL_NODE : String = "externalConf";
		private static const SWITCH_NODE : String = "switch";

		
		/**
		 * @private
		 * Constructeur
		 */
		public function AbstractConfiguration () {
			super( );
			
			_pProvider = new PropProvider();
		}

		
		/**
		 * Add a conf file to the list of conf file to load.
		 * <p>You can call this method multiple time. Requests are enqueued and executed sequentially.</p>
		 * @param urlRequest : URLRequest - configuration file to load.
		 */
		public function loadXml ( urlRequest : URLRequest ) : void {
			addExternalRequest(urlRequest, {}, 0);
			
		}

		
		/**
		 * Parse given XML to build Configuration properties.
		 * <p>this method can also initiate loadings of potential 'externalData' and 'externalConf' resources.</p>
		 * <p>You can enforce namespace of the parsed xml by passing a custom namespace to the second argument. If a default namespace already exist in the given xml, it will be replaced.</p>
		 * @param xml : XML - XML to parse
		 * @param inheritSpace - enforce usage of given Namespace to build properties
		 * @return le batch contanant les external a loader pour ce xml
		 */
		public function parseXml ( xml : XML, inheritSpace : Namespace = null ) : void {
			if( inheritSpace ) {
				xml.addNamespace( inheritSpace );
				xml.setNamespace( inheritSpace );
			}
			_parseDatas( xml );
		}		

		//________________________________________________________________________________________________________________________
		//																								  RÉCUPERATION DES DONNÉES
		
		
		/**
		 * Return a String representation of a property.
		 * <p>Note that String is the native value of a Configuration property.</p>
		 * @param propName : Object : a String or the QName of the property to retreive
		 * @return String - contenu de la propriété
		 * @throws Error if property with the given QName doesn't exist.
		 */	
		public function getString ( propName : Object ) : String {
			return getProperty( propName ).value; 
		}

		
		/**
		 * Return a boolean representation of a property.
		 * <p>return true if String lower case value of the property equals to "true" or "1". return false in other case.</p>
		 * @param propName : Object : a String or the QName of the property to retreive
		 * @return Boolean - renvoie true if <code>String.toLowerCase()</code> on the string value equal to <b>"true"</b> or <b>"1"</b>, false in all other cases.
		 * @throws Error if property with the given QName doesn't exist.
		 */	
		public function getBoolean ( propName : Object ) : Boolean {
			var val : String = getProperty( propName ).value.toLowerCase( );
			return (val == "true" || val == "1");
		}	

		
		/**
		 * return Number representation of a property.
		 * <p>return the result of <code>parseFloat()</code> method.</p>
		 * @param propName : Object : a String or the QName of the property to retreive
		 * @return Number - return the result of  <code>TopLevel.parseFloat()</code> on the string representation of the given property.
		 * @throws Error if property with the given QName doesn't exist.
		 */	
		public function getNumber ( propName : Object ) : Number {
			return parseFloat( getProperty( propName ).value );
		}

		/**
		 * return a XML object, containing the content of the given property.
		 * <p>The string representation of the property is convert to xml then surounded with an xml node named with the propery's localName.</p>
		 * renvoi un XML, toutes les propriété du conf ayant un contenu complexe peuvent etre recuperés via cette methode,<br>
		 * ainsi que les xml chargés via externalData
		 * @see http://livedocs.adobe.com/flex/2/langref/XML.html#hasComplexContent()
		 * @param propName : Object :a String or the QName of the property to retreive
		 * @return XMLList - renvoie un copie du noeud "propName" . Une nouvelle instance XML est renvoyé a chaque appel de cette methode
		 * @throws Error if property with the given QName doesn't exist.
		 */
		public function getDatas ( propName : Object ) : XML {
			var qn : QName = new QName( propName );
			var property:ConfProperty = getProperty( propName );
			if( property == null )
				return null;
			return XML( "<" + qn.localName + ">" + property.value + "</" + qn.localName + ">" );
		}	

	
		/**
		 * Renvoi true si la propriété existe, false sinon
		 * 
		 * @param propName : Object : a String or the QName of the property to retreive
		 * @return Boolean - true si la propriété existe, false sinon
		 */	
		public function hasProperty( propName : Object ) : Boolean 
		{
			return ( _pProvider.getProperty( new QName( propName ) ) != null );
		}

		
		
		
		/**
		 * Definie ou redefinie une propriété<br>
		 * les propriétés dependantes sont automatiquement afféctées
		 * @param name : String - a String or the QName of the property to set
		 * @param value : String - valeur de la propriété, peut contenir des variable( ${prop} ) 
		 */
		public function setProperty ( propName : Object, value : * ) : void 
		{
			var name : QName = new QName( propName );
			var prop : ConfProperty = _pProvider.getProperty( name );
			
			if( ! prop ) {
				
				var propNode : XML = <temp/>;
				propNode.addNamespace( name );
				propNode.setName( name );
				
				propNode.appendChild( XML( value ) );
				 _pProvider.setProperty( name , prop = new ConfProperty( propNode ) );
			}
			else {
				prop.invalidate( _pProvider );
				prop.source = value;
			}
		}
		
		
		/**
		 * supprime une propriété du conf.
		 * @param propName : Object : propriété a recuperer, l'object passé en parametre est casté en String
		 * @param killDependers : supprime les propriétés dependantes (false par defaut );
		 */
		public function deleteProperty( propName : Object, killDependers : Boolean = false) : void 
		{
			var name : QName = new QName( propName );
			var prop : ConfProperty =_pProvider.getProperty( name );
			var deps : Array = prop.getDependers();
			var dep : QName;
			if( killDependers )	
				for each ( dep in deps ) deleteProperty( dep, true );
			else {
				_resolveProperty( prop );
				for each ( dep in deps ) _pProvider.getProperty( dep ).breakDependancie( prop );
			}
			_pProvider.deleteProperty( name ) ;
		}
		

		public function hasSpace( uri : String ) : Boolean {
			return _pProvider.hasSpace( uri );
		}
		
		public function createSpace( uri : String, parentSpace : String = "" ) : void {
			_pProvider.createSpace( uri, parentSpace );
		}

		
		
		
		/**
		 * supprime un namespace du Conf et toutes les prop associées
		 * @param uri : String : uri du namespace a supprimer
		 */
		public function deleteSpace( uri : String = null ) : void 
		{
			_pProvider.deleteSpace( uri ) ;
		}

		
		public function solve( str : String, ns : Namespace = null ) : String 
		{
			var propNode : XML = <{TEMP_NAME}/>;
			var name : QName;
			if( ns ) {
				name = new QName( ns, TEMP_NAME );
				propNode.addNamespace( ns );
			} else name = new QName( TEMP_NAME );
			propNode.setName( name );
			propNode.appendChild( str );
			
			return new LazySolver( new ConfProperty( propNode), _pProvider ).solve();
		}

		
		protected function addExternalRequest( req : URLRequest, params : Object, index : int = -1 ) : void {
		
		}

		protected function addDataRequest( req : URLRequest, params : Object, index : int = -1 ) : void {
		
		}

		
		
		
		//________________________________________________________________________________________________________________________
		//________________________________________________________________________________________________________________________
		//																												  PRIVATES
		
		
		private function _parseDatas ( xml : XML ) : void {
			_retrieveNamespaceDeclaration( xml );
			
			var extract : ChildExtraction = _extract( xml );
			_buildProperties( extract.props );
			_computeSwitchs( extract.switches );
			_enqueue( extract );
		}

		
		//_____________________________________________________________________________
		//																	  NAMESPACE
		
		
		private function _retrieveNamespaceDeclaration( xml : XML ) : void
		{
			var namespaceList : Array = xml.namespaceDeclarations();
			for each( var ns : Namespace in namespaceList ) _pProvider.openNamespace( ns );
		}
		
		
		
		
		
		
		
		//_____________________________________________________________________________
		//																	 PROPERTIES


		protected function getProperty( pName : Object ) : ConfProperty 
		{
			var name : QName = new QName( pName);
			var prop : ConfProperty = _pProvider.getProperty( name, false );
			if( ! prop ) 
			{
				trace( "Unable to find '" + String( pName ) + "' property" );
				return null;
			}
			if( ! prop.resolved ) _resolveProperty( prop );
			return prop;
		}
		
		
		private function _buildProperties ( props :Array ) : void 
		{
			
			var prop : ConfProperty;
			var name : QName;
			var l : int = props.length;
			var propNode : XML;
			for (var i : int = 0; i < l; i++) {
				propNode = props[ i];
				name = new QName( propNode.name() );
				
				if( _pProvider.getProperty( name ) ) 
					setProperty( name, propNode.children( ).toString( ) );
				else 
				{
					prop = new ConfProperty( propNode );
					_pProvider.setProperty( name, prop );
				}
			}
		}

		
		private function _resolveProperty ( prop : ConfProperty ) : String 
		{
			if( prop.resolved ) return prop.value;
			return new Solver( prop, _pProvider ).solve();
		}


		private function _extract ( xml : XML ) : ChildExtraction {
			var res : ChildExtraction = new ChildExtraction();
			res.props.push( xml.conf[ 0 ] );
			
			var list : XMLList = xml.conf.children();
			var l : int = list.length();
			var node : XML;
			for (var i : int = 0; i < l; i++) {
				node = list[ i ];
				switch ( node.localName() ) {
					case DATA_TO_LOAD_NODE :
						res.dtls.push( node );
						break;
					case EXTERNAL_NODE :
						res.exts.push( node );
						break;
					case SWITCH_NODE :
						res.switches.push( node );
						break;
					default :
						res.props.push( node );
						break;
				}
			}
			
			return res;
		}
		

		//_____________________________________________________________________________
		//																		SWITCHS
		
		private function _computeSwitchs ( switches : Array ) : void 
		{
			var switchNode : XML;
			var ns : Namespace;
			var l  : int = switches.length;
			for (var i : int = 0; i < l; i++) {
				switchNode = switches[ i ];
				ns = switchNode.namespace();
				var prop : String = getString( new QName( ns.uri, switchNode.@property ) );
				
				var resultsNode : XMLList = switchNode.child(new QName( ns.uri, "case" ) ).( @value == prop );
				
				if( resultsNode.length() == 0 ) 
				{
					var caseNodes : XMLList = switchNode.child( new QName( ns.uri, "default" ) );
					
					if( caseNodes.length() == 1 )
						parseXml( caseNodes[0] );
				} 
				else parseXml( resultsNode[0] );
			}
		}
		
		
	
		private function _enqueue ( extract : ChildExtraction ) : void 
		{
			var exts : Array = extract.exts;
			var l : int = exts.length;
			var hspace : Namespace;
			var ext : XML;
			for (var i : int = 0; i < l; i++) {
				ext = exts[ i ];
				if( ext.@inheritSpace == "true" ) hspace = ext.namespace();
				else hspace =  null;
				_enqueExt( ext.descendants().( localName() == "file" ) , hspace );
			}
			
			exts = extract.dtls;
			l = exts.length;
			for (i = 0; i < l; i++) {
				ext = exts[ i ];
				_enqueDtl( ext.descendants().( localName() == "file" ) );
			}
			
		}
		
		private function _enqueExt ( list : XMLList, inheritSpace : Namespace = null ) : void {
			if( list == null ) return;
			
			var node : XML;
			for each( node in list ) 
			{
				var ef : ExternalFile = new	ExternalFile( node, this );
				addExternalRequest( ef.request, {node : node, space : inheritSpace} );
			}
		}

		private function _enqueDtl ( list : XMLList ) : void {
			
			if( list == null ) return;
			
			var node : XML;
			for each( node in list ) 
			{
				var ef : ExternalFile = new	ExternalFile( node, this );
				addDataRequest( ef.request, { node : node } );
			}
		}

		
		protected function _handleExt ( ext : XML, space : Namespace ) : void 
		{
			parseXml( ext, space );
		}
		
		
		
		protected function _handleDtl ( datas : String, node : XML ) : void 
		{
			
			var uri : String;
			
			if( node.namespace() ) uri = node.namespace().uri;
			else uri = null;
			// TODO gerer les prefix ns dans les id de xmlConf et dataToload
			setProperty( new QName( uri, node.@id ) , datas );
//			Logger.info( "bi.conf.Configuration - _onDataToPreloadComplete -- ", new QName( uri, node.@id ) );
//			setProperty( new QName( uri, node.@id.name ), item.data );
		}

		
	
		//_____________________________________________________________________________
		//																 PROXY OVERRIDE

		override flash_proxy function getProperty ( propName : * ) : * 
		{
			var name : QName = new QName( propName );
			
			var prop : ConfProperty = getProperty( propName );
			
			if( !prop ) return null;
			
			var n : Number;
			if( !isNaN( n = parseFloat( prop.value ) ) ) return n;

			if( !prop.hasSimpleContent ) {
				var data : XML = getDatas( name );
				if( data ) return data;	
			}
			
			return prop.value;
		}

		override flash_proxy function setProperty ( propName : *, value : *) : void 
		{
			var name : QName = new QName( propName );
			setProperty( name, value );
		}

		
		
		internal var _pProvider : PropProvider;

		
		private static const TEMP_NAME : String = "__temp__";
		
	}
}

import flash.utils.Dictionary;

//_____________________________________________________________________________
//																   CONFPROPERTY

//	 CCCCC   OOOO  NN  NN FFFFFF    PPPPPP  RRRRR    OOOO  PPPPPP  EEEEEEE RRRRR   TTTTTT YY  YY  
//	CC   CC OO  OO NNN NN FF        PP   PP RR  RR  OO  OO PP   PP EE      RR  RR    TT    YYYY   
//	CC      OO  OO NNNNNN FFFF      PPPPPP  RRRRR   OO  OO PPPPPP  EEEE    RRRRR     TT     YY    
//	CC   CC OO  OO NN NNN FF        PP      RR  RR  OO  OO PP      EE      RR  RR    TT     YY    
//	 CCCCC   OOOO  NN  NN FF        PP      RR   RR  OOOO  PP      EEEEEEE RR   RR   TT     YY




/**
 * @internal
 */
final internal class ConfProperty {
	
	use namespace AS3;
	
	internal function set source ( str : String ) : void {
		if( _locked ) return;
		resolved = false;
		if ( hasSimpleContent || source == null ) _source = str;
		else _source += str;
		if( _source.indexOf( "}" ) == -1 ) value = _source; 
	}
	
	

	internal function get source ( ) : String {
		return _source;
	}

	internal function set value ( str : String ) : void {
		resolved = true;
		_value = str;
	}

	internal function get value ( ) : String {
		return _value;
	}

	
	function ConfProperty ( propertyNode : XML ) {
		init(propertyNode);
	}

	internal function invalidate( properties : PropProvider ) : void {
		resolved = nresolved = false;
		if( _dependers == null ) return;
		for (var i : int = 0; i < _dependers.length; i++)
			properties.getProperty( _dependers[i] ).invalidate(properties);
	}

	internal function addDepender ( propName : QName ) : void {
		if( !_dependers ) _dependers = new Array( );
		if( _dependers.indexOf( propName ) == -1 ) _dependers.push( propName );
	}
	
	internal function breakDependancie ( prop : ConfProperty ) : void {
		if( ! _dependers ) return;
		var i : int = _dependers.indexOf( prop.name );
		if( i == -1 ) return;
		_dependers.splice( i, 1 );
		source.replace( S_TOKEN+ prop.name + E_TOKEN, prop.value );
	}

	internal function getDependers () : Array {
		return _dependers;
	}
	
//	internal function getNativeValue() : String {
//		if( ! nresolved ) setNativeValue(str)
//	}
	


	private function init ( d : XML ) : void 
	{
		name = new QName( d.name() );
		var ns : Namespace = d.namespace();
		uri  = ns.uri;
		
		
		
		if( hasSimpleContent = d.hasSimpleContent() ) {
			source = d.text( );
		} else // TODO Conf optimization - check existance of namespace before clean
			source = cleanNs( d.children( ).toXMLString( ) );
			
		_locked = ( d.@lock == "true" || d.@lock == "1" );
	}

	
	private function cleanNs( input : String ) : String {
		var r : RegExp = new RegExp( "xmlns(:\\w)?=\""+uri+"\"", "gi" );
		return input.replace( r , "" );
	}

	
	internal var uri 				: String;	
	internal var name 				: QName;	
	internal var resolved 			: Boolean;
	internal var nresolved 			: Boolean;
	internal var hasSimpleContent 	: Boolean;

	
	private var _locked 			: Boolean = false;
	private var _source 			: String;
	private var _value 				: String;
	private var _dependers 			: Array;
}




final internal class PropProvider {
	
	private static const DEFAULT_SPACE : String = "";
	
	public function PropProvider() {
		_spaces = new Dictionary();
		_pres = new Dictionary();
		_pres[null] = _pres[ "" ] = DEFAULT_SPACE;
		_spaces[ DEFAULT_SPACE ] = new PropSpace( DEFAULT_SPACE );
	}

	internal function setProperty( name : QName, prop : ConfProperty ) : void {
		var space : PropSpace = _spaces[ name.uri ];
		if( ! space ) space = createSpace( name.uri );
		space._dprop[ name.localName ] = prop;
	}

	internal function getProperty( name : QName, strict : Boolean = true ) : ConfProperty {
		
		
		var lname : String = name.localName;
		var solvedSpace : PropSpace = _spaces[ name.uri ];
		var res : ConfProperty;
		
		if( solvedSpace == null )
			return null;
		
		do{
			res = solvedSpace._dprop[ lname ];
			if( res ) return res;
		} while( (solvedSpace = solvedSpace._parent) && !strict );
		
		return null;
	}
	
	internal function deleteProperty( name : QName ) : void {
		delete _spaces[ name.uri ]._dprop[ name.localName ];
	}
	
	internal function openNamespace( ns : Namespace ) : void {
		if( ns.prefix == "" ) return;
		if( _pres[ ns.prefix ] != undefined && _pres[ ns.prefix ] != ns.uri ) throw new Error ( "Namaespace "+ns.prefix+" already defined" );
		_pres[ ns.prefix ] = ns.uri;
	}

	internal function namespace( pre : String ) : String {
		return _pres[ pre ];// || emptyNs;
	}
	
	internal function hasSpace( uri : String ) : Boolean
	{
		return _spaces[ uri ] != null;
	}
	
	internal function createSpace( uri : String, parentSpace : String = "" ) : PropSpace {
		if( _spaces[ uri ] ) throw new Error( "AbstractConfiguration.createSpace() : space '" + uri + "' already exist - use hasSpace( uri )");
		var res : PropSpace = new PropSpace( uri );
		var parent : PropSpace = _spaces[parentSpace];
		if( parent == null ) throw new Error( "AbstractConfiguration.createSpace() : invalid parent URI : '" + parentSpace + "'" );
		res._parent = parent;
		_spaces[ uri ] = res;
		return res;
	}

	internal function deleteSpace( uri : String ) : void {
		var space : PropSpace = _spaces[ uri ];
		var childSpaces : Array = space._childs;
		
		for (var i : int = 0; i < childSpaces.length; i++) {
			deleteSpace( ( childSpaces[i] as PropSpace )._uri );
		}
		
		for each (var prop : ConfProperty in space ) {
			var deps : Array = prop.getDependers();
			var dep : QName;
			if( !prop.resolved ) new Solver( prop, this );
			for each ( dep in deps ) getProperty( dep ).breakDependancie( prop );
			delete space[ prop.name ];
		}
		
		space.dispose();
		delete _spaces[ uri ];
	}

	internal var _pres : Dictionary;
	internal var _spaces : Dictionary;
}


final internal class PropSpace {

	
	
	public function PropSpace( uri : String ) {
		_uri = uri;
		_dprop = new Dictionary();
		_childs = [];
	}
	
	public function get parent() : PropSpace {
		return _parent;
	}
	
	public function set parent(parent : PropSpace) : void {
		if ( _parent ) _parent.removeChild( this );
		_parent = parent;
		if ( _parent ) _parent.addChild( this );
	}
	
	internal function addChild( space : PropSpace) : void{
		if( _childs.indexOf( space ) > -1 ) return;
		_childs.push( space );
	}

	internal function removeChild( space : PropSpace) : void{
		var ind : int = _childs.indexOf( space );
		if( ind == -1 ) return;
		_childs.splice( ind, 1 );
	}
	
	internal function dispose() : void {
		_childs = null;
		_dprop = null;
		_parent = null;
	}

	
	
	
	
	
	internal var _parent : PropSpace;

	internal var _childs : Array;

	internal var _dprop : Dictionary;

	internal var _uri : String;
	
}



//_____________________________________________________________________________
//																		 SOLVER
//			 SSSSS  OOOO  LL      V     V EEEEEEE RRRRR   
//			SS     OO  OO LL      V     V EE      RR  RR  
//			 SSSS  OO  OO LL       V   V  EEEE    RRRRR   
//			    SS OO  OO LL        V V   EE      RR  RR  
//			SSSSS   OOOO  LLLLLLL    V    EEEEEEE RR   RR 


/**
 * gere la resolution des variable du conf
 */
internal class Solver {
	
	use namespace AS3;
	
	public function Solver( prop : ConfProperty , properties : PropProvider ) {
		_provider = properties;
		_prop = prop;
	}

	internal function solve() : String {
		
		
		var r : String = _prop.value = process( _prop.source );
		
		var dependers : Array = _prop.getDependers( ) ;
		if( dependers ) {
			for (var i : int = 0; i < dependers.length; i++) {
				_provider.getProperty( dependers[i] ).resolved = false;
			}
		}
		
		_provider 	= null;
		_prop 		= null;
		
		return r;
	}
	
	private function process( input : String ) : String {
		
		var res : String;
		var si : int = -1;
		var se : int = -1;
		var c : int = 0;
		var ranges : Array = [];
		
		while( true ) {
			si = input.indexOf( S_TOKEN, si+1 );
			if( si == -1 ) break;
			
			se = input.indexOf( E_TOKEN, si );
			if( se == -1 ) break;
			
			ranges[c++] = si;
			ranges[c++] = se;
		}
		
		var token : String;
		var len : int = ranges.length;
		var psepIndex : int;
		res = input.substring( 0, ranges[0]);
		for (var i : int = 0; i < len; i+=2) {
			token = input.substring( ranges[i]+2, ranges[i+1] );
			psepIndex = token.indexOf( "::" );
			
			if( psepIndex == -1 ) 
				token = _propReplaceFunction( token, _prop.uri );
			else 
				token = _propReplaceFunction( token.substring( psepIndex+2 ), _provider.namespace( token.substring( 0, psepIndex ) ) );
			
			res += token;
			if( i+2 < len )
				res += input.substring( ranges[i+1]+1, ranges[i+2]);
			
		}

		res += input.substring( ranges[ranges.length-1]+1 );
		return res;
	}

	
	
	
	protected function _propReplaceFunction ( local : String, uri : String ) : String {
		
		var name : QName = new QName( uri, local );
		var prop : ConfProperty = _provider.getProperty( name, false );
		
		if( !prop ) 
			_provider.setProperty( name, prop = new ConfProperty( XML("<"+name.localName+"/>") ) );
		
		prop.addDepender( _prop.name );
		return ( prop.resolved ) ? prop.value : new Solver( prop, _provider ).solve(); 
	}
	

	
	protected var _prop : ConfProperty;
	protected var _provider : PropProvider;
}

/**
 * identique a Solver mais n'ajoute pas de depandance au propriétés, et de prop vide en cas de prop non defini
 */
final internal class LazySolver extends Solver {

	public function LazySolver( prop : ConfProperty , properties : PropProvider ) {
		super( prop, properties );
	}

	override protected function _propReplaceFunction ( local : String, uri : String ) : String {
		
		var name : QName = new QName( uri, local );
		var prop : ConfProperty = _provider.getProperty( name, false );
		if( !prop ) return "";
		return ( prop.resolved ) ? prop.value : new Solver( prop, _provider ).solve(); 
	}
}

class ChildExtraction {

	
	
	public function ChildExtraction() {
		switches = [];
		dtls = [];
		exts = [];
		props = [];
	}

	public var switches : Array;	
	public var dtls : Array;	
	public var exts : Array;	
	public var props : Array;	

}


//_____________________________________________________________________________
//																		 REGEXP
//		RRRRR   EEEEEEE  GGGGG  EEEEEEE X     X PPPPPP  
//		RR  RR  EE      GG      EE        X X   PP   PP 
//		RRRRR   EEEE    GG  GGG EEEE       X    PPPPPP  
//		RR  RR  EE      GG   GG EE        X X   PP      
//		RR   RR EEEEEEE  GGGGG  EEEEEEE X     X PP   q   

internal const S_TOKEN 				: String = "${" ;
internal const E_TOKEN 				: String = "}" ;






