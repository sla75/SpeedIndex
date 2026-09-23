import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import LogMonkey;

class Heart extends Drawable {

    private var fps=[] as Array<Array<Graphics.Point2D>>;
    private const SIN60=0.866f;
    
    private var options as Dictionary;
    private var visible=true as Boolean;
    private var mainText=new MyText({:font=>Graphics.FONT_TINY,:justification => Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER});
    private var value=null as Numeric or Null;

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
    public function setValue(value as Numeric or Null) as Void {
        self.value=value;
        mainText.setText(value==null?"-.-":value.format("%.1f"));
    }
    private function _setText(text as String) as Void {
        mainText.setText(text);
    }
    private function _setTextColor(color as Graphics.ColorType) as Void {
        mainText.setColor(color);
    }
    private function _setColor(color as Graphics.ColorType) as Void {
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
        /***
        var l=dc.getTextWidthInPixels("8.8",mainText.getFont());
        var y=mainText.locY-mainText.getFontDescent()/2;
        
        fps=[];
        var lSIN60=l*SIN60;
        var fp=[] as Array<Graphics.Point2D>;
        fp.add([mainText.locX+l,y]);
        fp.add([mainText.locX-l/2,y+lSIN60]);
        fp.add([mainText.locX-l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([mainText.locX+lSIN60,y+l/2]);
        fp.add([mainText.locX-lSIN60,y+l/2]);
        fp.add([mainText.locX,y-l]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([mainText.locX+l/2,y+lSIN60]);
        fp.add([mainText.locX-l,y]);
        fp.add([mainText.locX+l/2,y-lSIN60]);
        fp.add(fp[0]);
        fps.add(fp);

        fp=[] as Array<Graphics.Point2D>;
        fp.add([mainText.locX,y+l]);
        fp.add([mainText.locX-lSIN60,y-l/2]);
        fp.add([mainText.locX+lSIN60,y-l/2]);
        fp.add(fp[0]);
        fps.add(fp);
        /***/
    }

    (:typecheck(true))
    public function draw(dc as Dc)  as Void {
        /***
        if(visible){
            dc.setColor(options.get(:color),Graphics.COLOR_TRANSPARENT);    
            for(var i=0;i<fps.size();i++){
                dc.fillPolygon(fps[i] as Array<Graphics.Point2D>);
            }
            mainText.draw(dc);
        }
        /***/
        var w=dc.getTextWidthInPixels(mainText.getText(),mainText.getFont());
        var a=mainText.getFontAscent();
        var d=mainText.getFontDescent();
        var h=mainText.getFontHeight();
        

        var fp=[] as Array<Graphics.Point2D>;
        fp.add([locX-w/2-a/2,locY]);
        fp.add([locX,locY-h/2-w/2]);
        fp.add([locX+w/2+a/2,locY]);
        fp.add([locX,locY+h/2+w/2]);
        dc.setColor(Graphics.COLOR_BLUE,Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon(fp);

        dc.setColor(Graphics.COLOR_PINK,Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(locX-w/2,locY-h/2,w,a);
        dc.drawLine(locX-w,locY,locX+w,locY);
        dc.drawLine(locX,locY-w,locX,locY+w);

        dc.setColor(Graphics.COLOR_DK_GREEN,Graphics.COLOR_TRANSPARENT);
        dc.drawLine(locX-w,locY-(h/2+w/2)/2,locX+w,locY-(h/2+w/2)/2);
        dc.drawLine(locX-(w/2+a/2)/2,locY-w,locX-(w/2+a/2)/2,locY+w);
        dc.drawCircle(locX-(w/2+a/2)/2,locY-(h/2+w/2)/2,a>w?a/2:w/2);
        


        //mainText.locY=self.locY+d;
        mainText.draw(dc);
    }
}