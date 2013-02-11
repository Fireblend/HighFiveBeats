package org.firekare.beats;
import nme.display.Sprite;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Linear;

/**
 * ...
 * @author Sergio Morales
 */

class Prompt extends Sprite
{
	//Indicator graphic
	private var handButton:Sprite;
	private var handButtonGhost:Sprite;
	private var normalScale:Float;
	
	//Indicates how accurate a keypress is
	private var beatVal:Int;
	
	//Keep track of whether this prompt is pulsating or not
	public var pulsating:Bool;
	
	//The keyboard key to which this indicator responds
	public var responseKey:UInt;
	public var responseKeyMM:UInt;
	
	//Miss/good/great/perfect images
	private var imgMiss:Sprite;
	private var imgGood:Sprite;
	private var imgGreat:Sprite;
	private var imgPerfect:Sprite;
	
	private var imagesNormalScale:Float;
	
	//We'll do score-handling here as well
	public var score:Int;
	
	//These keep track of all user results
	public var missCount:Int;
	public var goodCount:Int;
	public var greatCount:Int;
	public var perfectCount:Int;
	
	public function new(size:Float) {
		
		super();
		
		//Get images
		handButton = Utils.loadGraphic ("img/hand.png", true);
		handButtonGhost = Utils.loadGraphic ("img/hand.png", true);
		
		//Get images for results
		imgMiss = Utils.loadGraphic ("img/miss.png", true);
		imgGood = Utils.loadGraphic ("img/good.png", true);
		imgGreat = Utils.loadGraphic ("img/great.png", true);
		imgPerfect = Utils.loadGraphic ("img/perfect.png", true);
		
		//Create permanent one and "ghost" indicator
		normalScale = size / handButtonGhost.width;
		
		//Resize them
		handButtonGhost.scaleX = normalScale ;
		handButtonGhost.scaleY = normalScale ;
		handButton.scaleX = normalScale ;
		handButton.scaleY = normalScale ;
		
		//Create size reference for result images
		imagesNormalScale = (size/2) / imgPerfect.height;
		
		//Resize results images accordingly:
		imgMiss.scaleX = imagesNormalScale;
		imgMiss.scaleY = imagesNormalScale;
		imgGood.scaleX = imagesNormalScale;
		imgGood.scaleY = imagesNormalScale;
		imgGreat.scaleX = imagesNormalScale;
		imgGreat.scaleY = imagesNormalScale;
		imgPerfect.scaleX = imagesNormalScale;
		imgPerfect.scaleY = imagesNormalScale;
		
		//Add to screen
		addChild(handButton);
		addChild(handButtonGhost);
		
		//Reset score variables
		score = 0;
		missCount = 0;
		goodCount = 0;
		greatCount = 0;
		perfectCount = 0;
		
		pulsating = false;
	}
	
	//Reset indicator, this is intended for every new game
	public function reset() {
		handButtonGhost.alpha = 0;
		handButtonGhost.x = 0;
		handButtonGhost.y = 0;
		handButtonGhost.scaleX = normalScale;
		handButtonGhost.scaleY = normalScale;
		
		//Reset score variables
		score = 0;
		missCount = 0;
		goodCount = 0;
		greatCount = 0;
		perfectCount = 0;
		
		pulsating = false;
	}
	
	//Reset indicator, this is intended for every pulsation
	public function resetHand() {
		handButtonGhost.alpha = 0;
		handButtonGhost.x = 0;
		handButtonGhost.y = 0;
		handButtonGhost.scaleX = normalScale;
		handButtonGhost.scaleY = normalScale;
		pulsating = false;
	}
	
	//Start pulsation
	public function pulsate(time:Float) {
		handButtonGhost.alpha = 0;
		
		//Make the indicator bigger
		handButtonGhost.x = -handButton.height*2;
		handButtonGhost.y = -handButton.width*2;
		
		//Adjust location
		handButtonGhost.scaleX = normalScale*5;
		handButtonGhost.scaleY = normalScale*5;
		
		pulsating = true;
		
		//Bring it back to original position in (time) seconds
		Actuate.tween (this, time, { beatVal: 10 } ).ease (Linear.easeNone);
		Actuate.tween (handButtonGhost, time, { alpha:1, x: 0, y: 0, scaleX: normalScale, scaleY: normalScale } ).ease (Quad.easeOut).onComplete(losePulsation);
		beatVal = 0;
	}
	
	//Last chance to get a HF in: 0.1 secs?
	public function losePulsation() {
		if (pulsating) {
			beatVal = 0;
			handlePress();
		}
	}
	
	public function handlePress() {
		if(pulsating){
			pulsating = false;
			//Stop current animation and mark as non-pulsating:
			Actuate.stop(handButtonGhost);
			Actuate.stop(this);
			resetHand();
			
			//Select new score and image to show in response to key press
			var imageToShow:Sprite = null;
			
			//We use alpha as an indicator of how accurate the press was
			if ( beatVal <= 3 ) {
				missCount++;
				imageToShow = imgMiss;
			}
			else if (beatVal <= 5) {
				goodCount++;
				score += 1;
				imageToShow = imgGood;
			}
			else if (beatVal <= 7) {
				greatCount++;
				score += 3;
				imageToShow = imgGreat;
			}
			else if (beatVal <= 10) {
				perfectCount++;
				score += 5;
				imageToShow = imgPerfect;
			}
			
			imageToShow.x = -imageToShow.width / 2;
			imageToShow.y = -imageToShow.height / 2;
			
			imageToShow.scaleX = imagesNormalScale;
			imageToShow.scaleY = imagesNormalScale;
			
			imageToShow.alpha = 0;
			
			addChild(imageToShow);
			
			Actuate.tween (imageToShow, 0.5, { alpha:1, scaleX: imagesNormalScale*2, scaleY: imagesNormalScale*2 } ).ease (Quad.easeOut).onComplete(removeChild, [imageToShow]);
		}
	}
}