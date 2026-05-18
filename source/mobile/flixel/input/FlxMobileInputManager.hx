package mobile.flixel.input;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import mobile.flixel.input.FlxMobileInputID;
import mobile.flixel.FlxButton;
import haxe.ds.Map;

class FlxMobileInputManager extends FlxTypedSpriteGroup<FlxButton>
{
	public var trackedButtons:Map<FlxMobileInputID, FlxButton> = new Map<FlxMobileInputID, FlxButton>();

	public function new()
	{
		super();
		updateTrackedButtons();
	}

	public function buttonPressed(button:FlxMobileInputID):Bool
	{
		return anyPressed([button]);
	}

	public function buttonJustPressed(button:FlxMobileInputID):Bool
	{
		return anyJustPressed([button]);
	}

	public function buttonJustReleased(button:FlxMobileInputID):Bool
	{
		return anyJustReleased([button]);
	}

	public function anyPressed(buttonsArray:Array<Dynamic>):Bool
	{
		return checkButtonArrayState(buttonsArray, PRESSED);
	}

	public function anyJustPressed(buttonsArray:Array<Dynamic>):Bool
	{
		return checkButtonArrayState(buttonsArray, JUST_PRESSED);
	}

	public function anyJustReleased(buttonsArray:Array<Dynamic>):Bool
	{
		return checkButtonArrayState(buttonsArray, JUST_RELEASED);
	}

	public function checkStatus(button:Dynamic, state:ButtonsStates = JUST_PRESSED):Bool
	{
		switch (button)
		{
			case FlxMobileInputID.ANY:
				for (button in trackedButtons.keys())
				{
					checkStatusUnsafe(button, state);
				}
			case FlxMobileInputID.NONE:
				return false;

			default:
				if (trackedButtons.exists(button))
					return checkStatusUnsafe(button, state);
		}
		return false;
	}

	function checkButtonArrayState(Buttons:Array<Dynamic>, state:ButtonsStates = JUST_PRESSED):Bool
	{
		if (Buttons == null)
			return false;

		for (button in Buttons)
			if (checkStatus(button, state))
				return true;

		return false;
	}

	function checkStatusUnsafe(button:Dynamic, state:ButtonsStates = JUST_PRESSED):Bool
	{
		return switch (state)
		{
			case JUST_RELEASED: trackedButtons.get(button).justReleased;
			case PRESSED: trackedButtons.get(button).pressed;
			case JUST_PRESSED: trackedButtons.get(button).justPressed;
		}
	}

	public function updateTrackedButtons()
	{
		trackedButtons.clear();
		forEachExists(function(button:FlxButton)
		{
			if (button.IDs != null)
			{
				for (id in button.IDs)
				{
					if (!trackedButtons.exists(id))
					{
						trackedButtons.set(id, button);
					}
				}
			}
		});
	}
}

enum ButtonsStates
{
	PRESSED;
	JUST_PRESSED;
	JUST_RELEASED;
}