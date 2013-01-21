package com.makemepulse.ui.form.validator {
	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class MonthValidator implements IValidator {
		
		
		public function MonthValidator(){
    	}
		
		public function isValid(o : * = null) : Boolean {
			if(o==null) return false;
            var nb:Number=(o.toString());
			if(nb<=0) return false;
			if(nb>12) return false;
			return true;
		}
	}
}
