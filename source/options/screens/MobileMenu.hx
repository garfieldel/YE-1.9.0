package options.screens;

import flixel.FlxG;
import EngineSettings.Settings;

class MobileMenu extends OptionScreen {
    public override function create() {
        options = [
            {
                name: "FUCK HITBOX OPACITY",
                desc: "fck.",
                value: '${Settings.engineSettings.data.hitboxOpacity} FCK',
                onLeft: function(e) {e.value = '${Settings.engineSettings.data.hitboxOpacity} FCK';},
                onUpdate: function(e) {
                    if (controls.LEFT_P #if mobile || _dpad.buttonLeft.justPressed #end) Settings.engineSettings.data.hitboxOpacity -= 10;
                    if (controls.RIGHT_P #if mobile || _dpad.buttonRight.justPressed #end) Settings.engineSettings.data.hitboxOpacity += 10;
                    Settings.engineSettings.data.hitboxOpacity = Std.int(FlxMath.bound(Settings.engineSettings.data.hitboxOpacity, 20, 300));
                    
					FlxG.drawFramerate = Settings.engineSettings.data.hitboxOpacity;
					FlxG.updateFramerate = Settings.engineSettings.data.hitboxOpacity;
                    
                    e.value = '< ${Settings.engineSettings.data.hitboxOpacity} FCK >';
                }
            }
        ];
        super.create();
    }
}
