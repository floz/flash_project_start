package com.makemepulse.language
{
	/**
	 * Like Translate.getValue(key);
	 *
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	 
	public function _(key:String) :String{
		return Translate.getInstance().getValue(key); 
	}

}