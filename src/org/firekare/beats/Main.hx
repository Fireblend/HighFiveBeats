package org.firekare.beats;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Sergio Morales
 */

class Main extends Sprite 
{
	public var screenWidth:Float;
	public var screenHeight:Float;
	public var background:GameStage;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
		//#end
	}

	private function init(e) 
	{
		//Get stage dimensions
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		
		background = new GameStage(this);
		addChild(background);
		
		// entry point
		
		// new to Haxe NME? please read *carefully* the readme.txt file!
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	private function this_onEnterFrame(event:Event):Void {
		background.update();
	}
}
