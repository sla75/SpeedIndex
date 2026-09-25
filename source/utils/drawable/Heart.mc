import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import LogMonkey;

class Heart extends Drawable {

   
    private var options as Dictionary;
    private var visible=true as Boolean;
    private var mainText=new MyText({:font=>Graphics.FONT_TINY,:justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});
    private var value=null as Numeric or Null;

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
        self.value=value;
        mainText.setText(value==null?"-.-":value.format("%.1f"));
    }
    private function _setText(text as String) as Void {
        mainText.setText(text);
    }
    private function setTextColor(color as Graphics.ColorType) as Void {
        mainText.setColor(color);
    }
    private function setColor(color as Graphics.ColorType) as Void {
        options.put(:color,color);
    }
    public function setVisible(visible as Boolean) as Void {
        self.visible=visible;
    }
    public function isVisible() as Boolean {
        return self.visible;
    }
    private var fps={:polygon=>null,:circleXl=>0,:circleXr=>0,:circleY=>0,:circleR=>0} as Dictionary<Symbol,Array>;
    public function onLayout(dc as Dc) as Void {
        mainText.locX=self.locX;
        mainText.locY=self.locY;
        
        var a=dc.getTextWidthInPixels("0.0",mainText.getFont());
        var b=mainText.getFontAscent();
        //var b=mainText.getFontHeight();
        var d=mainText.getFontDescent();
        var a2=(a/2).toNumber();
        var a4=(a2/2).toNumber();
        var b2=(b/2).toNumber();
        var y=locY-(d/2).toNumber();
        var r=Math.sqrt(2*(a2*a2))/2;

        /***
        dc.setColor(Graphics.COLOR_LT_GRAY,Graphics.COLOR_TRANSPARENT);
        dc.drawLine(locX,y-b,locX,y+b);
        dc.drawLine(locX-a,y,locX+a,y);
        dc.setColor(Graphics.COLOR_DK_GRAY,Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(locX-a2,y-b2,a,b);
        /***/

        var fp=[] as Array<Graphics.Point2D>;
        fp.add([locX-a2,y+b2]);
        //fp.add([locX,y+b2-a2]);
        fp.add([locX,y]);
        fp.add([locX+a2,y+b2]);
        fp.add([locX,y+b2+a2]);
        fps.put(:polygon,fp);
        fps.put(:circleXl,locX-a4);
        fps.put(:circleXr,locX+a4);
        fps.put(:circleY,y-b2);
        fps.put(:circleR,r);
    }

    (:typecheck(true))
    public function draw(dc as Dc)  as Void {
        if(!visible){
            return;
        }
        dc.setColor(options.get(:color) as Graphics.ColorValue,Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(fps.get(:polygon));
        dc.drawCircle(fps.get(:circleXl),fps.get(:circleY),fps.get(:circleR));
        dc.drawCircle(fps.get(:circleXr),fps.get(:circleY),fps.get(:circleR));
        //dc.fillCircle(fps.get(:circleXl),fps.get(:circleY),fps.get(:circleR));
        //dc.fillCircle(fps.get(:circleXr),fps.get(:circleY),fps.get(:circleR));
        mainText.draw(dc);
    }
}