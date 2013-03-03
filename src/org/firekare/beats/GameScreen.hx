package org.firekare.beats;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.display.Shape;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Linear;

/**
 * ...
 * @author Sergio Morales
 */

class GameScreen implements Screen, extends Sprite
{
	private var prompts:Array<Prompt>;
	private var characters:Array<Character>;
	private var timer:Int;
	private var started:Bool;
	private var wideSpaceFragment:Float;
	
	private var mainGame:Main;
	
	private var beatDuration:Float;
	
	//Constants for key codes
	private var LEFT:UInt;
	private var UP:UInt;
	private var RIGHT:UInt;
	private var DOWN:UInt;
	
	private var A:UInt;
	private var S:UInt;
	private var D:UInt;
	private var F:UInt;
	
	//Score texts
	private var scoreTexts:Array<TextField>;
	
	private var shapeUp:Shape;
	private var shapeDown:Shape;
	
	private var timerText:TextField;
	
	public function new(main:Main) 
	{
		super();
		
		//Initialize "curtains"
		shapeUp = new Shape();
		shapeUp.graphics.beginFill ( 0x000000 );  // the color of the rectangle
		shapeUp.graphics.drawRect ( 0, 0, main.screenWidth, main.screenHeight/2);
		shapeUp.graphics.endFill (); 
		shapeUp.y = 0;
		
		shapeDown = new Shape();
		shapeDown.graphics.beginFill ( 0x000000 );  // the color of the rectangle
		shapeDown.graphics.drawRect ( 0, 0, main.screenWidth, main.screenHeight / 2);
		shapeDown.graphics.endFill ();
		shapeDown.y = main.screenHeight/2;
		
		mainGame = main;
		
		//Initialize constants (this is stupid):
		LEFT = 37;
		UP = 38;
		RIGHT = 39;
		DOWN = 40;
		
		//Initialize constants (this is stupid):
		A = 65;
		S = 83;
		D = 68;
		F = 70;
		
		//Initialize the arrays:
		prompts = new Array<Prompt>();
		characters = new Array<Character>();
		scoreTexts = new Array<TextField>();
		
		//Do some size calculations:
		wideSpaceFragment = main.screenWidth / 5;
		var promptSize:Float = main.screenWidth / 12;
		
		//Define scores text format
		var scoreFormat:TextFormat = new TextFormat ("_sans", 30, 0xFFFFFF);
		
		//Initialize timer
		timerText = new TextField();
		
		timerText.text = "Time: 1:30";
		timerText.y = mainGame.screenHeight-timerText.height+40;
		timerText.x = 30;
		timerText.selectable = false;
		timerText.setTextFormat(scoreFormat);
		timerText.width = 500;
		
		addChild(timerText);
		
		//Create 4 new prompts and 4 new characters:
		for ( i in 0 ... 4 ) {
			var newPrompt:Prompt = new Prompt(promptSize);
			var newCharacter:Character = new Character();
			var newScoreText:TextField = new TextField();
			
			//Add to arrays
			prompts.push(newPrompt);
			characters.push(newCharacter);
			scoreTexts.push(newScoreText);
			
			//Setup text
			newScoreText.text = "P"+Std.string(i+1)+": 0";
			newScoreText.y = 30;
			newScoreText.x = wideSpaceFragment + (wideSpaceFragment * i) - 50;
			newScoreText.setTextFormat(scoreFormat);
			newScoreText.width = 500;
			newScoreText.selectable = false;
			
			//Locate prompts
			newPrompt.x = wideSpaceFragment + (wideSpaceFragment*i) - (promptSize/2);
			newPrompt.y = (main.screenHeight / 4) - (promptSize / 2);
			
			//Locate characters
			
			
			//Add to stage
			addChild(newPrompt);
			addChild(newCharacter);
			addChild(newScoreText);
		}
		
		//Assign MakeyMakey keys to each prompt:
		prompts[0].responseKeyMM = LEFT;
		prompts[1].responseKeyMM = UP;
		prompts[2].responseKeyMM = RIGHT;
		prompts[3].responseKeyMM = DOWN;
		
		//Assign keys to each prompt:
		prompts[0].responseKey = A;
		prompts[1].responseKey = S;
		prompts[2].responseKey = D;
		prompts[3].responseKey = F;
		
		//1 beat = 2 seconds
		beatDuration = 2;
		
		started = false;
	}
	
