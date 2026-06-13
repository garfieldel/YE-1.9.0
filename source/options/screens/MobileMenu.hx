package options.screens;

import flixel.math.FlxMath;
import flixel.FlxG;
import EngineSettings.Settings;

class MobileMenu extends OptionScreen {
    public override function create() {
        options = [
            {
                name: "Hitbox Opacity",
                desc: "Adjust the opacity of the hitboxes. Range: 0.0 - 1.0",
                value: "",
                onCreate: function(e) {e.value = Std.string(Settings.engineSettings.data.hitboxOpacity);},
                onUpdate: function(e) {
                    var oldValue = Settings.engineSettings.data.hitboxOpacity;

                    if (controls.LEFT_P #if mobile || _dpad.buttonLeft.justPressed #end) Settings.engineSettings.data.hitboxOpacity -= 0.1;
                    if (controls.RIGHT_P #if mobile || _dpad.buttonRight.justPressed #end) Settings.engineSettings.data.hitboxOpacity += 0.1;
                    Settings.engineSettings.data.hitboxOpacity = FlxMath.bound(FlxMath.roundDecimal(Settings.engineSettings.data.hitboxOpacity, 1), 0, 1);
                    if (oldValue != Settings.engineSettings.data.hitboxOpacity)
                        e.value = '< ${Settings.engineSettings.data.hitboxOpacity} >';
                }
            },
            {
                name: "Hitbox Hidden",
                desc: "If on, the hitboxes will disappear; if off, nothing will change",
                value: "",
                onCreate: function(e) {e.check(Settings.engineSettings.data.hitboxHidden);},
                onSelect: function(e) {e.check(Settings.engineSettings.data.hitboxHidden = !Settings.engineSettings.data.hitboxHidden);},
            }
        ];
        super.create();
    }
}
