import EngineSettings.Settings;
import flixel.system.FlxAssets.FlxShader;

class ColoredNoteShader extends FlxShader {
    @:glFragmentSource('#pragma header

precision mediump float;

uniform float r;
uniform float g;
uniform float b;
uniform bool enabled;

uniform bool blurEnabled;
uniform float x;
uniform float y;
uniform int passes;

const int MAX_PASSES = 16;

void main() {

    vec4 finalColor = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if (blurEnabled) {

        float rr = 0.0;
        float gg = 0.0;
        float bb = 0.0;
        float aa = 0.0;
        float t = 0.0;

        float realX = x / openfl_TextureSize.x;
        float realY = y / openfl_TextureSize.y;

        for (int i = -MAX_PASSES; i < MAX_PASSES; ++i) {

            if (abs(i) >= passes)
                continue;

            vec2 offset = vec2(
                openfl_TextureCoordv.x + (float(i) * realX / float(passes)),
                openfl_TextureCoordv.y + (float(i) * realY / float(passes))
            );

            vec4 color = flixel_texture2D(bitmap, offset);

            rr += color.r;
            gg += color.g;
            bb += color.b;
            aa += color.a;

            t += 1.0;
        }

        finalColor = vec4(rr / t, gg / t, bb / t, aa / t);
    }

    if (enabled) {

        float diff = finalColor.r - ((finalColor.g + finalColor.b) / 2.0);

        gl_FragColor = vec4(
            ((finalColor.g + finalColor.b) / 2.0) + (r * diff),
            finalColor.g + (g * diff),
            finalColor.b + (b * diff),
            finalColor.a
        );

    } else {

        gl_FragColor = finalColor;
    }
}
')
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