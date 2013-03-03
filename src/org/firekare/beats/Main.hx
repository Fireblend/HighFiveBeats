package org.firekare.beats;

import nme.display.Sprite;
import nme.events.Event;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;
import nme.events.KeyboardEvent;

/**
 * ...
 * @author Sergio Morales
 */

class Main extends Sprite 
{
	public var screenWidth:Float;
	public var screenHeight:Float;
	public var background:GameStage;
	
	public var gameScreen:Screen;
	public var menuScreen:Screen;
	
	public var currentScreen:Screen;
	
	public function new() 
	{
		super();
		
		//Initialize core variables
		initialize();
		
		//Start the game
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		//Start detecting keystrokes
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, detectKey);
	}

	private function initialize() 
	{
		//Get stage dimensions
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		
		//Align stage
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		background = new GameStage(this);
		addChild(background);
		
		menuScreen = new MenuScreen(this);
		gameScreen = new GameScreen(this);
		//SCREEN_TITLE = new TitleScreen(this);
		goToScreen(menuScreen);
	}
	
	public function goToScreen(newScreen:Screen) {
		if(currentScreen!= null){
			currentScreen.end(false, newScreen);
		}
		else {
			goToScreen2(newScreen);
		}
	}
	
	public function goToScreen2(newScreen:Screen) {
		if(currentScreen!= null){
			var oldSpriteScreen:Sprite = cast(currentScreen, Sprite);
			removeChild(oldSpriteScreen);
		}
		currentScreen = newScreen;
		var spriteScreen:Sprite = cast(currentScreen, Sprite);
		spriteScreen = cast(currentScreen, Sprite);
		addChild(spriteScreen);
		currentScreen.initialize();
	}
	
	static public function main() 
	{
		Lib.current.addChild(new Main());
	}
	
	private function this_onEnterFrame(event:Event):Void {
		background.update();
		currentScreen.handleFrame(event);
	}
	
	public function detectKey(event:KeyboardEvent) {
		if (currentScreen != null) {
			currentScreen.detectKey(event);
		}
	}
}
