package fr.digitas.flowearth.text.styles {

	/**
	 * @author plepers
	 */
	public final class TypeMapping {
		
		public static const STYLESHEET : int = 1;
		public static const TLF_FORMAT : int = 2;
		public static const TLF_CONFIG : int = 4;

		public function TypeMapping ( type : int, value : * ) {
			this.type = type;
			this.value = value;
		}

		public function handleStyleSheet () : Boolean {
			return (type & 1) == 1;
		}

		public function handleTlfFormat () : Boolean {
			return (type & 2) == 2;
		}

		public function handleTlfConfig () : Boolean {
			return (type & 4) == 4;
		}

		
		public var type : int;
		
		public var value : *;
		
	}
}
