package mobile.flixel;

import flixel.FlxG;
import mobile.flixel.FlxButton;
import openfl.display.BitmapData;
import openfl.display.Shape;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import EngineSettings.Settings;

class FlxHitbox extends FlxSpriteGroup {
    public var poop:Bool = false;

	public var hitbox:FlxSpriteGroup;

	public var array:Array<FlxButton> = [];

	var hitboxColor:Map<Int, Array<Int>> = [
		4 => [
			Settings.engineSettings.data.arrowColor0,
			Settings.engineSettings.data.arrowColor1,
			Settings.engineSettings.data.arrowColor2,
			Settings.engineSettings.data.arrowColor3
		],
 	];

	public function new(?type:Int = 3) {
		super();
		hitbox = new FlxSpriteGroup();
		
		var keyCount:Int = type + 1;
		var hitboxWidth:Int = Math.floor(FlxG.width / keyCount);
		for (i in 0 ... keyCount) {
			hitbox.add(add(array[i] = createhitbox(hitboxWidth * i, 0, hitboxWidth, FlxG.height, hitboxColor[keyCount][i])));
      array[i].stringIDs = ['${type}_key_${keyCount}'];
		}
	}

	public function createhitbox(x:Float = 0, y:Float = 0, width:Int, height:Int, color:Int) {
		var hintTween:FlxTween = null;
		var button:FlxButton = new FlxButton(x, y);
		button.loadGraphic(createHintGraphic(width, height));
		button.color = color;
		button.updateHitbox();
		button.alpha = 0;

		if (!poop)
		{
			button.onDown.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(button, {alpha: Settings.engineSettings.data.hitboxOpacity}, Settings.engineSettings.data.hitboxOpacity / 100, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
			button.onUp.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(button, {alpha: 0}, Settings.engineSettings.data.hitboxOpacity / 10, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
			button.onOut.callback = function()
			{
				if (hintTween != null)
					hintTween.cancel();

				hintTween = FlxTween.tween(button, {alpha: 0}, Settings.engineSettings.data.hitboxOpacity / 10, {
					ease: FlxEase.circInOut,
					onComplete: function(twn:FlxTween)
					{
						hintTween = null;
					}
				});
			}
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return button;
	}

	override public function destroy():Void {
		super.destroy();
		for (hbox in array) {
			hbox = null;
		}
	}

	function createHintGraphic(Width:Int, Height:Int):BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.lineStyle(3, 0xFFFFFF, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.lineStyle(0, 0, 0);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		shape.graphics.beginGradientFill(RADIAL, [0xFFFFFF, FlxColor.TRANSPARENT], [0.7, 0], [0, 255], null, null, null, 0.5);
		shape.graphics.drawRect(3, 3, Width - 6, Height - 6);
		shape.graphics.endFill();
		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}
}
