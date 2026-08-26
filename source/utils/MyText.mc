import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class MyText {

    private var options as Dictionary;
    private var mainText as Text;
    public var locX as Number;
    public var locY as Number;
    public var width as Number;
    public var height as Number;

    function initialize(options as Dictionary) {
        if(options.get(:font)==null){
            options.put(:font,Graphics.FONT_TINY);
        }
        if(options.get(:text)==null){
            options.put(:text,"");
        }
        if(options.get(:color)==null){
            options.put(:color,Graphics.COLOR_DK_GRAY);
        }
        if(options.get(:visible)==null){
            options.put(:visible,true);
        }
        self.options=options;
        self.options.put(:shiftShadow,options.get(:shiftShadow)!=null?options.get(:shiftShadow):1);
        mainText=new Text(options);
        self.locX=options.get(:locX)!=null?options.get(:locX):0;
        self.locY=options.get(:locY)!=null?options.get(:locY):0;
        self.width=0;
        self.height=0;
    }

    public function setFont(font as Graphics.FontType) as Void {
        options.put(:font,font);
        mainText.setFont(font);
    }
    public function setShiftShadow(shiftShadow as Number) as Void {
        options.put(:shiftShadow,shiftShadow);
    }
    
    public function getFont() as FontType {
        return options.get(:font) as FontType ;
    }
    public function getFontHeight() as Number {
        return Graphics.getFontHeight(getFont());
    }
    public function getFontAscent() as Number {
        return Graphics.getFontAscent(getFont());
    }
    public function getFontDescent() as Number {
        return Graphics.getFontDescent(getFont());
    }

    public function getOptions() as Dictionary {
        return options;
    }
    public function putOption(symbol as Symbol, value as Object) as Void {
        options.put(symbol,value);
    }
    public function setText(text as Lang.String or Lang.ResourceId or Object) as Void {
        if(text instanceof String){
        } else if(text instanceof ResourceId){
            text=Application.loadResource(text);
        } else if(text has :toString){
            text=text.toString();
        } else {
            text="#N/A";
        }
        options.put(:text,text);
        mainText.setText(text);
    }

    public function setTextFormated(number as Numeric or Null,format as String) as Void {
        if(number!=null){
            options.put(:text,number.format(format!=null?format:"%d"));
        } else {
            options.put(:text,"--");
        }
        mainText.setText(options.get(:text) as String);
    }

    public function getText() as String {
        return options.get(:text) as String ;
    }

    public function computeDimension(dc as Dc) as Array<Number> {
        var dim=dc.getTextDimensions(options.get(:text) as String,options.get(:font) as FontType);
        self.width=dim[0];
        self.height=dim[1];
        mainText.width=dim[0];
        mainText.height=dim[1];
        return dim;
    }

    public function setColor(color as Graphics.ColorType) as Void {
        options.put(:color,color);
        mainText.setColor(color);
    }
    public function setShadowColor(colorBefore as Graphics.ColorType,colorAfter as Graphics.ColorType) as Void {
        if(colorBefore==null||colorBefore==Graphics.COLOR_TRANSPARENT){
            options.put(:colorShadowBefore,null);
        } else {
            options.put(:colorShadowBefore,colorBefore);
        }
        if(colorAfter==null||colorAfter==Graphics.COLOR_TRANSPARENT){
            options.put(:colorShadowAfter,null);
        } else {
            options.put(:colorShadowAfter,colorAfter);
        }
        
    }
    public function getColor() as ColorType {
        return options.get(:color) as ColorType;
    }
    public function setVisible(visible as Boolean) as Void {
        options.put(:visible,visible);
        mainText.setVisible(visible);
    }
    public function isVisible() as Boolean {
        return options.get(:visible) as Boolean;
    }
    public function setJustification(justification as TextJustification or Number) as Void {
        options.put(:justification,justification);
        mainText.setJustification(justification);
    }
    public function setBackgroundColor(color as Graphics.ColorType) as Void {
        options.put(:backgroundColor,color);
        mainText.setBackgroundColor(color);
    }
    
    public function draw(dc as Dc) as Void {
        //if(isVisible()&&options.get(:colorshadow)!=null){
        //    dc.drawText(self.locX,self.locY,options.get(:font) as FontType,options.get(:text) as String,options.get(:justification) as TextJustification or Number);
        //}
        if(isVisible()){
            if(options.get(:colorShadowBefore)!=null){
                mainText.setColor(options.get(:colorShadowBefore) as Graphics.ColorType);
                mainText.locX=self.locX-options.get(:shiftShadow) as Number;;
                mainText.locY=self.locY-options.get(:shiftShadow) as Number;;
                //LogMonkey.Debug.logMessage("MyText("+options.get(:text)+").draw()","colorshadow="+options.get(:colorshadow)+", :shiftShadow="+options.get(:shiftShadow)+" ["+shadowText.locX+","+shadowText.locY+"]");
                mainText.draw(dc);
            }
            if(options.get(:colorShadowAfter)!=null){
                mainText.setColor(options.get(:colorShadowAfter) as Graphics.ColorType);
                mainText.locX=self.locX+options.get(:shiftShadow) as Number;;
                mainText.locY=self.locY+options.get(:shiftShadow) as Number;;
                //LogMonkey.Debug.logMessage("MyText("+options.get(:text)+").draw()","colorshadow="+options.get(:colorshadow)+", :shiftShadow="+options.get(:shiftShadow)+" ["+shadowText.locX+","+shadowText.locY+"]");
                mainText.draw(dc);
            }
            mainText.setColor(options.get(:color) as Graphics.ColorType);
            mainText.locX=self.locX;
            mainText.locY=self.locY;
            mainText.draw(dc);
        }
    }
}