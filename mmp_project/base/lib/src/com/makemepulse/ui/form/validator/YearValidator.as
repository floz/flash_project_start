package com.makemepulse.ui.form.validator {
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class YearValidator implements IValidator {
		
		private var _current:Number;
		
		public function YearValidator(current:Number=2012){
			_current=current;
    	}
		
		public function isValid(o : * = null) : Boolean {
			if(o==null) return false;
            var nb:Number=(o.toString());
			if(nb<1900) return false;
			if(nb>_current) return false;
			return true;
		}
	}
}