	public function initialize() 
	{
		//2 Minutes per game
		timer = 90;
		
		//Reset prompts and characters
		for ( i in 0 ... 4 ) {
			prompts[i].reset();
			characters[i].reset();
		}

		addChild(shapeUp);
		addChild(shapeDown);
		
		Actuate.tween (shapeUp, 1, { y: -mainGame.screenHeight/2} ).ease (Linear.easeNone).onComplete(removeChild, [shapeUp]);
		Actuate.tween (shapeDown, 1, { y: mainGame.screenHeight } ).ease (Linear.easeNone).onComplete(removeChild, [shapeDown]);
		
		Actuate.timer(1).onComplete(showCountDown, [3, null]);
	}
	
	
	public function showCountDown(cdVal: Int, previousCD: Sprite) {
		
		if(previousCD != null)
			removeChild(previousCD);
		var cd : Sprite ;
		
		if (cdVal == 3)
			cd = Utils.loadGraphic ("img/cd_3.png", true);
		else if (cdVal == 2)
			cd = Utils.loadGraphic ("img/cd_2.png", true);
		else if (cdVal == 1)
			cd = Utils.loadGraphic ("img/cd_1.png", true);
		else
			cd = Utils.loadGraphic ("img/cd_go.png", true);
		
		cd.x = (mainGame.screenWidth / 2) - (cd.width / 2);
		cd.y = (mainGame.screenHeight / 2) - (cd.height / 2);
		
		addChild(cd);
		
		if(cdVal > 0)
			Actuate.tween(cd, 1.4, { alpha: 0 } ).ease (Quad.easeOut).onComplete(showCountDown, [cdVal - 1, cd]);
		else {
			Actuate.tween(cd, 1, { alpha: 0, scaleX: 2, scaleY: 2, x: cd.x - cd.width / 2, y:cd.y - cd.height / 2 } ).ease (Quad.easeOut).onComplete(removeChild, [cd]);
			
			//Start the game!
			started = true;
			
			//Start making prompts appear!
			Actuate.timer(1).onComplete(executeThisEveryBeat);
			
			Actuate.tween(this, timer, { timer: 0 } ).ease(Linear.easeNone).snapping().onUpdate(updateTimer).onComplete(mainGame.goToScreen, [mainGame.menuScreen]);
		}
			
	}
	
	public function updateTimer() {
		//Define scores text format
		var scoreFormat:TextFormat = new TextFormat ("_sans", 30, 0xFFFFFF);
		
		var minutes:Int;
		var seconds:Float;
		
		minutes = Std.int(timer / 60);
		seconds = timer % 60;
		
		if(seconds > 9){
			timerText.text = "Time: " + Std.string(minutes) + ":" + Std.string(seconds);
		}
		else {
			timerText.text = "Time: " + Std.string(minutes) + ":0" + Std.string(seconds);
		}
		timerText.setTextFormat(scoreFormat);
		
		if (timer < 30) {
			beatDuration = 1;
		}
		else if (timer < 60) {
			beatDuration = 1.5;
		}
	}
	
	public function executeThisEveryBeat() {
		
		var pulsatingPrompts:Int = 0;
		
		//Reset prompts and characters
		for ( i in 0 ... 4 ) {
			if (prompts[i].pulsating) {
					pulsatingPrompts++;
			}
		}
		
		//Don't do anything if the game hasn't started yet or there are already 2 pulsating prompts
		if (!started || pulsatingPrompts == 1) {
			//Schedule next beat
			Actuate.timer (beatDuration/2).onComplete (executeThisEveryBeat, []);
			return;
		}
		
		var selectedOk:Bool = false;
		
		var selected:Int = 0;
		
		while (!selectedOk) {
			selected = Std.random(4);
			if (!prompts[selected].pulsating) {
				selectedOk = true;
				prompts[selected].pulsate(beatDuration);
			}
		}
		
		//Schedule next beat
		Actuate.timer (beatDuration/2).onComplete (executeThisEveryBeat, []);
	}
	
	
	public function end(isQuitting:Bool, newScreen:Screen) {
		addChild(shapeUp);
		addChild(shapeDown);
		
		Actuate.tween (shapeUp, 1, { y: 0 } ).ease (Linear.easeNone);
		Actuate.tween (shapeDown, 1, { y: mainGame.screenHeight / 2 } ).ease (Linear.easeNone).onComplete(mainGame.goToScreen2, [newScreen]);	
	}
	
	public function detectKey(event:KeyboardEvent) {
		//Don't do anything if the game hasn't started yet
		if (!started) {
			return;
		}
		
		//Check each prompt's response keys
		for (i in 0 ... 4) {
			var prompt:Prompt = prompts[i];
			if (event.keyCode == prompt.responseKey || event.keyCode == prompt.responseKeyMM) {
				//Handle the press
				prompt.handlePress();
			}
		}
		
		//trace("The keypress code is: " + event.keyCode); //Debugging
	}
	
	public function handleFrame(event:Event) {
		//Don't do anything if the game hasn't started yet
		if(!started){
			return;
		}
		
		//Update scores
		for (i in 0 ... 4) {
			scoreTexts[i].text = "P"+Std.string(i+1)+": " + Std.string(prompts[i].score);
			var scoreFormat:TextFormat = new TextFormat ("_sans", 30, 0xFFFFFF);
			scoreTexts[i].setTextFormat(scoreFormat);
		}
		
		
	}
}