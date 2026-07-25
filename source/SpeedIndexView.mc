import Toybox.Activity;
import Toybox.AntPlus;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Sensor;
import Toybox.System;
import Toybox.WatchUi;
import LogMonkey;

class SpeedIndexView extends SlavicsSimpleDataField {

    private var colorMode=new ColorMode() as ColorMode;
    private var debugMode=false as Boolean;
    private var speedSensor=new AntPlus.BikeSpeed(new AntPlus.BikeSpeedListener()) as AntPlus.BikeSpeed;

    function initialize() {
        LogMonkey.Debug.logMessage("SpeedIndexView.initialize()","");
        SlavicsSimpleDataField.initialize();
        //Sensor.setEnabledSensors( [Sensor.SENSOR_BIKESPEED] );
    	//Sensor.enableSensorEvents(method(:onSensor));
        self.setTextLabel(Application.loadResource(Rez.Strings.label));

        labels.get(:topLeft).setVisible(true);
        labels.get(:topRight).setVisible(true);
        labels.get(:bottomLeft).setVisible(true);
        labels.get(:bottomRight).setVisible(true);

        centerRight.setVisible(true);
        centerBottom.setText("km/h");
        centerBottom.setVisible(true);
        //onSettingsChanged();
    }
    /***
    private var sensorSpeed=null as Float or Null;
    function onSensor(sensorInfo as Sensor.Info) as Void {
        sensorSpeed=sensorInfo.speed;
    }
    /***/
    public function onSettingsChanged() as Void {
        LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","");
        if(Application.loadResource(Rez.Strings.AppName).equals("GearIndexDev")){
            debugMode=!debugMode;
            LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","Rez.Strings.AppName="+Application.loadResource(Rez.Strings.AppName)+" REVERSE debugMode="+debugMode);
        }
        colorMode.handleSettingUpdate();
    }

