import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;
import LogMonkey;

class SlavicsSimpleDataField extends WatchUi.DataField {

    public const FONTS=[
            Graphics.FONT_NUMBER_THAI_HOT,
            Graphics.FONT_NUMBER_HOT,
            Graphics.FONT_NUMBER_MEDIUM,
            Graphics.FONT_NUMBER_MILD,
            Graphics.FONT_LARGE,
            Graphics.FONT_MEDIUM,
            Graphics.FONT_SMALL,
            Graphics.FONT_TINY,
            Graphics.FONT_XTINY,
        ] as Array<Graphics.FontType>;
    /***
    protected var labelArea = new WatchUi.TextArea({
            :text=>"",
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>FONTS.slice(4,null),
            :justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER,
        });
        /***/
    protected var labelArea = new MyText({
            :text=>"",
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER,
        });
    protected var valueArea=new MyText({
            :text=>"",
            :color=>Graphics.COLOR_DK_BLUE,
            //:font=>FONTS,
            :font=>Graphics.FONT_NUMBER_THAI_HOT,
            :justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER,
        });
    protected var labels={
        :topLeft=>new MyText({
            :color=>Graphics.COLOR_DK_RED,
            :font=>Graphics.FONT_MEDIUM,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
            :visible=>false
        }),
        :topRight=>new MyText({
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_MEDIUM,
            :justification=>Graphics.TEXT_JUSTIFY_RIGHT,
            :visible=>false
        }),
        :bottomLeft=>new MyText({
            :color=>Graphics.COLOR_DK_BLUE,
            :font=>Graphics.FONT_MEDIUM,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
            :visible=>false
        }),
        :bottomRight=>new MyText({
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_MEDIUM,
            :justification=>Graphics.TEXT_JUSTIFY_RIGHT,
            :visible=>false
        }),
    } as Dictionary<Symbol,MyText>;
    protected var centerBottom=new MyText({
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_TINY,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER,
            :visible=>false
        });
    protected var centerRight=new MyText({
            :color=>Graphics.COLOR_DK_GRAY,
            :font=>Graphics.FONT_MEDIUM,
            :justification=>Graphics.TEXT_JUSTIFY_LEFT,
            :visible=>false
        });
    private var timer=null as SlavicsSimpleDataField.Timer;
    var value="" as String;

