import Toybox.AntPlus;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;

class ColorMode {
    
    public enum {
        COLOR_VD_BLUE=0x313152,
        COLOR_LT_ORANGE=0xFFA376,   // ORANGE FF5500
        COLOR_LT_YELLOW=0xFFD186,    // YELLOW FFAA00
    }
    
    public var isNight=false as Boolean;

    private const MODE_BLACKANDWHITE={:day=>{
                :background=>Graphics.COLOR_WHITE,
                :label=>COLOR_VD_BLUE,
                :value=>COLOR_VD_BLUE,
                :valueEdge=>Graphics.COLOR_DK_RED,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_DK_RED,
            },:night=>{
                :background=>Graphics.COLOR_BLACK,
                :label=>Graphics.COLOR_WHITE,
                :value=>Graphics.COLOR_WHITE,
                :valueEdge=>Graphics.COLOR_ORANGE,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_RED,
            }
        } as Dictionary<Dictionary<Symbol,Graphics.ColorValue>>;
    private const MODE_BLUE={:day=>{
                :background=>Graphics.COLOR_DK_BLUE,
                :label=>Graphics.COLOR_WHITE,
                :value=>Graphics.COLOR_WHITE,
                :valueEdge=>Graphics.COLOR_ORANGE,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_LT_GRAY,
            },:night=>{
                :background=>Graphics.COLOR_BLUE,
                :label=>COLOR_VD_BLUE,
                :value=>Graphics.COLOR_BLACK,
                :valueEdge=>Graphics.COLOR_ORANGE,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_LT_GRAY,
            }
        } as Dictionary<Dictionary<Symbol,Graphics.ColorValue>>;
    private const MODE_GREEN={:day=>{
                :background=>Graphics.COLOR_DK_GREEN,
                :label=>Graphics.COLOR_WHITE,
                :value=>Graphics.COLOR_WHITE,
                :valueEdge=>Graphics.COLOR_PINK,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_DK_GRAY,
            }
        } as Dictionary<Dictionary<Symbol,Graphics.ColorValue>>;
    private const MODE_PINK={:day=>{
                :background=>Graphics.COLOR_PURPLE,
                :label=>Graphics.COLOR_WHITE,
                :value=>Graphics.COLOR_WHITE,
                :valueEdge=>Graphics.COLOR_PINK,
                :valueChange=>Graphics.COLOR_LT_GRAY,
                :error=>Graphics.COLOR_DK_GRAY,
            },:night=>{
                :background=>Graphics.COLOR_PINK,
                :label=>Graphics.COLOR_BLACK,
                :value=>Graphics.COLOR_BLACK,
                :valueEdge=>Graphics.COLOR_PURPLE,
                :valueChange=>Graphics.COLOR_DK_GRAY,
                :error=>Graphics.COLOR_LT_GRAY,
            }
        } as Dictionary<Dictionary<Symbol,Graphics.ColorValue>>;
    private var colors=MODE_BLACKANDWHITE as Dictionary<Symbol,Graphics.ColorValue>;
    function initialize() {
        System.println("ColorMode.initialize()");
    }
    
    public function handleSettingUpdate() as Void {
        System.println("ColorMode.onSettingsChanged()="+Properties.getValue("property_colorMode").toString());
        switch (Properties.getValue("property_colorMode") as Number) {
            case 0:
                colors=MODE_BLACKANDWHITE as Dictionary<Symbol,Graphics.ColorValue>;
                break;
            case 1:
                colors=MODE_BLUE as Dictionary<Symbol,Graphics.ColorValue>;
                break;
            case 2:
                colors=MODE_GREEN as Dictionary<Symbol,Graphics.ColorValue>;
                break;
            case 3:
                colors=MODE_PINK as Dictionary<Symbol,Graphics.ColorValue>;
                break;
            default:
                colors=MODE_BLACKANDWHITE as Dictionary<Symbol,Graphics.ColorValue>;
                break;
        }
        if(!colors.hasKey(:night)){
            colors.put(:night,colors.get(:day));
        }
    }
    public function compute() as Void {
        isNight=System.getDeviceSettings().isNightModeEnabled;
    }
    public function getFieldColor(field as Symbol) as Graphics.ColorValue {
        return colors.get(isNight?:night::day).get(field) as Graphics.ColorValue;
    }
    public function getNightFieldColor(field as Symbol) as Graphics.ColorValue {
        return colors.get(:night).get(field) as Graphics.ColorValue;
    }
    public function getColors() as Dictionary<Symbol,Graphics.ColorValue> {
        return colors.get(isNight?:night::day) as Dictionary<Symbol,Graphics.ColorValue>;
    }

}