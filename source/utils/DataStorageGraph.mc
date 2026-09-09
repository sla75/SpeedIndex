import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import LogMonkey;

class DataStorageGraph {

    
    typedef NumArray as Array<Numeric or Null>;
    private var data as Array<NumArray>;
    //private var data as Array<Numeric or Null>;
    //private var data2 as Array<Numeric or Null>;
    private var maxSize as Number;
    private var minMaximumGraphValue=30 as Number;
    private var visible=true as Boolean;
    private var colors={:lineLow=>ColorMode.COLOR_LT_BLUE,:lineHight=>ColorMode.COLOR_LT_RED,:value=>Graphics.COLOR_RED,:avg=>Graphics.COLOR_DK_BLUE,:max=>Graphics.COLOR_DK_RED} as Dictionary<Symbol,Graphics.ColorType>;

    function initialize(size as Number) {
        LogMonkey.Debug.logMessage("SpeedIndexView.DataStorage()",size.toString());
        self.maxSize=size;
        //points=[] as Array<NumArray>;
        data=new Array<NumArray>[size];
    }
    
    function setMinMaxSpeedGraph(minMaxSpeed as Numeric) as Void {
        self.minMaximumGraphValue=minMaxSpeed;
        if(self.minMaximumGraphValue<=0){
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
        if(data.size()>=maxSize){
            data=data.slice(1,null);
        }
        data.add([numeric1,numeric2] as NumArray);
    }

    (:debug)
    function add(numeric1 as Numeric or Null,numeric2 as Numeric or Null) as Void {
        if(data.size()>=maxSize){
            data=data.slice(1,null);
        }
        if(System.getClockTime().sec==13){
            LogMonkey.Debug.logMessage("DataStorageGraph","new Point12(null,null)");
            data.add([null, null] as NumArray);
        } else {
            data.add([numeric1,numeric2] as NumArray);
        }
    }

    (:typecheck(false))
    function getMinMax(size as Number) as NumArray or Null{
        var minMax=null;
        var value;
        for(var i=data.size()-1;i>=data.size()-size;i--){
            if(i<0||data[i]==null){
                break;
            }
            //LogMonkey.Debug.logVariable("DataStorage.getMinMax("+size+")","points["+i+"]",points[i]);
            value=data[i][0];
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
        return data.size();
    }

    (:typecheck(true))
    function draw(dc as Dc,locX as Number) as Void {
        if(!visible){
            return;
        }

        var minMax=getMinMax(dc.getWidth());
        LogMonkey.Debug.logVariable("DataStorage.draw()","minMax",minMax);

        if(minMax==null||(minMax[1]-minMax[0]).toFloat()<0.1){
            return;
        }
        
        var koefY=(dc.getHeight()-locX)/(minMax[1]-minMax[0]).toFloat();
        LogMonkey.Debug.logVariable("DataStorage.draw()","koefY",koefY);
        LogMonkey.Debug.logVariable("DataStorage.draw()","data.size()",data.size());
        //LogMonkey.Debug.logVariable("DataStorage.draw()","data",data);

        var drawSpeed=null as Numeric or Null;
        var drawAvg=null as Numeric or Null;
        var prevSpeed=null as NumArray;
        var prevAvg=null as NumArray;
        for(var i=0;i<data.size();i++){

            if(i>dc.getWidth()||data[data.size()-1-i]==null){
                break;
            }
            
            // Value line
            dc.setPenWidth(1);
            //dc.setColor(colors.get(:line),Graphics.COLOR_TRANSPARENT);
            
            //Compute 1. value
            if(data[data.size()-1-i][0]!=null){
                drawSpeed=dc.getHeight()-(data[data.size()-1-i][0]-minMax[0])*koefY;
            } else {
                drawSpeed=null;
            }

            //Compute 2. value
            if(data[data.size()-1-i][1]!=null){
                drawAvg=dc.getHeight()-(data[data.size()-1-i][1]-minMax[0])*koefY;
            } else {
                drawAvg=null;
            }

            if(drawSpeed!=null){

                if(drawAvg!=null){
                    dc.setPenWidth(1);
                    if(drawAvg<drawSpeed){

                        // Line under average
                        dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                        dc.drawLine(dc.getWidth()-i,drawSpeed,dc.getWidth()-i,dc.getHeight());

                    } else {

                        // Line above average
                        dc.setColor(colors.get(:lineHight),Graphics.COLOR_TRANSPARENT);
                        dc.drawLine(dc.getWidth()-i,drawAvg,dc.getWidth()-i,drawSpeed);

                        // Line under average
                        dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                        dc.drawLine(dc.getWidth()-i,drawAvg,dc.getWidth()-i,dc.getHeight());

                    }
                }
                
                // Draw Value point
                dc.setPenWidth(2);
                dc.setColor(colors.get(:value),Graphics.COLOR_TRANSPARENT);

                if(drawAvg!=null&&prevSpeed!=null){
                    dc.setColor(Graphics.COLOR_DK_RED,Graphics.COLOR_TRANSPARENT);
                    dc.drawLine(prevSpeed[0],prevSpeed[1],dc.getWidth()-i,drawSpeed);
                }
                prevSpeed=[dc.getWidth()-i,drawSpeed];
            } else {
                prevSpeed=null;
            }

            

            if(drawAvg!=null){
                // AVG Point
                dc.setPenWidth(2);
                dc.setColor(colors.get(:avg),Graphics.COLOR_TRANSPARENT);
                if(prevAvg!=null){
                    dc.drawLine(prevAvg[0],prevAvg[1],dc.getWidth()-i,drawAvg);
                } else {
                    dc.drawPoint(dc.getWidth()-i,drawAvg);
                }
                prevAvg=[dc.getWidth()-i,drawAvg];
            } else {
                prevAvg=null;
            }
        }

    }

    function toString() as String{
        return "DataStorage["+maxSize+"/"+data.size()+"]: "+data.toString();
    }

}