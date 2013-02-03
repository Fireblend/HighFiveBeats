package org.firekare.beats;
import nme.display.Shape;
import nme.display.Sprite;

/**
 * ...
 * @author Sergio Morales
 */

class GameStage extends Sprite
{
	private var lightCount : Int;
	private var lights : Array<Light>;	
	private var wall : Shape;
	private var floor : Shape;
	private var started : Bool;
	
	//We keep a reference to the main instance:
	private var mainInstance : Main;
	
	public function new( mainInstanceGiven: Main ) 
	{
		super();
		
		mainInstance = mainInstanceGiven;
		
		lightCount = 4;
		lights = new Array<Light>();
		
		//Create the wall and floor
		var width = mainInstance.screenWidth;
		var height = mainInstance.screenHeight;
		
		wall = new Shape();
		wall.graphics.beginFill ( 0xd4c0ff );  // the color of the rectangle
		wall.graphics.drawRect ( 0, 0, width, height);
		wall.graphics.endFill (); 
		addChild(wall);
		
		floor = new Shape();
		floor.graphics.beginFill ( 0xb38fff );  // the color of the rectangle
		floor.graphics.drawRect ( 0, height*0.7, width, height*0.3);
		floor.graphics.endFill (); 
		addChild(floor);
		
		//Create the lights
		for (i in 0 ... lightCount) {
			var newLight : Light = new Light(170, width/2, height/2);
			lights.push(newLight);
			addChild(newLight);
		}
		
		started = true;
	}
	
	
	public function update()
	{
		if(started){
			//Move the lights
			for (i in 0 ... lightCount) {
				lights[i].update(mainInstance.screenWidth, mainInstance.screenHeight);
			}
		}
	}
}