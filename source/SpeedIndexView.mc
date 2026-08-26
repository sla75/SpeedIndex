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
    private var speedSensor=new AntPlus.BikeSpeed(new AntPlus.BikeSpeedListener()) as AntPlus.BikeSpeed;
    private var ds=new DataStorageGraph(System.getDeviceSettings().screenWidth) as DataStorageGraph;
    private var speedChar=new MyText({:justification => Graphics.TEXT_JUSTIFY_CENTER});
    private var gearNum=new MyText({:font=>Graphics.FONT_TINY,:justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});
    private const COLORS_DEVICE_STATE=[Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLUE,Graphics.COLOR_DK_BLUE,Graphics.COLOR_DK_RED] as Array<Graphics.ColorValue>;
    private const COLORS_POS_QUALITY=[Graphics.COLOR_RED,Graphics.COLOR_DK_RED,Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_BLUE,Graphics.COLOR_DK_GREEN] as Array<Graphics.ColorValue>;
    //private const PIRAD=Math.PI/180f;
    private var fps=[] as Array<Array<Graphics.Point2D>>;
    private const SIN60=0.866f;
    private var currentGear=null as Number or Null;
    private var show_RearIndex=false as Boolean;
    private enum {
        PROPERTY_SHOWGRAPH="property_showGraph",
        PROPERTY_SHOWREARINDEX="property_showRearIndex"
    }

    function initialize() {
        LogMonkey.Debug.logMessage("SpeedIndexView.initialize()","");
        SlavicsSimpleDataField.initialize();
        
        Properties.setValue(PROPERTY_SHOWGRAPH,Properties.getValue(PROPERTY_SHOWGRAPH)==null?true:Properties.getValue(PROPERTY_SHOWGRAPH) as Boolean);
        Properties.setValue(PROPERTY_SHOWREARINDEX,Properties.getValue(PROPERTY_SHOWREARINDEX)==null?false:Properties.getValue(PROPERTY_SHOWREARINDEX) as Boolean);

        self.setTextLabel(Application.loadResource(Rez.Strings.label));

        labels.get(:topRight).setFont(WatchUi.loadResource(Rez.Fonts.Icons));
        speedChar.setFont(WatchUi.loadResource(Rez.Fonts.Icons));
        speedChar.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        //labels.get(:bottomRight).setFont(WatchUi.loadResource(Rez.Fonts.Icons));

        labels.get(:topLeft).setVisible(true);
        labels.get(:topRight).setVisible(true);
        labels.get(:bottomLeft).setVisible(true);
        //labels.get(:bottomRight).setVisible(true);

        labels.get(:topLeft).setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        labels.get(:bottomLeft).setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        labels.get(:topRight).setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        //labels.get(:bottomRight).setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);

        bottomLabel.setText("km/h");
        bottomLabel.setVisible(true);
        bottomLabel.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);

        valueArea.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        valueArea.setShiftShadow(3);

        valueIndex.setVisible(true);
        valueIndex.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);
        valueIndex.setShiftShadow(2);

        onSettingsChanged();
        
        //addDrawable(valueMax);
        //addDrawable(valueAvg);
        addDrawable(speedChar);
        addDrawable(gearNum);
        initLoad();
    }
    
    (:release)
    function initLoad() as Void {}

    (:debug)
    function initLoad() as Void {
        LogMonkey.Debug.logMessage("DataStorageGraph","initLoad()");
        ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);ds.add(null,15);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
        ds.add(10f,null);ds.add(10f,null);ds.add(10f,null);ds.add(10f,15f);ds.add(10f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(12f,15f);ds.add(20f,15f);ds.add(21f,15f);ds.add(22f,15f);ds.add(23f,15f);ds.add(24f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(25f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(35f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(0f,15f);ds.add(5f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(30f,15f);ds.add(20f,15f);ds.add(null,15f);ds.add(null,15f);ds.add(null,15f);
    }
    public function onSettingsChanged() as Void {
        LogMonkey.Debug.logMessage("SpeedIndexView.onSettingsChanged()","");

        ds.setVisible(Properties.getValue(PROPERTY_SHOWGRAPH) as Boolean);
        show_RearIndex=Properties.getValue(PROPERTY_SHOWREARINDEX) as Boolean;
        //colorMode.handleSettingUpdate();
        ds.handleSettingUpdate();
    }
    
    function onLayout(dc as Dc) as Void {

        if(dc.getWidth()==System.getDeviceSettings().screenWidth){
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" SMALL");
            labels.get(:topLeft).setFont(Graphics.FONT_MEDIUM);
            labels.get(:bottomLeft).setFont(Graphics.FONT_MEDIUM);
            
            labelArea.setFont(Graphics.FONT_SMALL);
            valueArea.setFont(Graphics.FONT_NUMBER_THAI_HOT);
            bottomLabel.setFont(Graphics.FONT_SMALL);
            gearNum.setFont(Graphics.FONT_MEDIUM);

            valueIndex.setFont(Graphics.FONT_LARGE);
        } else {
            LogMonkey.Debug.logMessage("SpeedIndexView.onLayout()",dc.getWidth()+"x"+dc.getHeight()+" TINY");
            labels.get(:topLeft).setFont(Graphics.FONT_MEDIUM);
            labels.get(:bottomLeft).setFont(Graphics.FONT_MEDIUM);

            gearNum.setFont(Graphics.FONT_TINY);
            labelArea.setFont(Graphics.FONT_TINY);
            valueArea.setFont(Graphics.FONT_NUMBER_HOT);
            bottomLabel.setFont(Graphics.FONT_TINY);

            valueIndex.setFont(Graphics.FONT_MEDIUM);

        }

        SlavicsSimpleDataField.onLayout(dc);        

        bottomLabel.setColor(Graphics.COLOR_DK_GRAY);
        bottomLabel.setShadowColor(Graphics.COLOR_WHITE,Graphics.COLOR_LT_GRAY);

        gearNum.setColor(Graphics.COLOR_WHITE);
        labels.get(:topLeft).setShiftShadow(2);

        labels.get(:bottomLeft).locX=self.rim;
        labels.get(:bottomLeft).locY=dc.getHeight()-self.rim-labels.get(:bottomLeft).getFontAscent();
        labels.get(:topRight).locY=2;
        //valueArea.setColor(Graphics.COLOR_BLACK);

        speedChar.locX=(valueArea.locX-dc.getTextWidthInPixels("00",valueArea.getFont())/2)/2;
        speedChar.locY=valueArea.locY;
        gearNum.locX=dc.getWidth()-speedChar.locX;
        gearNum.locY=valueArea.locY;

        var l=dc.getTextWidthInPixels("12",gearNum.getFont());
        dc.setPenWidth(1);
        //dim[1]=gearNum.getFontAscent();
        var y=gearNum.locY-gearNum.getFontDescent()/2;
        dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);
        
        fps=[];
        var lSIN60=l*SIN60;
        var fp=[] as Array<Graphics.Point2D>;
        fp.add([gearNum.locX+l,y]);
        fp.add([gearNum.locX-l/2,y+lSIN60]);
        fp.add([gearNum.locX-l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([gearNum.locX+lSIN60,y+l/2]);
        fp.add([gearNum.locX-lSIN60,y+l/2]);
        fp.add([gearNum.locX,y-l]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([gearNum.locX+l/2,y+lSIN60]);
        fp.add([gearNum.locX-l,y]);
        fp.add([gearNum.locX+l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([gearNum.locX,y+l]);
        fp.add([gearNum.locX-lSIN60,y-l/2]);
        fp.add([gearNum.locX+lSIN60,y-l/2]);
        fp.add(fp[0]);
        fps.add(fp);
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
        SlavicsSimpleDataField.setColors(colorMode.getColors());
        labels.get(:topLeft).setColor(Graphics.COLOR_DK_RED);
        labels.get(:bottomLeft).setColor(Graphics.COLOR_DK_BLUE);
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
                setTextColor(:topRight,ColorMode.COLOR_VD_BLUE);
            }
            setTextInfo(:topRight,"B");
        } else {
            LogMonkey.Debug.logVariable("SpeedIndexView.compute()","info.currentSpeed",info.currentSpeed);
            speed=info.currentSpeed==null?-1:info.currentSpeed;
            // Satellite
            setTextColor(:topRight,COLORS_POS_QUALITY[info.currentLocationAccuracy==null?0:info.currentLocationAccuracy]);
            setTextInfo(:topRight,"G");
        }

        //speed=Math.rand()%200/10;
        if(speed!=null){
            if(info.averageSpeed!=null){
                if(speed-info.averageSpeed>0.28f){
                    speedChar.setVisible(true);
                    speedChar.setColor(Graphics.COLOR_DK_RED);
                    speedChar.setText("}");
                } else if(info.averageSpeed-speed>0.28f){
                    speedChar.setVisible(true);
                    speedChar.setColor(Graphics.COLOR_DK_BLUE);
                    speedChar.setText("{");
                } else {
                    speedChar.setVisible(false);    
                }
            } else {
                speedChar.setVisible(false);
            }
            speed*=3.6f;
        } else {
            speed=-1;
            speedChar.setVisible(false);
        }
        
        // Add values to Graph
        ds.add(speed<0?null:speed,info.averageSpeed!=null?info.averageSpeed*3.6:null);

        if(info.timerState==Activity.TIMER_STATE_ON){
        } else if(info.timerState==Activity.TIMER_STATE_OFF||info.timerState==Activity.TIMER_STATE_STOPPED){
            valueArea.setColor(Graphics.COLOR_DK_GRAY);
        } else if(info.timerState==Activity.TIMER_STATE_PAUSED){
            valueArea.setColor(Graphics.COLOR_ORANGE);
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
        if(show_RearIndex){
            currentGear=info.rearDerailleurIndex;
            //currentGear=(Math.rand()%12+1).toString();
            //currentGear=System.getClockTime().sec==17?null:currentGear;
            gearNum.setText(currentGear==null?"--":currentGear);
        }
    }

    (:typecheck(false))
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_TRANSPARENT,colors.get(:background));
        dc.clear();
        ds.draw(dc,labelLine);
        //if(show_RearIndex&&currentGear!=null){
        if(show_RearIndex){
            dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);    
            for(var i=0;i<fps.size();i++){
                dc.fillPolygon(fps[i]);
            }
        }
        
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