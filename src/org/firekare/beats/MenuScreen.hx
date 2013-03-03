package org.firekare.beats;
import nme.display.Shape;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

/**
 * ...
 * @author Sergio Morales
 */

class MenuScreen implements Screen, extends Sprite
{
	
	private var logo:Sprite;
	private var mmButton:Sprite;
	private var spButton:Sprite;
	private var main:Main;
	
	private var shapeUp:Shape;
	private var shapeDown:Shape;
	
	//Crear -  solo pasa 1 vez
	public function new(main:Main) {
		super();
		
		this.main = main;
		
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
		
		logo = Utils.loadGraphic ("img/logo.png", true);
		mmButton = Utils.loadGraphic ("img/mmButton.png", true);
		spButton = Utils.loadGraphic ("img/spButton.png", true);
		
		logo.x = main.screenWidth / 2 - logo.width / 2;
		logo.y = 30;
		
		mmButton.x = main.screenWidth / 5;
		mmButton.y = main.screenHeight/2+50;
		
		spButton.x = main.screenWidth-spButton.width-main.screenWidth / 5;
		spButton.y = main.screenHeight/2+50;
		
		Actuate.tween (logo, 1.5, { alpha: 0.2 } ).ease (Linear.easeNone).repeat().reflect ();
		
		addChild(logo);
		addChild(mmButton);
		addChild(spButton);
		
		mmButton.addEventListener(MouseEvent.MOUSE_UP, onMMButtonClick);
		spButton.addEventListener(MouseEvent.MOUSE_UP, onSPButtonClick);
	}
	
	public function onMMButtonClick(e:MouseEvent) {
		main.goToScreen(main.gameScreen);
	}
	
	public function onSPButtonClick(e:MouseEvent) {
		
	}
	
	//Se llama cada vez que se entra a esta pantalla
	public function initialize() {
		addChild(shapeUp);
		addChild(shapeDown);
		
		Actuate.tween (shapeUp, 1, { y: -main.screenHeight/2} ).ease (Linear.easeNone).onComplete(removeChild, [shapeUp]);
		Actuate.tween (shapeDown, 1, { y: main.screenHeight } ).ease (Linear.easeNone).onComplete(removeChild, [shapeDown]);
	}
	
	//Se llama cada vez que se sale de esta pantalla
	public function end(isQuitting:Bool, newScreen:Screen) {
		addChild(shapeUp);
		addChild(shapeDown);
		
		Actuate.tween (shapeUp, 1, { y: 0 } ).ease (Linear.easeNone);
		Actuate.tween (shapeDown, 1, { y: main.screenHeight / 2 } ).ease (Linear.easeNone).onComplete(main.goToScreen2, [newScreen]);
	}
	
	//Update - pasa cada frame
	public function handleFrame(event:Event) {
		
	}
	
	//Usuario presiono una tecla
	public function detectKey(event:KeyboardEvent) {
		
	}
}