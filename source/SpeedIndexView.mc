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
    private var ds=new DataStorageGraph(System.getDeviceSettings().screenWidth) as DataStorageGraph;
    private var textMax as Text;
    private var textAvg as Text;

    private enum {
        PROPERTY_SHOWGRAPH="property_showGraph",
    }

    function initialize() {
        LogMonkey.Debug.logMessage("SpeedIndexView.initialize()","");
        SlavicsSimpleDataField.initialize();
        Properties.setValue(PROPERTY_SHOWGRAPH,Properties.getValue(PROPERTY_SHOWGRAPH)==null?true:Properties.getValue(PROPERTY_SHOWGRAPH) as Boolean);
        self.setTextLabel(Application.loadResource(Rez.Strings.label));

        labels.get(:topLeft).setVisible(true);
        labels.get(:topRight).setVisible(true);
        labels.get(:bottomLeft).setVisible(true);
        labels.get(:bottomRight).setVisible(true);

        centerRight.setVisible(true);
        centerBottom.setText("km/h");
        centerBottom.setVisible(true);
        valueArea.setShadowColor(Graphics.COLOR_LT_GRAY);
        //onSettingsChanged();
        textMax=new Text(labels.get(:topLeft).getOptions());
        textMax.setText("Max");
        textAvg=new Text(labels.get(:bottomLeft).getOptions());
        textAvg.setText("Avg");
        addDrawable(textMax);
        addDrawable(textAvg);
    }
    /***
    private var sensorSpeed=null as Float or Null;
    function onSensor(sensorInfo as Sensor.Info) as Void {
        sensorSpeed=sensorInfo.speed;
    }
    /***/
    public function onSettingsChanged() as Void {
        LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","");
        if(Application.loadResource(Rez.Strings.AppName).equals("SpeedIndexDev")){
            debugMode=!debugMode;
            LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","Rez.Strings.AppName="+Application.loadResource(Rez.Strings.AppName)+" REVERSE debugMode="+debugMode);
        }
        ds.setVisible(Properties.getValue(PROPERTY_SHOWGRAPH) as Boolean);
        colorMode.handleSettingUpdate();
        ds.handleSettingUpdate();
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
            textMax.setFont(Graphics.FONT_TINY);
            textAvg.setFont(Graphics.FONT_TINY);
        } else {
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" TINY");
            labels.get(:topLeft).setFont(Graphics.FONT_SMALL);
            labels.get(:topRight).setFont(Graphics.FONT_XTINY);
            labels.get(:bottomLeft).setFont(Graphics.FONT_SMALL);
            labels.get(:bottomRight).setFont(Graphics.FONT_XTINY);
            centerBottom.setFont(Graphics.FONT_TINY);
            centerRight.setFont(Graphics.FONT_MEDIUM);
            textMax.setFont(Graphics.FONT_XTINY);
            textAvg.setFont(Graphics.FONT_XTINY);
        }
        textMax.setColor(labels.get(:topLeft).getColor());
        textMax.locX=labels.get(:topLeft).locX;
        textMax.locY=labels.get(:topLeft).locY-Graphics.getFontHeight(Graphics.FONT_TINY);
        textAvg.setColor(labels.get(:bottomLeft).getColor());
        textAvg.locX=labels.get(:bottomLeft).locX;
        textAvg.locY=labels.get(:bottomLeft).locY-Graphics.getFontHeight(Graphics.FONT_TINY);

        //labels.get(:bottomRight).locY=textMax.locY;
        //labels.get(:topRight).locY=valueArea.locY;
        //labels.get(:topRight).setJustification(Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);

        labels.get(:topRight).setFont(WatchUi.loadResource(Rez.Fonts.Icons));
        labels.get(:topLeft).setShadowColor(Graphics.COLOR_LT_GRAY);
        labels.get(:bottomLeft).setShadowColor(Graphics.COLOR_LT_GRAY);
        labels.get(:topRight).setShadowColor(Graphics.COLOR_LT_GRAY);
        labels.get(:bottomRight).setShadowColor(Graphics.COLOR_LT_GRAY);
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
    //private static const _TST={Activity.TIMER_STATE_OFF=>"Off",Activity.TIMER_STATE_STOPPED=>"Stop",Activity.TIMER_STATE_PAUSED=>"Pause",Activity.TIMER_STATE_ON=>"On"} as Dictionary<Activity.TimerState,String>;
    private static const TST={Activity.TIMER_STATE_OFF=>"0",Activity.TIMER_STATE_STOPPED=>"1",Activity.TIMER_STATE_PAUSED=>"2",Activity.TIMER_STATE_ON=>"3"} as Dictionary<Activity.TimerState,String>;
    private static const TSC={Activity.TIMER_STATE_OFF=>Graphics.COLOR_DK_GRAY,Activity.TIMER_STATE_STOPPED=>Graphics.COLOR_BLACK,Activity.TIMER_STATE_PAUSED=>Graphics.COLOR_ORANGE,Activity.TIMER_STATE_ON=>Graphics.COLOR_DK_GREEN} as Dictionary<Activity.TimerState,ColorType>;
    //private var invalidBoardShiftCount=0 as Number;
    function compute(info as Activity.Info) as Void {
        //LogMonkey.Debug.logMessage("SpeedIndexView","compute(speed="+info.currentSpeed+")");
        SlavicsSimpleDataField.compute(info);
        colorMode.compute();
        SlavicsSimpleDataField.setColors(colorMode.getColors());
        info(:topLeft).setColor(Graphics.COLOR_DK_RED);
        info(:bottomLeft).setColor(Graphics.COLOR_DK_BLUE);
        setTextInfo(:topLeft,info.maxSpeed==null?"--":(info.maxSpeed*3.6).format("%.1f"));
        LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.averageSpeed",info.averageSpeed);
        setTextInfo(:bottomLeft,info.averageSpeed==null?"--":(info.averageSpeed*3.6).format("%.1f"));
        setTextInfo(:topRight,info.timerState==null?"--":TST.get(info.timerState));
        setTextColor(:topRight,info.timerState==null?Graphics.COLOR_LT_GRAY:TSC.get(info.timerState));
        var speed=0;
        if(speedSensor!=null&&speedSensor.getSpeedInfo()!=null){
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","speedSensor.getSpeedInfo()",speedSensor.getSpeedInfo());
            speed=speedSensor.getSpeedInfo().speed;
            setTextColor(:bottomRight,Graphics.COLOR_DK_BLUE);
            setTextInfo(:bottomRight,"BS");
            valueArea.setColor(Graphics.COLOR_DK_BLUE);
        } else {
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.currentSpeed",info.currentSpeed);
            speed=info.currentSpeed==null?-1:info.currentSpeed;
            setTextColor(:bottomRight,Graphics.COLOR_BLACK);
            setTextInfo(:bottomRight,"GPS");
            valueArea.setColor(Graphics.COLOR_BLACK);            
        }
        //speed=Math.rand()%200/10;
        if(speed!=null){
            speed*=3.6f;
        } else {
            speed=-1;
        }
        //ds.add(15+Math.rand()%10);
        ds.add(speed<0?null:speed);
        ds.setAvg(info.averageSpeed!=null?info.averageSpeed*3.6:null);
        //ds.setAvg(15f);

        if(info.timerState==Activity.TIMER_STATE_ON){
        } else if(info.timerState==Activity.TIMER_STATE_OFF||info.timerState==Activity.TIMER_STATE_STOPPED){
            valueArea.setColor(Graphics.COLOR_DK_GRAY);
        } else if(info.timerState==Activity.TIMER_STATE_PAUSED){
            valueArea.setColor(Graphics.COLOR_ORANGE);
        }
        valueArea.setVisible(true);
        if(speed>5f&&info.timerState!=Activity.TIMER_STATE_ON&&System.getClockTime().sec%2==1){
            valueArea.setVisible(false);
        }
        if(speed>=0){
            setValue(speed.format("%d"));
            centerRight.setText(((speed-speed.toNumber())*10).toNumber().toString());
        } else {
            setValue("--");
            centerRight.setText("");
        }
        
        centerRight.setColor(valueArea.getColor());
        centerRight.setVisible(valueArea.isVisible());

        centerBottom.setVisible(valueArea.isVisible());
        LogMonkey.Debug.logVariable("SpeedIndexView.compute()","ds",ds);
    }
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT,colors.get(:background));
        dc.clear();
        ds.draw(dc,labelLine);
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