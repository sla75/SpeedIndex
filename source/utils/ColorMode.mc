import Toybox.AntPlus;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;

class ColorMode {
    
    public enum {
        COLOR_VD_BLUE=0x313152,
        COLOR_LT_ORANGE=0xFFA376,   // ORANGE FF5500
        COLOR_LT_YELLOW=0xFFD186,    // YELLOW FFAA00
        COLOR_LT_BLUE=0x89D8FF,    // BLUE 00AAFF
        COLOR_LT_RED=0xFF8989,    // RED FF0000
    }
    
    public var isNight=false as Boolean;
    private var isLastNight=!isNight as Boolean;

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
        } as Dictionary<Symbol,Dictionary<Symbol,Graphics.ColorValue>>;
    private var colors=MODE_BLACKANDWHITE as Dictionary<Symbol,Graphics.ColorValue>;
    function initialize(colors as Dictionary<Symbol,Dictionary<Symbol,Graphics.ColorValue>>) {
        setColors(colors);
    }
    
    public function setColors(colors as Dictionary<Symbol,Dictionary<Symbol,Graphics.ColorValue>>) as Void {
        self.colors=colors;
        if(!self.colors.hasKey(:night)){
            self.colors.put(:night,self.colors.get(:day));
        }
    }
    public function compute() as Void {
        if(isNight!=isLastNight){
            isLastNight=isNight;
        }
        isNight=System.getDeviceSettings().isNightModeEnabled;
    }
    public function getFieldColor(field as Symbol) as Graphics.ColorValue {
        if(isNight && colors.get(:night).get(field)!=null){
            return colors.get(:night).get(field) as Graphics.ColorValue;
        } else {
            return colors.get(:day).get(field) as Graphics.ColorValue;
        }
    }
    public function getNightFieldColor(field as Symbol) as Graphics.ColorValue {
        return colors.get(:night).get(field) as Graphics.ColorValue;
    }
    public function getColors() as Dictionary<Symbol,Graphics.ColorValue> {
        return colors.get(isNight?:night::day) as Dictionary<Symbol,Graphics.ColorValue>;
    }
    public function isChangeNight() as Boolean {
        return isNight!=isLastNight;
    }
}