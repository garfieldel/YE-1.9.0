package;

import dev_toolbox.ToolboxMessage;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxCamera;
#if mobile
import mobile.flixel.FlxVirtualPad;
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
	var _sub_button:FlxVirtualPad;
	var _sub_dpad:FlxVirtualPad;
	var _sub_cam:FlxCamera;

	public function subAddButton(?action:FlxActionMode) {
		_sub_button = new FlxVirtualPad(null, action);

		_sub_cam = new FlxCamera();
	    _sub_cam.bgColor.alpha = 0;
		FlxG.cameras.add(_sub_cam, false);

		_sub_button.cameras = [_sub_cam];
		add(_sub_button);
	}

	public function subAddDPad(?dpad:FlxDPadMode) {
		_sub_dpad = new FlxVirtualPad(dpad, null);

		_sub_cam = new FlxCamera();
	    _sub_cam.bgColor.alpha = 0;
		FlxG.cameras.add(_sub_cam, false);

		_sub_dpad.cameras = [_sub_cam];
		_sub_dpad.alpha = 0.7;
		add(_sub_dpad);
	}

	public function subRemoveButton() {
		remove(_sub_button);
	}

	public function subRemoveDPad() {
		remove(_sub_dpad);
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
