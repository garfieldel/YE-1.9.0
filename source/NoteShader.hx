import EngineSettings.Settings;
import flixel.system.FlxAssets.FlxShader;

class ColoredNoteShader extends FlxFixedShader {
    @:glFragmentSource()
    public function new(r:Int, g:Int, b:Int, motion_blur:Null<Bool> = null, passes:Int = 10) {
        super();
        setColors(r, g, b);
        if (motion_blur == null) motion_blur = (PlayState.current != null ? PlayState.current.engineSettings.noteMotionBlurEnabled : Settings.engineSettings.data.noteMotionBlurEnabled);
        this.enabled.value = [true];
        this.blurEnabled.value = [motion_blur];
        this.y.value = [0.0075];
        this.passes.value = [passes];
    }

    public function setColors(r:Int, g:Int, b:Int) {
        this.r.value = [r / 255];
        this.g.value = [g / 255];
        this.b.value = [b / 255];
    }
}
