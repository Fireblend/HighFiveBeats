package org.firekare.beats;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;

/**
 * ...
 * @author Sergio Morales
 */

interface Screen
{
	function initialize():Void;
	function end(isQuitting:Bool, newScreen:Screen):Void;
	
	function handleFrame(event:Event):Void;
	function detectKey(event:KeyboardEvent):Void;
}