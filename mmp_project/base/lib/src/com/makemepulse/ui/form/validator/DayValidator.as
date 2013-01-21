package com.makemepulse.ui.form.validator {
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class DayValidator implements IValidator {
		
		
		public function DayValidator(){
    	}
		
		public function isValid(o : * = null) : Boolean {
			if(o==null) return false;
            var nb:Number=(o.toString());
			if(nb<=0) return false;
			if(nb>31) return false;
			return true;
		}
	}
}
