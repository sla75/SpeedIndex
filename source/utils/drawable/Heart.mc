import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.UserProfile;
import Toybox.WatchUi;
import LogMonkey;

class Heart extends Drawable {

   
    private var options as Dictionary;
    private var visible=true as Boolean;
    private var mainText=new MyText({:font=>Graphics.FONT_TINY, :color=>Graphics.COLOR_LT_GRAY, :justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});
    //private var value=null as Numeric or Null;
    private const ZONE_INFO = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
    private const ZONES_COLOR = [Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLUE,Graphics.COLOR_GREEN,Graphics.COLOR_ORANGE,Graphics.COLOR_RED,Graphics.COLOR_DK_RED] as Array<Graphics.ColorType>;
    private const ZONES_TEXT_COLOR = [Graphics.COLOR_BLACK,Graphics.COLOR_WHITE,Graphics.COLOR_BLACK,Graphics.COLOR_BLACK,Graphics.COLOR_BLACK,Graphics.COLOR_WHITE,Graphics.COLOR_WHITE] as Array<Graphics.ColorType>;

    public function initialize(params as Dictionary){
        options=params;
        if(params.get(:font)!=null){
            mainText.setFont(params.get(:font));
        }
        if(options.get(:color)==null){
            options.put(:color,Graphics.COLOR_RED);
        }
        Drawable.initialize(params);
        
    }
    public function setFont(font as Graphics.FontType) as Void {
        mainText.setFont(font);
    }
    public function setValue(value as Numeric or Null) as Void {
        if(value==null){
            options.put(:color,Graphics.COLOR_LT_GRAY);
            mainText.setColor(Graphics.COLOR_DK_GRAY);
            mainText.setText("--");
            return;
        }
        LogMonkey.Debug.logMessage("Heart","");
        var currentZone=ZONE_INFO.size()-1;
        var lastZoneValue=0;
        LogMonkey.Debug.logVariable("Heart","value",value);
        for(var z=0;z<ZONE_INFO.size();z++){
            LogMonkey.Debug.logVariable("Heart","ZONE_INFO["+z+"]",ZONE_INFO[z]);
            if(value>ZONE_INFO[z]){
                lastZoneValue=ZONE_INFO[z];
                LogMonkey.Debug.logVariable("Heart","lastZoneValue",lastZoneValue);
                continue;
            }
            currentZone=z;
            LogMonkey.Debug.logVariable("Heart","currentZone",currentZone);
            break;
        }
       
        if(currentZone>=ZONE_INFO.size()){
            //currentZone=ZONE_INFO.size();
        } 
        //LogMonkey.Debug.logVariable("Heart","currentZone",currentZone);
        LogMonkey.Debug.logVariable("Heart","value",value);
        options.put(:color,ZONES_COLOR[currentZone]);
        mainText.setColor(ZONES_TEXT_COLOR[currentZone]);

        
            LogMonkey.Debug.logVariable("Heart","ZONE_INFO",ZONE_INFO);
            LogMonkey.Debug.logVariable("Heart","lastZoneValue",lastZoneValue);
            LogMonkey.Debug.logVariable("Heart","currentZone",currentZone);
            LogMonkey.Debug.logVariable("Heart","ZONE_INFO["+currentZone+"]",ZONE_INFO[currentZone]);
            if(value>=ZONE_INFO[ZONE_INFO.size()-1]){
                currentZone=ZONE_INFO.size();
            } else {
                currentZone=currentZone+((value-lastZoneValue)/(ZONE_INFO[currentZone]-lastZoneValue).toFloat());
            }
            if(currentZone<0){
                currentZone=0;
            }
            LogMonkey.Debug.logMessage("Heart","----");
            LogMonkey.Debug.logVariable("Heart","value",value);
            LogMonkey.Debug.logVariable("Heart","currentZone",currentZone);
        
        mainText.setText(currentZone.format("%.1f"));
    }

    public function setVisible(visible as Boolean) as Void {
        self.visible=visible;
    }
    public function isVisible() as Boolean {
        return self.visible;
    }
    private var fps={:debug=>false,:polygon=>null,:circleXl=>0,:circleXr=>0,:circleY=>0,:circleR=>0} as Dictionary<Symbol,Array>;
    
    public function onLayout(dc as Dc) as Void {
        mainText.locX=self.locX;
        mainText.locY=self.locY;
        
        var a=dc.getTextWidthInPixels("0.0",mainText.getFont());
        var b=mainText.getFontAscent();
        //var b=mainText.getFontHeight();
        var d=mainText.getFontDescent();
        var a2=(a/2).toNumber();
        var b2=(b/2).toNumber();
        var y=locY-(d/2).toNumber();
        var c=a2>b?a2:b;
        var c2=c/2;
        var r=Math.sqrt(2*c*c)/2;

        fps.put(:polygon,[[locX-c,y+b2],[locX,y-c+b2],[locX+c,y+b2],[locX,y+c+b2]] as Array<Array<Graphics.Point2D>>);
        fps.put(:circleXl,locX-c2);
        fps.put(:circleXr,locX+c2);
        fps.put(:circleY,y);
        fps.put(:circleR,r);
        //onLayoutDebug(dc);
    }
    (:debug)
    public function onLayoutDebug(dc as Dc) as Void {
        var a=dc.getTextWidthInPixels("0.0",mainText.getFont());
        var b=mainText.getFontAscent();
        //var b=mainText.getFontHeight();
        var d=mainText.getFontDescent();
        var a2=(a/2).toNumber();
        var b2=(b/2).toNumber();
        var y=locY-(d/2).toNumber();
        fps.put(:debug,true as Boolean);
        fps.put(:centerCrossV,[locX,y-b,locX,y+b] as Array<Number>);
        fps.put(:centerCrossH,[locX-a,y,locX+a,y] as Array<Number>);
        fps.put(:outlineText,[locX-a2,y-b2,a,b] as Array<Number>);
    }

    (:release)
    public function onLayoutDebug(dc as Dc) as Void {
    }

    (:typecheck(true))
    public function draw(dc as Dc)  as Void {
        if(!visible){
            return;
        }

        dc.setColor(options.get(:color) as Graphics.ColorValue,Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(fps.get(:polygon));
        //dc.drawCircle(fps.get(:circleXl),fps.get(:circleY),fps.get(:circleR));
        //dc.drawCircle(fps.get(:circleXr),fps.get(:circleY),fps.get(:circleR));
        dc.fillCircle(fps.get(:circleXl),fps.get(:circleY),fps.get(:circleR));
        dc.fillCircle(fps.get(:circleXr),fps.get(:circleY),fps.get(:circleR));


        // DEBUG
        if(fps.get(:debug)){
            dc.setColor(Graphics.COLOR_LT_GRAY,Graphics.COLOR_TRANSPARENT);
            var arr4=fps.get(:centerCrossV) as Array<Number>;
            dc.drawLine(arr4[0],arr4[1],arr4[2],arr4[3]);
            arr4=fps.get(:centerCrossH) as Array<Number>;
            dc.drawLine(arr4[0],arr4[1],arr4[2],arr4[3]);
            dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);
            arr4=fps.get(:outlineText) as Array<Number>;
            dc.drawRectangle(arr4[0],arr4[1],arr4[2],arr4[3]);

            dc.drawLine(fps.get(:circleXl)-3,fps.get(:circleY)-3,fps.get(:circleXl)+3,fps.get(:circleY)+3);
            dc.drawLine(fps.get(:circleXl)-3,fps.get(:circleY)+3,fps.get(:circleXl)+3,fps.get(:circleY)-3);
        }

        mainText.draw(dc);
    }
}