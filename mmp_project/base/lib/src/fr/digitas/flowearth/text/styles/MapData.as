package fr.digitas.flowearth.text.styles {

	/**
	 * @author plepers
	 */
	final internal class MapData {

		public function MapData ( type : int, transtyper : Function ) {
			this.type = type;
			this.transtyper = transtyper; 
		}

		public function getMapping ( val : * ) : TypeMapping {
			return new TypeMapping( type, transtyper( val ) );
		}

		
		public var type : int;

		public var transtyper : Function;
		
	}
}
