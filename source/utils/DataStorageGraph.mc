import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import LogMonkey;

class DataStorageGraph {

    private var points as Array<Point12 or Null>;
    //private var data as Array<Numeric or Null>;
    //private var data2 as Array<Numeric or Null>;
    private var maxSize as Number;
    private var minMaximumGraphValue=30 as Number;
    private var visible=true as Boolean;
    private var colors={:lineLow=>ColorMode.COLOR_LT_BLUE,:lineHight=>ColorMode.COLOR_LT_RED,:value=>Graphics.COLOR_RED,:avg=>Graphics.COLOR_DK_BLUE,:max=>Graphics.COLOR_DK_RED} as Dictionary<Symbol,Graphics.ColorType>;

    function initialize(size as Number) {
        LogMonkey.Debug.logMessage("SpeedIndexView.DataStorage()",size.toString());
        self.maxSize=size;
        points=[] as Array<Point12 or Null>;
        //data=[] as Array<Numeric or Null>;
        //data2=[] as Array<Numeric or Null>;
        Properties.setValue("property_minMaxSpeed",Properties.getValue("property_minMaxSpeed")==null?30:Properties.getValue("property_minMaxSpeed") as Number);
        handleSettingUpdate();
    }
    function handleSettingUpdate() as Void {
        minMaximumGraphValue=Properties.getValue("property_minMaxSpeed");
        if(minMaximumGraphValue==0){
            minMaximumGraphValue=-99999;
        }
    }
    public function setColors(colors as Dictionary<Symbol,Graphics.ColorType>){
        self.colors=colors;
    }
    function setVisible(visible as Boolean) as Void {
        self.visible=visible;
    }

    (:release)
    function add(numeric1 as Numeric or Null,numeric2 as Numeric or Null) as Void {
        if(points.size()>=maxSize){
            points=points.slice(1,null);
        }
        points.add(new Point12(null,null));
    }

    (:debug)
    function add(numeric1 as Numeric or Null,numeric2 as Numeric or Null) as Void {
        if(points.size()>=maxSize){
            points=points.slice(1,null);
        }
        if(System.getClockTime().sec==13){
            LogMonkey.Debug.logMessage("DataStorageGraph","new Point12(null,null)");
            points.add(new Point12(null,null));
        } else {
            points.add(new Point12(numeric1,numeric2));
        }
    }

    (:typecheck(false))
    function getMinMax(size as Number) as [Numeric,Numeric] or Null{
        var minMax=null;
        var value;
        for(var i=points.size()-1;i>=points.size()-size;i--){
            if(i<0){
                break;
            }
            value=points[i].value1;
            //LogMonkey.Debug.logVariable("DataStorage.getMinMax("+size+")","data["+i+"]",data[i]);
            if(value==null){
                continue;
            }
            if(minMax==null){
                minMax=[value,minMaximumGraphValue] as [Numeric,Numeric];
            } else {
                if(minMax[0]>value){
                    minMax[0]=value;
                } else if(minMax[1]<value){
                    minMax[1]=value;
                }
            }
        }
        return minMax;
    }

    function size() as Number {
        return points.size();
    }

