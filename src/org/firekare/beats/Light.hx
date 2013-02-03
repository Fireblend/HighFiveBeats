package org.firekare.beats;
import nme.display.Shape;
import nme.display.Sprite;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author Sergio Morales
 */

class Light extends Sprite
{
	var xSpeed : Int;
	var ySpeed : Int;
	
	var lightShape : Shape;
	
	public function new(radius:Int, givenX:Float, givenY:Float) 
	{
		super();
		
		while(xSpeed == 0 && ySpeed == 0){
			xSpeed = (Std.random(3) - 1)*2;
			ySpeed = (Std.random(3) - 1)*2;
		}
		
		x = givenX;
		y = givenY;
		
		lightShape = new Shape();
		lightShape.graphics.beginFill(0xffffff);
		lightShape.graphics.drawCircle(0, 0, radius);
		lightShape.graphics.endFill ();
		alpha = 0.2;
		
		addChild(lightShape);
		
		correctPath();
	}
	
	public function update(width:Float, height:Float) 
	{
		x += xSpeed;
		y += ySpeed;
		
		//Turn back if its out of the screen.
		if (x > width) {
			xSpeed = -2;
		}
		else if (x < 0) {
			xSpeed = 2;
		}
		else if (y > height*0.7) {
			ySpeed = -2;
		}
		else if (y < 0) {
			ySpeed = 2;
		}
	}
	
	public function correctPath() {
		
		xSpeed = 0;
		ySpeed = 0;
		
		while(xSpeed == 0 && ySpeed == 0){
			xSpeed = (Std.random(3) - 1)*2;
			ySpeed = (Std.random(3) - 1)*2;
		}
		
		Actuate.timer (3+(Std.random(30)/10)).onComplete (correctPath, []);	
	}
}