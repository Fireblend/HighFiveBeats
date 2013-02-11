package org.firekare.beats;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.text.TextField;
import nme.text.TextFormat;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;

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
	
	private var beatDuration:Int;
	
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
	
	public function new(main:Main) 
	{
		super();
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
		//3 Minutes per game
		timer = 180;
		
		//Reset prompts and characters
		for ( i in 0 ... 4 ) {
			prompts[i].reset();
			characters[i].reset();
		}
		
		//Start the game!
		started = true;
		
		//Start making prompts appear!
		executeThisEveryBeat();
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