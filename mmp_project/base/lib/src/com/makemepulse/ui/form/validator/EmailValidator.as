package com.makemepulse.ui.form.validator{	import com.makemepulse.ui.form.TextFieldRestrict;    /**     * @author Nicolas Rajabaly - nicolas@makemepulse.com     */    public class EmailValidator implements IValidator {    	    	public function EmailValidator(){    	}    	    	        public function isValid (o : * = null) : Boolean {            var str:String=o.toString();            var reg : RegExp = TextFieldRestrict.REGEXP_EMAIL;            var valid:Boolean=reg.test(str);            return valid;        }    }}