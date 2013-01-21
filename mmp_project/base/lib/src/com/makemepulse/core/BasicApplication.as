package com.makemepulse.core
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Nicolas Rajabaly - nicolas@makemepulse.com
	 */
	public class BasicApplication extends Sprite {
		
		public function BasicApplication() 
		{
			if (stage) _init();
			else addEventListener( Event.ADDED_TO_STAGE, _addedToStageHandler );
		}

		private function _addedToStageHandler( event:Event ):void
		{
			_init();
		}

		protected function _init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			stage.focus = this;
			stage.frameRate = 60;
			stage.showDefaultContextMenu=false;
			
			FlashVars.stage = stage;
			FlashVars.root=this;				
			Path.url=FlashVars.getURL();
			if(FlashVars.getValue(FlashVars.CDN_URL)!="")
			{
				Path.cdn=FlashVars.getValue(FlashVars.CDN_URL);
			}
			Path.gateway=FlashVars.getValue(FlashVars.GATEWAY,Path.gateway);			
		}
	}
}
