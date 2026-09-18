import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import LogMonkey;

class Gear extends Drawable {

    private var fps=[] as Array<Array<Graphics.Point2D>>;
    private const SIN60=0.866f;
    
    private var options as Dictionary;
    private var visible=true as Boolean;
    private var mainText=new MyText({:font=>Graphics.FONT_TINY,:justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});

    public function initialize(params as Dictionary){
        options=params;
        if(params.get(:font)!=null){
            mainText.setFont(params.get(:font));
        }
        Drawable.initialize(params);
    }
    
    public function setFont(font as Graphics.FontType) as Void {
        mainText.setFont(font);
    }
    public function setText(text as String) as Void {
        mainText.setText(text);
    }
    public function setTextColor(color as Graphics.ColorType) as Void {
        mainText.setColor(color);
    }
    public function setColor(color as Graphics.ColorType) as Void {
        options.put(:color,color);
    }
    public function setVisible(visible as Boolean) as Void {
        self.visible=visible;
    }
    public function isVisible() as Boolean {
        return self.visible;
    }
    public function onLayout(dc as Dc) as Void {
        mainText.locX=self.locX;
        mainText.locY=self.locY;
        var l=dc.getTextWidthInPixels("12",mainText.getFont());
        var y=mainText.locY-mainText.getFontDescent()/2;
        
        fps=[];
        var lSIN60=l*SIN60;
        var fp=[] as Array<Graphics.Point2D>;
        fp.add([self.locX+l,y]);
        fp.add([self.locX-l/2,y+lSIN60]);
        fp.add([self.locX-l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([self.locX+lSIN60,y+l/2]);
        fp.add([self.locX-lSIN60,y+l/2]);
        fp.add([self.locX,y-l]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([self.locX+l/2,y+lSIN60]);
        fp.add([self.locX-l,y]);
        fp.add([self.locX+l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([self.locX,y+l]);
        fp.add([self.locX-lSIN60,y-l/2]);
        fp.add([self.locX+lSIN60,y-l/2]);
        fp.add(fp[0]);
        fps.add(fp);
    }

    (:typecheck(false))
    public function draw(dc as Dc)  as Void {
        if(visible){
            dc.setColor(options.get(:color),Graphics.COLOR_TRANSPARENT);    
            for(var i=0;i<fps.size();i++){
                dc.fillPolygon(fps[i] as Array<Graphics.Point2D>);
            }
            mainText.draw(dc);
        }
        
    }

    (:release)
    public function checkDebug(colorMode as ColorMode) as Void {
    }
    (:debug)
    public function checkDebug(colorMode as ColorMode) as Void {
        var currentGear=Math.rand()%12+1;
        currentGear=System.getClockTime().sec==17?null:currentGear;
        LogMonkey.Debug.logVariable("Gear.checkDebug()","currentGear",currentGear);
        self.setText(currentGear==null?"--":currentGear.toString());
        if(currentGear==1||currentGear==12){
            self.setColor(colorMode.getFieldColor(:rearEdge));
        } else {
            self.setColor(colorMode.getFieldColor(:value));
        }
    }
}