    function onLayout(dc as Dc) as Void {
        SlavicsSimpleDataField.onLayout(dc);
        if(dc.getWidth()==System.getDeviceSettings().screenWidth){
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" SMALL");
            labels.get(:topLeft).setFont(Graphics.FONT_SMALL);
            labels.get(:topRight).setFont(Graphics.FONT_TINY);
            labels.get(:bottomLeft).setFont(Graphics.FONT_SMALL);
            labels.get(:bottomRight).setFont(Graphics.FONT_TINY);
            centerBottom.setFont(Graphics.FONT_SMALL);
            centerRight.setFont(Graphics.FONT_MEDIUM);
        } else {
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" TINY");
            labels.get(:topLeft).setFont(Graphics.FONT_TINY);
            labels.get(:topRight).setFont(Graphics.FONT_XTINY);
            labels.get(:bottomLeft).setFont(Graphics.FONT_TINY);
            labels.get(:bottomRight).setFont(Graphics.FONT_XTINY);
            centerBottom.setFont(Graphics.FONT_TINY);
            centerRight.setFont(Graphics.FONT_XTINY);
        }
        /***
        System.println("PartNumber: "+System.getDeviceSettings().partNumber);
        System.println("Screen: "+dc.getWidth()+"x"+dc.getHeight());
        System.println("|Font|Height|Ascent|Descent|");
        System.println("|---:|---:|---:|---:|");
        System.println("|FONT_XTINY|"+Graphics.getFontHeight(Graphics.FONT_XTINY)+"|"+Graphics.getFontAscent(Graphics.FONT_XTINY)+"|"+Graphics.getFontDescent(Graphics.FONT_XTINY)+"|");
        System.println("|FONT_TINY|"+Graphics.getFontHeight(Graphics.FONT_TINY)+"|"+Graphics.getFontAscent(Graphics.FONT_TINY)+"|"+Graphics.getFontDescent(Graphics.FONT_TINY)+"|");
        System.println("|FONT_SMALL|"+Graphics.getFontHeight(Graphics.FONT_SMALL)+"|"+Graphics.getFontAscent(Graphics.FONT_SMALL)+"|"+Graphics.getFontDescent(Graphics.FONT_SMALL)+"|");
        System.println("|FONT_MEDIUM|"+Graphics.getFontHeight(Graphics.FONT_MEDIUM)+"|"+Graphics.getFontAscent(Graphics.FONT_MEDIUM)+"|"+Graphics.getFontDescent(Graphics.FONT_MEDIUM)+"|");
        System.println("|FONT_LARGE|"+Graphics.getFontHeight(Graphics.FONT_LARGE)+"|"+Graphics.getFontAscent(Graphics.FONT_LARGE)+"|"+Graphics.getFontDescent(Graphics.FONT_LARGE)+"|");
        /***/
    }
    /***/
    function onShow() {
        LogMonkey.Debug.logMessage("SpeedIndexView","onShow()");
        SlavicsSimpleDataField.onShow();
        //self.setTextLabel("label");
    }
    /***/
    private static const TST={Activity.TIMER_STATE_OFF=>"Off",Activity.TIMER_STATE_STOPPED=>"Stop",Activity.TIMER_STATE_PAUSED=>"Pause",Activity.TIMER_STATE_ON=>"On"} as Dictionary<Activity.TimerState,String>;
    private static const TSC={Activity.TIMER_STATE_OFF=>Graphics.COLOR_DK_GRAY,Activity.TIMER_STATE_STOPPED=>Graphics.COLOR_BLACK,Activity.TIMER_STATE_PAUSED=>Graphics.COLOR_ORANGE,Activity.TIMER_STATE_ON=>Graphics.COLOR_DK_GREEN} as Dictionary<Activity.TimerState,ColorType>;
    //private var invalidBoardShiftCount=0 as Number;
    function compute(info as Activity.Info) as Void {
        //LogMonkey.Debug.logMessage("SpeedIndexView","compute(speed="+info.currentSpeed+")");
        SlavicsSimpleDataField.compute(info);
        colorMode.compute();
        SlavicsSimpleDataField.setColors(colorMode.getColors());
        info(:topLeft).setColor(Graphics.COLOR_DK_RED);
        info(:bottomLeft).setColor(Graphics.COLOR_DK_BLUE);
        setTextInfo(:topLeft,info.maxSpeed==null?"56.7":info.maxSpeed.format("%.1f"));
        LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.averageSpeed",info.averageSpeed);
        setTextInfo(:bottomLeft,info.averageSpeed==null?"25.6":info.averageSpeed.format("%.1f"));
        setTextInfo(:bottomRight,info.timerState==null?"-":TST.get(info.timerState));
        setTextColor(:bottomRight,info.timerState==null?Graphics.COLOR_LT_GRAY:TSC.get(info.timerState));
        var speed=0;
        if(speedSensor!=null&&speedSensor.getSpeedInfo()!=null){
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","speedSensor.getSpeedInfo()",speedSensor.getSpeedInfo());
            speed=speedSensor.getSpeedInfo().speed;
            info(:topRight).setColor(Graphics.COLOR_DK_GREEN);
            setTextInfo(:topRight,"RS");
            valueArea.setColor(Graphics.COLOR_DK_BLUE);
        } else {
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.currentSpeed",info.currentSpeed);
            speed=info.currentSpeed==null?0:info.currentSpeed;
            info(:topRight).setColor(Graphics.COLOR_BLACK);
            setTextInfo(:topRight,"GPS");
            valueArea.setColor(Graphics.COLOR_BLACK);            
        }
        if(speed!=null){
            speed*=3.6f;
        } else {
            speed=-1
        }
        //speed=56.789f;
        if(info.timerState==Activity.TIMER_STATE_ON){
        } else if(info.timerState==Activity.TIMER_STATE_OFF||info.timerState==Activity.TIMER_STATE_STOPPED){
            valueArea.setColor(Graphics.COLOR_LT_GRAY);
        } else if(info.timerState==Activity.TIMER_STATE_PAUSED){
            valueArea.setColor(Graphics.COLOR_ORANGE);
        }
        valueArea.setVisible(true);
        if(speed>5f&&info.timerState!=Activity.TIMER_STATE_ON&&System.getClockTime().sec%2==1){
            valueArea.setVisible(false);
        }

        setValue(speed.format("%d"));
        centerRight.setText(((speed-speed.toNumber())*10).toNumber().toString());
        
        centerRight.setColor(valueArea.getColor());
        centerRight.setVisible(valueArea.getVisible());

        centerBottom.setVisible(valueArea.getVisible());
        
    }
    public function onUpdate(dc as Dc) as Void {
        SlavicsSimpleDataField.onUpdate(dc);
    }

}
/***
XTINY edge840  11  8 3
XTINY edge1050 21 15 6

TINY  edge840  14 10 4
TINY  edge1050 28 20 8

edge840
#   HH  AA DD Name
0.  11   8  3 FONT_XTINY
1.  14  10  4 FONT_TINY
2.  17  12  5 FONT_SMALL
3.  19  14  5 FONT_MEDIUM
4.  31  22  9 FONT_LARGE
5.  35  28  7 FONT_NUMBER_MILD
6.  42  33  9 FONT_NUMBER_MEDIUM
7.  55  43 12 FONT_NUMBER_HOT
8.  67  53 14 FONT_NUMBER_THAI_HOT

edge1050
#   HH  AA DD Name
0.  21  15  6 FONT_XTINY
1.  28  20  8 FONT_TINY
2.  33  24  9 FONT_SMALL
3.  38  27 11 FONT_MEDIUM
4.  61  44 17 FONT_LARGE
5.  71  56 15 FONT_NUMBER_MILD
6.  82  65 17 FONT_NUMBER_MEDIUM
7. 109  86 23 FONT_NUMBER_HOT
8. 136 108 28 FONT_NUMBER_THAI_HOT

1/5 FONT_MEDIUM,FONT_NUMBER_HOT



/***/