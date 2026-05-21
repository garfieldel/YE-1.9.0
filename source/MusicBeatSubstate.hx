package;

import dev_toolbox.ToolboxMessage;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxCamera;
#if mobile
import mobile.flixel.FlxVirtualPad;
import mobile.flixel.FlxHitbox;
#end

class MusicBeatSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	#if mobile
	var _button:FlxVirtualPad;
	var _dpad:FlxVirtualPad;
	var _cam:FlxCamera;

	public function addButton(?action:FlxActionMode) {
		_button = new FlxVirtualPad(action);

		_cam = new FlxCamera();
	    _cam.bgColor.alpha = 0;
		FlxG.cameras.add(_cam, false);

		_button.cameras = [_cam];
		add(_button);
	}

	public function addDPad(?dpad:FlxDPadMode) {
		_dpad = new FlxVirtualPad(dpad);

		_cam = new FlxCamera();
	    _cam.bgColor.alpha = 0;
		FlxG.cameras.add(_cam, false);

		_dpad.cameras = [_cam];
		add(_dpad);
	}

	public function removeButton() {
		remove(_button);
	}

	public function remobeDPad() {
		remove(_dpad);
	}
	#end

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();


		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}

	public function onDropFile(path:String) {
		
	}

    function showMessage(title:String, text:String) {
        var m = ToolboxMessage.showMessage(title, text);
        m.cameras = cameras;
        openSubState(m);
    }
}
