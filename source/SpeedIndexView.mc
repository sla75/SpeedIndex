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

    private var colorMode=new ColorMode({
        :day=>{
                :background=>Graphics.COLOR_WHITE,
                :label=>ColorMode.COLOR_VD_BLUE,
                :value=>ColorMode.COLOR_VD_BLUE,
                :valueInActive=>Graphics.COLOR_LT_GRAY,
                :valuePaused=>Graphics.COLOR_ORANGE,
                :valueEdge=>Graphics.COLOR_DK_RED,
                :topLeft=>Graphics.COLOR_DK_RED,
                :bottomLeft=>Graphics.COLOR_DK_BLUE,
                :shadowUp=>Graphics.COLOR_LT_GRAY,
                :shadowDown=>Graphics.COLOR_DK_GRAY,
                :rearEdge=>Graphics.COLOR_RED,
            },
        :night=>{
                :background=>Graphics.COLOR_BLACK,
                :label=>Graphics.COLOR_LT_GRAY,
                :value=>Graphics.COLOR_WHITE,
                :valueInActive=>Graphics.COLOR_DK_GRAY,
                :topLeft=>Graphics.COLOR_RED,
                :bottomLeft=>Graphics.COLOR_BLUE,
                :shadowUp=>Graphics.COLOR_DK_GRAY,
                :shadowDown=>Graphics.COLOR_LT_GRAY,
            }
        } as Dictionary<Symbol,Dictionary<Symbol,Graphics.ColorValue>>
    ) as ColorMode;
    private var speedSensor=new AntPlus.BikeSpeed(new AntPlus.BikeSpeedListener()) as AntPlus.BikeSpeed;
    private var ds=new DataStorageGraph(System.getDeviceSettings().screenWidth) as DataStorageGraph;
    private var avgTriangle=new MyText({:justification => Graphics.TEXT_JUSTIFY_CENTER});
    private var gearNum=new Gear({:font=>Graphics.FONT_TINY});
    private const COLORS_DEVICE_STATE=[Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLUE,Graphics.COLOR_DK_BLUE,Graphics.COLOR_DK_RED] as Array<Graphics.ColorValue>;
    private const COLORS_POS_QUALITY=[Graphics.COLOR_RED,Graphics.COLOR_DK_RED,Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_BLUE,Graphics.COLOR_DK_GREEN] as Array<Graphics.ColorValue>;
    //private const PIRAD=Math.PI/180f;
    
    private enum {
        PROPERTY_CHARTCOLORPARTITION="property_chartColorPartition",
        PROPERTY_SHOWREARINDEX="property_showRearIndex",
        PROPERTY_MINMAXSPEED="property_minMaxSpeed",
        SPEED_OVER_AVG="}",
        SPEED_UNDER_AVG="{",
        CHAR_SATELLITE="G",
        CHAR_SENSOR="B"
    }

    function initialize() {
        LogMonkey.Debug.logMessage("SpeedIndexView.initialize()","");
        SlavicsSimpleDataField.initialize();
        
        //Properties.setValue(PROPERTY_SHOWGRAPH,Properties.getValue(PROPERTY_CHARTCOLORPARTITION)==null?-1:Properties.getValue(PROPERTY_SHOWGRAPH) as Boolean);
        Properties.setValue(PROPERTY_SHOWREARINDEX,Properties.getValue(PROPERTY_SHOWREARINDEX)==null?false:Properties.getValue(PROPERTY_SHOWREARINDEX) as Boolean);
        Properties.setValue(PROPERTY_SHOWREARINDEX,Properties.getValue(PROPERTY_SHOWREARINDEX)==null?30:Properties.getValue(PROPERTY_SHOWREARINDEX) as Number);

        self.setTextLabel(Application.loadResource(Rez.Strings.label));

        labels.get(:topRight).setFont(WatchUi.loadResource(Rez.Fonts.Icons));
        avgTriangle.setFont(WatchUi.loadResource(Rez.Fonts.Icons));
        avgTriangle.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        avgTriangle.setShiftShadow(isHdDisplay?2:1);
        LogMonkey.Debug.logVariable("SpeedIndexView.initialize()","isHdDisplay",isHdDisplay);
        avgTriangle.setJustification(isHdDisplay?Graphics.TEXT_JUSTIFY_CENTER:Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        //labels.get(:bottomRight).setFont(WatchUi.loadResource(Rez.Fonts.Icons));

        labels.get(:topLeft).setVisible(true);
        labels.get(:topRight).setVisible(true);
        labels.get(:bottomLeft).setVisible(true);
        //labels.get(:bottomRight).setVisible(true);
        bottomLabel.setText("km/h");
        bottomLabel.setVisible(true);
        valueArea.setShiftShadow(isHdDisplay?3:2);
        valueIndex.setShiftShadow(isHdDisplay?2:1);

        labels.get(:topLeft).setShiftShadow(1);
        labels.get(:bottomLeft).setShiftShadow(1);
        //labels.get(:bottomRight).setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);

        
        valueIndex.setVisible(true);
        
        
        ds.setBox(0,labelLine,System.getDeviceSettings().screenWidth,System.getDeviceSettings().screenWidth-labelLine);
        onSettingsChanged();
        
        //addDrawable(valueMax);
        //addDrawable(valueAvg);
        addDrawable(ds);
        addDrawable(avgTriangle);
        addDrawable(gearNum);
        initLoad();
    }
    
    (:release)
    function initLoad() as Void {}

    (:debug)
    function initLoad() as Void {
        LogMonkey.Debug.logMessage("DataStorageGraph","initLoad()");
        ds.add(10,null);ds.add(10,null);ds.add(10,null);ds.add(10,null);ds.add(30,null);ds.add(30,null);ds.add(30,null);ds.add(30,null);
        ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);
        ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);ds.add(30,20);
        ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);ds.add(10,20);
        ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
        Properties.setValue(PROPERTY_CHARTCOLORPARTITION,2);
        Properties.setValue(PROPERTY_SHOWREARINDEX,true);
    }
    public function onSettingsChanged() as Void {
        LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","");
        ds.setChartColorPartition(Properties.getValue(PROPERTY_CHARTCOLORPARTITION) as Number);
        gearNum.setVisible(Properties.getValue(PROPERTY_SHOWREARINDEX) as Boolean);
        //colorMode.handleSettingUpdate();
        ds.setMinMaxSpeedGraph(Properties.getValue(PROPERTY_MINMAXSPEED) as Number);
        setColors();
    }
    
    function onLayout(dc as Dc) as Void {

        if(dc.getWidth()==System.getDeviceSettings().screenWidth&&dc.getHeight()>System.getDeviceSettings().screenHeight/4){
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" SMALL");
            labels.get(:topLeft).setFont(Graphics.FONT_MEDIUM);
            labels.get(:bottomLeft).setFont(Graphics.FONT_MEDIUM);
            
            labelArea.setFont(Graphics.FONT_SMALL);
            valueArea.setFont(Graphics.FONT_NUMBER_THAI_HOT);
            bottomLabel.setFont(Graphics.FONT_SMALL);
            gearNum.setFont(Graphics.FONT_MEDIUM);

            valueIndex.setFont(Graphics.FONT_MEDIUM);
        } else {
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" TINY");
            labels.get(:topLeft).setFont(Graphics.FONT_MEDIUM);
            labels.get(:bottomLeft).setFont(Graphics.FONT_MEDIUM);

            gearNum.setFont(Graphics.FONT_TINY);
            labelArea.setFont(Graphics.FONT_TINY);
            valueArea.setFont(Graphics.FONT_NUMBER_HOT);
            bottomLabel.setFont(Graphics.FONT_TINY);

            valueIndex.setFont(Graphics.FONT_SMALL);

        }
        
        SlavicsSimpleDataField.onLayout(dc);        

        

        
        

        labels.get(:bottomLeft).locX=self.rim;
        labels.get(:bottomLeft).locY=dc.getHeight()-self.rim-labels.get(:bottomLeft).getFontAscent();
        labels.get(:topRight).locY=2;

        avgTriangle.locX=(valueArea.locX-dc.getTextWidthInPixels("00",valueArea.getFont())/2)/2;
        avgTriangle.locY=valueArea.locY;

        gearNum.setLocX(dc.getWidth()-avgTriangle.locX);
        gearNum.setLocY(valueArea.locY+valueIndex.getFontHeight());
        gearNum.onLayout(dc);

        ds.setBox(0,labelLine,System.getDeviceSettings().screenWidth,System.getDeviceSettings().screenHeight-labelLine);

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
    private function setColors() as Void{
        LogMonkey.Debug.logMessage("SpeedIndexView","setColors() isNight="+colorMode.isNight);
        var shUp=colorMode.getFieldColor(:shadowUp);
        var shDown=colorMode.getFieldColor(:shadowDown);
        labels.get(:topLeft).setShadowColor(shUp,shDown);
        labels.get(:bottomLeft).setShadowColor(shUp,shDown);
        labels.get(:topRight).setShadowColor(shUp,shDown);
        bottomLabel.setShadowColor(shUp,shDown);
        valueArea.setShadowColor(shUp,shDown);
        valueIndex.setShadowColor(shUp,shDown);
        avgTriangle.setShadowColor(shUp,shDown);
        gearNum.setColor(colorMode.getFieldColor(:value));

        labelArea.setColor(colorMode.getFieldColor(:label));
        valueIndex.setColor(colorMode.getFieldColor(:value));
        bottomLabel.setColor(colorMode.getFieldColor(:label));
        bottomLabel.setShadowColor(shUp,shDown);

        labels.get(:topLeft).setColor(colorMode.getFieldColor(:topLeft));
        labels.get(:bottomLeft).setColor(colorMode.getFieldColor(:bottomLeft));
        gearNum.setTextColor(colorMode.getFieldColor(:background));
    }
    /***
    function onShow() {
        LogMonkey.Debug.logMessage("SpeedIndexView","onShow()");
        SlavicsSimpleDataField.onShow();
        //self.setTextLabel("label");
    }
    /***/
    //private static const _TST={Activity.TIMER_STATE_OFF=>"Off",Activity.TIMER_STATE_STOPPED=>"Stop",Activity.TIMER_STATE_PAUSED=>"Pause",Activity.TIMER_STATE_ON=>"On"} as Dictionary<Activity.TimerState,String>;
    //private static const TST={Activity.TIMER_STATE_OFF=>"0",Activity.TIMER_STATE_STOPPED=>"1",Activity.TIMER_STATE_PAUSED=>"2",Activity.TIMER_STATE_ON=>"3"} as Dictionary<Activity.TimerState,String>;
    //private static const TSC={Activity.TIMER_STATE_OFF=>Graphics.COLOR_DK_GRAY,Activity.TIMER_STATE_STOPPED=>Graphics.COLOR_BLACK,Activity.TIMER_STATE_PAUSED=>Graphics.COLOR_ORANGE,Activity.TIMER_STATE_ON=>Graphics.COLOR_DK_GREEN} as Dictionary<Activity.TimerState,ColorType>;
    //private var invalidBoardShiftCount=0 as Number;
    function compute(info as Activity.Info) as Void {
        //LogMonkey.Debug.logMessage("SpeedIndexView","compute(speed="+info.currentSpeed+")");
        SlavicsSimpleDataField.compute(info);
        colorMode.compute();
        if(colorMode.isChangeNight()){
            SlavicsSimpleDataField.setColors(colorMode.getColors());
            setColors();
        }
        
        
        labels.get(:topLeft).setText(info.maxSpeed==null?"--":(info.maxSpeed*3.6).format("%.1f"));
        LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.averageSpeed",info.averageSpeed);
        labels.get(:bottomLeft).setText(info.averageSpeed==null?"--":(info.averageSpeed*3.6).format("%.1f"));
        //setTextInfo(:topRight,info.timerState==null?"--":TST.get(info.timerState));
        //setTextColor(:topRight,info.timerState==null?Graphics.COLOR_LT_GRAY:TSC.get(info.timerState));
        var speed=0;
        if(speedSensor!=null&&speedSensor.getSpeedInfo()!=null){
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","speedSensor.getSpeedInfo()",speedSensor.getSpeedInfo());
            speed=speedSensor.getSpeedInfo().speed;
            // Wheel
            if(speedSensor.getDeviceState()!=null&&speedSensor.getDeviceState().state!=null){
                if(speedSensor.getDeviceState().state==AntPlus.DEVICE_STATE_SEARCHING&&System.getClockTime().sec%2==1){
                    setTextColor(:topRight,Graphics.COLOR_TRANSPARENT);
                } else {
                    setTextColor(:topRight,COLORS_DEVICE_STATE[speedSensor.getDeviceState().state]);
                }
            } else {
                setTextColor(:topRight,colorMode.getFieldColor(:label));
            }
            setTextInfo(:topRight,CHAR_SENSOR);
        } else {
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.currentSpeed",info.currentSpeed);
            speed=info.currentSpeed==null?-1:info.currentSpeed;
            // Satellite
            setTextColor(:topRight,COLORS_POS_QUALITY[info.currentLocationAccuracy==null?0:info.currentLocationAccuracy]);
            setTextInfo(:topRight,CHAR_SATELLITE);
        }

        //speed=Math.rand()%200/10;
        /*** DEBUG ***/
        //isHdDisplay?0:
        speed=20+Math.rand()%5;
        var averageSpeed=(System.getClockTime().sec/30+1)*15;
        if(speed-averageSpeed>0.28f){
                    // Speed over average
                    avgTriangle.setVisible(true);
                    avgTriangle.setColor(Graphics.COLOR_DK_RED);
                    avgTriangle.setText(SPEED_OVER_AVG);
                } else if(averageSpeed-speed>0.28f){
                    // Speed under average
                    avgTriangle.setVisible(true);
                    avgTriangle.setColor(Graphics.COLOR_DK_BLUE);
                    avgTriangle.setText(SPEED_UNDER_AVG);
                } else {
                    avgTriangle.setVisible(false);    
                }
        /***
        if(speed!=null){
            if(info.averageSpeed!=null){
                if(speed-info.averageSpeed>0.28f){
                    // Speed over average
                    avgTriangle.setVisible(true);
                    avgTriangle.setColor(Graphics.COLOR_DK_RED);
                    avgTriangle.setText(SPEED_OVER_AVG);
                } else if(info.averageSpeed-speed>0.28f){
                    // Speed under average
                    avgTriangle.setVisible(true);
                    avgTriangle.setColor(Graphics.COLOR_DK_BLUE);
                    avgTriangle.setText(SPEED_UNDER_AVG);
                } else {
                    avgTriangle.setVisible(false);    
                }
            } else {
                avgTriangle.setVisible(false);
            }
            speed*=3.6f;
        } else {
            speed=-1;
            avgTriangle.setVisible(false);
        }
        /***/
        // Add values to Graph
        ds.add(speed<0?null:speed,info.averageSpeed!=null?info.averageSpeed*3.6:null);
        
        if(info.timerState==Activity.TIMER_STATE_ON){
            valueArea.setColor(colorMode.getFieldColor(:value));
        } else if(info.timerState==Activity.TIMER_STATE_OFF||info.timerState==Activity.TIMER_STATE_STOPPED){
            valueArea.setColor(colorMode.getFieldColor(:valueInActive));
        } else if(info.timerState==Activity.TIMER_STATE_PAUSED){
            valueArea.setColor(colorMode.getFieldColor(:valuePaused));
        }
        valueArea.setVisible(true);
        if(speed>5f&&info.timerState!=Activity.TIMER_STATE_ON&&System.getClockTime().sec%2==1){
            // Blink if not Timer State On
            valueArea.setVisible(false);
        }
        if(speed>=0){
            setValue(speed.format("%d"));
            valueIndex.setText(((speed-speed.toNumber())*10).toNumber().toString());
        } else {
            setValue("--");
            valueIndex.setText("");
        }

        valueIndex.setVisible(valueArea.isVisible());

        bottomLabel.setVisible(valueArea.isVisible());
        //LogMonkey.Debug.logVariable("SpeedIndexView.compute()","ds",ds);
        //showRearIndex=true;
        if(gearNum.isVisible()){
            gearNum.setText(info.rearDerailleurIndex==null?"--":info.rearDerailleurIndex.toString());
            if(info.rearDerailleurMax!=null&&(info.rearDerailleurIndex==1||info.rearDerailleurIndex==info.rearDerailleurMax)){
                gearNum.setColor(colorMode.getFieldColor(:rearEdge));
            } else {
                gearNum.setColor(colorMode.getFieldColor(:value));
            }
            /*** DEBUG ***/
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info",info);
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.rearDerailleurIndex",info.rearDerailleurIndex);
            var currentGear=Math.rand()%12+1;
            currentGear=System.getClockTime().sec==17?null:currentGear;
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","currentGear",currentGear);
            gearNum.setText(currentGear==null?"--":currentGear.toString());
            if(currentGear==1||currentGear==12){
                gearNum.setColor(colorMode.getFieldColor(:rearEdge));
            } else {
                gearNum.setColor(colorMode.getFieldColor(:value));
            }
            /***/
        }
    }

    public function onUpdate(dc as Dc) as Void {
        SlavicsSimpleDataField.onUpdate(dc);
        onUpdateAfter(dc);
        
    }
    (:release)
    private function onUpdateAfter(dc as Dc) as Void {
    }
    (:debug)
    private function onUpdateAfter(dc as Dc) as Void {
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_TRANSPARENT);
        dc.drawLine(avgTriangle.locX,avgTriangle.locY-25,avgTriangle.locX,avgTriangle.locY+25);
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