    public var rim=0 as Number;
    public var labelLine=0 as Number;
    public var colors={:background=>Graphics.COLOR_WHITE,:label=>Graphics.COLOR_DK_GRAY,:value=>Graphics.COLOR_BLACK,:valueshadow=>Graphics.COLOR_LT_GRAY} as Dictionary<Symbol,Graphics.ColorValue>;
    //protected var textLabel="Label" as String;
    //protected var textValue="Value" as String;
    private var drawables=[] as Array<Drawable>;
    function initialize() {
        //LogMonkey.Debug.logMessage("SlavicsSimpleDataField.initialize()","");
        DataField.initialize();
    }
    function addDrawable(draw as Drawable) as Void{
        self.drawables.add(draw);
    }
    function onLayout(dc as Dc) as Void {
        //LogMonkey.Debug.logMessage("SlavicsSimpleDataField.onLayout()",dc.getWidth()+"x"+dc.getHeight());
        rim=dc.getHeight()*0.02f;
        labelLine=Graphics.getFontHeight(labelArea.getFont())*1.1;
        labelArea.locX=dc.getWidth()/2;
        labelArea.locY=labelLine-Graphics.getFontHeight(labelArea.getFont());
        //labelArea.width=dc.getWidth()-2*rim;
        //labelArea.height=labelLine*1.333f;
        //labelArea.setJustification(Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        labelArea.setJustification(Graphics.TEXT_JUSTIFY_CENTER);

        /***
        //valueArea.locX=0;
        //valueArea.locY=labelLine;
        valueArea.width=dc.getWidth();
        valueArea.height=dc.getHeight()-labelLine*0.667f;

        valueArea.locX=valueArea.width/2;
        valueArea.locY=labelLine+valueArea.height/2;
        /***/
        valueArea.locX=dc.getWidth()/2;
        valueArea.locY=dc.getHeight()/2;
        valueArea.setJustification(Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

        labels.get(:topLeft).locX=self.rim;
        labels.get(:topLeft).locY=self.labelLine;
        labels.get(:topLeft).setJustification(Graphics.TEXT_JUSTIFY_LEFT);

        labels.get(:topRight).locX=dc.getWidth()-self.rim;
        labels.get(:topRight).locY=self.labelLine;
        labels.get(:topRight).setJustification(Graphics.TEXT_JUSTIFY_RIGHT);

        labels.get(:bottomLeft).locX=self.rim;
        labels.get(:bottomLeft).locY=dc.getHeight()-self.rim-Graphics.getFontAscent(Graphics.FONT_SMALL);
        labels.get(:bottomLeft).setJustification(Graphics.TEXT_JUSTIFY_LEFT);

        labels.get(:bottomRight).locX=dc.getWidth()-self.rim;
        labels.get(:bottomRight).locY=dc.getHeight()-self.rim-Graphics.getFontAscent(Graphics.FONT_SMALL);
        labels.get(:bottomRight).setJustification(Graphics.TEXT_JUSTIFY_RIGHT);
    }
    public function setTimer(duration as Number or Null) as Void {
        LogMonkey.Debug.logVariable("SlavicsSimpleDataField.setTimer()","duration",duration);
        if(duration==null||duration==0){
            self.timer=null;
        } else {
            self.timer=new SlavicsSimpleDataField.Timer(duration);
        }
    }
    public function info(name as Symbol) as MyText {
        return labels.get(name);
    }
    public function setTextInfo(name as Symbol,text as String or Null){
        labels.get(name).setText(text!=null?text:"");
        if(timer!=null){
            timer.start();
        }
    }
    public function setTextColor(name as Symbol,color as ColorType){
        labels.get(name).setColor(color);
    }
    public function setTextLabel(text as String or Null){
        labelArea.setText(text!=null?text:"");
    }

    public function setValue(text as String or Null){
        value=text!=null?text:"";
    }
    
    public function setColors(colors as Dictionary<Symbol,Graphics.ColorValue>){
        self.colors=colors;
        valueArea.setColor(colors.get(:value));
        labelArea.setColor(colors.get(:label));
        labels.get(:topLeft).setColor(colors.get(:label));
        labels.get(:topRight).setColor(colors.get(:label));
        labels.get(:bottomLeft).setColor(colors.get(:label));
        labels.get(:bottomRight).setColor(colors.get(:label));
    }
    /***
    public function compute(info as Activity.Info) as Void {
        valueArea.setColor(nightMode?Graphics.COLOR_WHITE:Graphics.COLOR_BLACK);
        labelArea.setColor(nightMode?Graphics.COLOR_LT_GRAY:Graphics.COLOR_DK_GRAY);
    }
    /***/

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    
    public function onUpdate(dc as Dc) as Void {
        LogMonkey.Debug.logMessage("SlavicsSimpleDataField.onUpdate()",timer);
        valueArea.setText(value);

        for( var i = 0; i < drawables.size(); i++ ) {
            ((drawables as Array)[i] as Drawable).draw(dc);
        }
        /***
        valueArea.setFont(FONTS[FONTS.size()-1]);
        var wht;
        for(var i=FONTS.size()-2;i>=0;i--){
            LogMonkey.Debug.logVariable("SlavicsSimpleDataField.computeValueFont("+value+")","i",i);
            wht=dc.getTextDimensions(value,FONTS[i]);
            if(wht[0]>valueArea.width||wht[1]>valueArea.height){
                break;
            }
            valueArea.setFont(FONTS[i]);
        }
        /***/
        //dc.setColor(Graphics.COLOR_TRANSPARENT,colors.get(:background));
        //dc.clear();

        //var baseLineY=valueArea.locY-Graphics.getFontHeight(Graphics.FONT_NUMBER_THAI_HOT)/2+Graphics.getFontAscent(Graphics.FONT_NUMBER_THAI_HOT);

        centerBottom.locX=valueArea.locX;
        centerBottom.locY=valueArea.locY+Graphics.getFontHeight(Graphics.FONT_NUMBER_THAI_HOT)/2-Graphics.getFontAscent(centerBottom.getFont())/2;
        if(centerBottom.locY+Graphics.getFontHeight(centerBottom.getFont())>dc.getHeight()){
            centerBottom.locY=dc.getHeight()-Graphics.getFontHeight(centerBottom.getFont());
        }
        centerBottom.draw(dc);

        centerRight.locX=valueArea.locX+dc.getTextWidthInPixels(value,Graphics.FONT_NUMBER_THAI_HOT)/2;
        centerRight.locY=valueArea.locY-Graphics.getFontHeight(centerRight.getFont());
        centerRight.draw(dc);
        valueArea.draw(dc);
        labelArea.draw(dc);
        if(timer==null||!timer.isExpired()){
            //LogMonkey.Debug.logMessage("SlavicsSimpleDataField.onUpdate()","draw topbottomleftright");
            labels.get(:topLeft).draw(dc);
            labels.get(:topRight).draw(dc);
            labels.get(:bottomLeft).draw(dc);
            labels.get(:bottomRight).draw(dc);
        }
        onUpdateAfter(dc);
    }
    (:release)
    private function onUpdateAfter(dc as Dc) as Void {
    }
    (:debug)
    private function onUpdateAfter(dc as Dc) as Void {

        dc.setColor(Graphics.COLOR_YELLOW,Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(labelArea.locX,labelArea.locY,labelArea.width,labelArea.height);
        dc.drawLine(labelArea.locX,labelArea.locY+labelArea.height/2,labelArea.locX+labelArea.width,labelArea.locY+labelArea.height/2);

        dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_TRANSPARENT);
        //dc.drawRectangle(valueArea.locX,valueArea.locY,valueArea.width,valueArea.height);
        //dc.drawLine(valueArea.locX,valueArea.locY+valueArea.height/2,valueArea.locX+valueArea.width,valueArea.locY+valueArea.height/2);
        var valueDim=dc.getTextDimensions(value,Graphics.FONT_NUMBER_THAI_HOT);
        dc.drawRectangle(valueArea.locX-valueDim[0]/2,valueArea.locY-valueDim[1]/2,valueDim[0],valueDim[1]);
        dc.drawLine(valueArea.locX,valueArea.locY-valueDim[1]/2+5,valueArea.locX,valueArea.locY+valueDim[1]/2-5);
        dc.drawLine(valueArea.locX-valueDim[0]/2-15,valueArea.locY,valueArea.locX+valueDim[0]/2+15,valueArea.locY);
        LogMonkey.Debug.logVariable("SlavicsSimpleDataField.onUpdateAfter()","font Dim height",valueDim[1]);
        LogMonkey.Debug.logVariable("SlavicsSimpleDataField.onUpdateAfter()","font height",Graphics.getFontHeight(Graphics.FONT_NUMBER_THAI_HOT));
        dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);
        //var fa=Graphics.getFontAscent(Graphics.FONT_NUMBER_THAI_HOT);
        var baseLineY=valueArea.locY-Graphics.getFontHeight(Graphics.FONT_NUMBER_THAI_HOT)/2+Graphics.getFontAscent(Graphics.FONT_NUMBER_THAI_HOT);
        dc.drawLine(valueArea.locX-valueDim[0]/2,baseLineY,valueArea.locX+valueDim[0]/2,baseLineY);
        
        
    }

    class Timer {
        private var timeValue=0 as Number;
        private var defaultDuration as Number;
        private var expired=true as Boolean;
        
        function initialize(durationSec as Number){
            defaultDuration=durationSec;
        }

        function start() as Void {
            timeValue=Time.now().value()+defaultDuration;
            //LogMonkey.Debug.logMessage("SlavicsSimpleDataField.Timer","START timeValue="+timeValue+"("+Time.now().value()+"+"+defaultDuration+")");
            expired=false;
        }

        function isExpired() as Boolean{
            //LogMonkey.Debug.logVariable("SlavicsSimpleDataField.isExpired()","Time.now().value()",Time.now().value());
            if(expired){
                return true;
            }
            //LogMonkey.Debug.logMessage("SlavicsSimpleDataField.isExpired()",expiration+" diff="+(Time.now().value()-timeValue));
            if(Time.now().value()>timeValue){
                expired=true;
                //LogMonkey.Debug.logVariable("SlavicsSimpleDataField.Timer","STOP expiration",expiration);
            }
            return expired;
        }

        function toString() as String{
            return "Timer("+defaultDuration+"s) expired="+expired;
        }
    }
}