    function draw(dc as Dc,locX as Number) as Void {
        if(!visible){
            return;
        }
        //data=[5,0,null,null,null] as Array<Numeric or Null>;
        //dc.setColor(Graphics.COLOR_PINK,Graphics.COLOR_TRANSPARENT);
        //dc.drawLine(0,shiftX,dc.getWidth(),dc.getHeight());
        //dc.drawLine(dc.getWidth(),shiftX,0,dc.getHeight());

        var minMax=getMinMax(dc.getWidth());
        LogMonkey.Debug.logVariable("DataStorage.draw()","minMax",minMax);
        if(minMax==null||(minMax[1]-minMax[0]).toFloat()<0.1){
            return;
        }
        var koefY=(dc.getHeight()-locX)/(minMax[1]-minMax[0]).toFloat();
        LogMonkey.Debug.logVariable("DataStorage.draw()","koefY",koefY);
        LogMonkey.Debug.logVariable("DataStorage.draw()","points.size()",points.size());

        var draw12=new Point12(null,null);
        var last1=new Point12(null,null);
        var last2=new Point12(null,null);
        for(var i=0;i<points.size();i++){
            if(i>dc.getWidth()){
                break;
            }
            
            //if(lastXY==null){
            //    lastXY=[dc.getWidth()-0,dc.getHeight()-(data[data.size()-1]-mm[0])*k] as Array<Numeric>;
            //}
            //LogMonkey.Debug.logMessage("DataStorage.draw()","dc.drawLine("+i+","+(dc.getHeight()-(data[i]-mm[0])*k)+","+i+","+dc.getHeight()+")");
            //LogMonkey.Debug.logMessage("DataStorage.draw()","dc.drawLine("+i+") koefY="+koefY+", minMax[0]="+minMax[0]);
            //LogMonkey.Debug.logVariable("DataStorage.draw()","data",data);
            //LogMonkey.Debug.logVariable("DataStorage.draw()","data["+(data.size()-1-i)+"]",data[data.size()-1-i]);

            // Value line
            dc.setPenWidth(1);
            //dc.setColor(colors.get(:line),Graphics.COLOR_TRANSPARENT);
            
            //Compute 1. value
            if(points[points.size()-1-i].value1!=null){
                draw12.value1=dc.getHeight()-(points[points.size()-1-i].value1-minMax[0])*koefY;
            } else {
                draw12.value1=null;
            }

            //Compute 2. value
            if(points[points.size()-1-i].value2!=null){
                draw12.value2=dc.getHeight()-(points[points.size()-1-i].value2-minMax[0])*koefY;
            } else {
                draw12.value2=null;
            }

            if(draw12.value1!=null){

                    if(draw12.value2!=null){
                        if(draw12.value2<draw12.value1){
                            // Line under average
                            dc.setPenWidth(1);
                            dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                            dc.drawLine(dc.getWidth()-i,draw12.value1,dc.getWidth()-i,dc.getHeight());

                        } else {
                            
                            dc.setPenWidth(1);
                            // Line above average
                            dc.setColor(colors.get(:lineHight),Graphics.COLOR_TRANSPARENT);
                            dc.drawLine(dc.getWidth()-i,draw12.value2,dc.getWidth()-i,draw12.value1);

                            // Line under average
                            dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                            dc.drawLine(dc.getWidth()-i,draw12.value2,dc.getWidth()-i,dc.getHeight());

                        }
                    }
                    // Draw Value point
                    // TODO abov and underline different colors
                    dc.setPenWidth(2);
                    dc.setColor(colors.get(:value),Graphics.COLOR_TRANSPARENT);

                    if(draw12.value2!=null&&last1.value2){
                        if(draw12.value1<draw12.value2){
                            dc.drawLine(last1.value1,last1.value2,dc.getWidth()-i,draw12.value1);
                        }
                    }

            }

            last1.value1=dc.getWidth()-i;
            last1.value2=draw12.value1;

            if(draw12.value2!=null){
                    // AVG Point
                    dc.setPenWidth(2);
                    dc.setColor(colors.get(:avg),Graphics.COLOR_TRANSPARENT);
                    if(last2.value2!=null){
                        dc.drawLine(last2.value1,last2.value2,dc.getWidth()-i,draw12.value2);
                    } else {
                        dc.drawPoint(dc.getWidth()-i,draw12.value2);
                    }
            }
            last2.value1=dc.getWidth()-i;
            last2.value2=draw12.value2;
        }

    }

    function toString() as String{
        return "DataStorage["+maxSize+"/"+points.size()+"]: "+points.toString();
    }

    (:typecheck(false))
    class Point12 {
        public var value1=null as Numeric or Null;
        public var value2=null as Numeric or Null;
        //private var attributes={} as Dictionary<Symbol,Object>;

        function initialize(numeric1 as Numeric or Null,numeric2 as Numeric or Null) {
            self.value1=numeric1;
            self.value2=numeric2;
        }
        /***
        function addAttr(symbol as Symbol, value as Object) as Void {
            self.attributes.put(symbol, value);
        }

        function getAttr(symbol as Symbol) as Object {
            return self.attributes.get(symbol);
        }
        function delAttr(symbol as Symbol) as Void {
            return self.attributes.remove(symbol);
        }
        function existsAttr(symbol as Symbol) as Boolean {
            return self.attributes.get(symbol)!=null;
        }
        /***/
    }
}