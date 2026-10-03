import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.UserProfile;
import Toybox.WatchUi;
import LogMonkey;

class Heart extends Drawable {

   
    private var options as Dictionary;
    private var visible=true as Boolean;
    private var mainText=new MyText({:font=>Graphics.FONT_TINY, :color=>Graphics.COLOR_LT_GRAY, :justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});
    //private var value=null as Numeric or Null;
    public static const ZONE_INFO = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
    private static const ZONES_COLOR = [Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLUE,Graphics.COLOR_DK_GREEN,Graphics.COLOR_YELLOW,Graphics.COLOR_RED,Graphics.COLOR_DK_RED] as Array<Graphics.ColorType>;
    private static const ZONES_TEXT_COLOR = [Graphics.COLOR_BLACK,Graphics.COLOR_WHITE,Graphics.COLOR_BLACK,Graphics.COLOR_WHITE,Graphics.COLOR_BLACK,Graphics.COLOR_WHITE,Graphics.COLOR_WHITE] as Array<Graphics.ColorType>;
    
    public function initialize(params as Dictionary){
        options=params;
        if(params.get(:font)!=null){
            mainText.setFont(params.get(:font));
        }
        if(options.get(:color)==null){
            options.put(:color,Graphics.COLOR_RED);
        }
        options.put(:colorShadowBefore,options.get(:colorShadowBefore)!=null?options.get(:colorShadowBefore):Graphics.COLOR_LT_GRAY);
        options.put(:colorShadowAfter,options.get(:colorShadowAfter)!=null?options.get(:colorShadowAfter):Graphics.COLOR_DK_GRAY);
        
        Drawable.initialize(params);
        
    }
    public function setFont(font as Graphics.FontType) as Void {
        mainText.setFont(font);
    }
    public static function getZone(value as Number or Null) as Float {
        if(value==null||value<1){
            return 0f;
        }
        var currentZone=6;
        var lastZoneValue=0;
        for(var z=0;z<ZONE_INFO.size();z++){
            if(value<=ZONE_INFO[z]){
                //LogMonkey.Debug.logMessage("Heart",value+" <= "+ZONE_INFO[z]+"["+z+"] break");
                currentZone=z;
                break;
            }
            lastZoneValue=ZONE_INFO[z];
            //LogMonkey.Debug.logMessage("Heart",value+" > "+ZONE_INFO[z]+"["+z+"] continue");
        }
        if(currentZone==6){
            //LogMonkey.Debug.logVariable("Heart",value+" currentZone A",currentZone);
            return currentZone.toFloat();    
        }
        //LogMonkey.Debug.logMessage("Heart","currentZone+="+currentZone+"+("+value+"-"+lastZoneValue+"-1)/("+ZONE_INFO[currentZone]+"-"+lastZoneValue+").toFloat()");
        currentZone+=(value-lastZoneValue-1)/(ZONE_INFO[currentZone]-lastZoneValue).toFloat();
        currentZone*=10;
        currentZone=Math.floor(currentZone)/10f;
        //LogMonkey.Debug.logVariable("Heart",value+" currentZone B",currentZone);
        return currentZone;
    }
    public function setValue(value as Numeric or Null) as Void {

        if(value==null){
            options.put(:color,Graphics.COLOR_LT_GRAY);
            mainText.setColor(Graphics.COLOR_DK_GRAY);
            mainText.setText("--");
            return;
        }
        var currentZone=getZone(value);
       
        LogMonkey.Debug.logMessage("Heart","value="+value+" f="+currentZone.format("%.1f")+" currentZone="+currentZone);
        mainText.setText(currentZone.format("%.1f"));
        currentZone=Math.floor(currentZone).toNumber();
        options.put(:color,ZONES_COLOR[currentZone]);
        mainText.setColor(ZONES_TEXT_COLOR[currentZone]);

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
        var d=mainText.getFontDescent();
        var a2=(a/2).toNumber();
        var b2=(b/2).toNumber();
        var y=locY-(d/2).toNumber();
        var c=a2>b?a2:b;
        var c2=c/2;
        var r=Math.sqrt(2*c*c)/2;

        fps.put(:polygonBefore,[[locX-c-1,y+b2-1],[locX-1,y-c+b2-1],[locX+c-1,y+b2-1],[locX-1,y+c+b2-1]] as Array<Array<Graphics.Point2D>>);
        fps.put(:polygon,[[locX-c,y+b2],[locX,y-c+b2],[locX+c,y+b2],[locX,y+c+b2]] as Array<Array<Graphics.Point2D>>);
        fps.put(:polygonAfter,[[locX-c+1,y+b2+1],[locX+1,y-c+b2+1],[locX+c+1,y+b2+1],[locX+1,y+c+b2+1]] as Array<Array<Graphics.Point2D>>);
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
        LogMonkey.Debug.logVariable("Heart:draw","visible",visible);
        LogMonkey.Debug.logVariable("Heart:draw","self.visible",self.visible);
        if(!self.visible){
            return;
        }
        /***/
        dc.setColor(options.get(:colorShadowBefore) as Graphics.ColorValue,Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(fps.get(:polygonBefore));
        dc.fillCircle(fps.get(:circleXl)-1,fps.get(:circleY)-1,fps.get(:circleR));
        dc.fillCircle(fps.get(:circleXr)-1,fps.get(:circleY)-1,fps.get(:circleR));
        dc.setColor(options.get(:colorShadowAfter) as Graphics.ColorValue,Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(fps.get(:polygonAfter));
        dc.fillCircle(fps.get(:circleXl)+1,fps.get(:circleY)+1,fps.get(:circleR));
        dc.fillCircle(fps.get(:circleXr)+1,fps.get(:circleY)+1,fps.get(:circleR));
        /***/

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