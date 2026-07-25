import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class MyText extends Text{

    private var options as Dictionary;

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
        Text.initialize(options);
    }

    public function setFont(font as Graphics.FontType) as Void {
        options.put(:font,font);
        Text.setFont(font);
    }
    public function getFont() as FontType {
        return options.get(:font) as FontType ;
    }

    public function setText(text as Lang.String or Lang.ResourceId) as Void {
        if(text instanceof Lang.ResourceId){
            text=Application.loadResource(text);
        }
        options.put(:text,text);
        Text.setText(text);
    }

    public function setTextFormated(number as Numeric or Null,format as String) as Void {
        if(number!=null){
            options.put(:text,number.format(format!=null?format:"%d"));
        } else {
            options.put(:text,"--");
        }
        Text.setText(options.get(:text) as String);
    }

    public function getText() as String {
        return options.get(:text) as String ;
    }

    public function computeDimension(dc as Dc) as Void {
        var dim=dc.getTextDimensions(options.get(:text) as String,options.get(:font) as FontType);
        self.width=dim[0];
        self.height=dim[1];
    }

    public function setColor(color as Graphics.ColorType) as Void {
        options.put(:color,color);
        Text.setColor(color);
    }
    public function getColor() as ColorType {
        return options.get(:color) as ColorType;
    }
    public function setVisible(visible as Boolean) as Void {
        options.put(:visible,visible);
        Text.setVisible(visible);
    }
    public function getVisible() as Boolean {
        return options.get(:visible) as Boolean;
    }
    public function Xdraw(dc as Dc) as Void {
        
    }
}