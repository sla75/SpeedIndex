import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import LogMonkey;

class DataStorageGraph {

    private var data as Array<Numeric or Null>;
    private var data2 as Array<Numeric or Null>;
    private var maxSize as Number;
    private var minMaximumGraphValue=30 as Number;
    private var visible=true as Boolean;
    private var colors={:lineLow=>ColorMode.COLOR_LT_BLUE,:lineHight=>ColorMode.COLOR_LT_RED,:value=>Graphics.COLOR_RED,:avg=>Graphics.COLOR_DK_BLUE,:max=>Graphics.COLOR_DK_RED} as Dictionary<Symbol,Graphics.ColorType>;

    function initialize(size as Number) {
        LogMonkey.Debug.logMessage("SpeedIndexView.DataStorage()",size.toString());
        self.maxSize=size;
        data=[] as Array<Numeric or Null>;
        data2=[] as Array<Numeric or Null>;
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
    function add(numeric as Numeric or Null) as Void {
        if(data.size()>=maxSize){
            data=data.slice(1,null);
        }
        data.add(numeric);
    }
    function add2(numeric as Numeric or Null) as Void {
        if(data2.size()>=maxSize){
            data2=data2.slice(1,null);
        }
        data2.add(numeric);
    }

    function getMinMax(size as Number) as [Numeric,Numeric] or Null{
        var minMax=null;
        var value;
        for(var i=data.size()-1;i>=data.size()-size;i--){
            if(i<0){
                break;
            }
            value=data[i];
            //LogMonkey.Debug.logVariable("DataStorage.getMinMax("+size+")","data["+i+"]",data[i]);
            if(value==null){
                continue;
            }
            if(minMax==null){
                minMax=[data[i],minMaximumGraphValue] as [Numeric,Numeric];
            } else {
                if(minMax[0]>value){
                    minMax[0]=data[i];
                } else if(minMax[1]<data[i]){
                    minMax[1]=data[i];
                }
            }
        }
        return minMax;
    }

    function size() as Number {
        return data.size();
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
        var lastXY1=null as Array<Numeric> or Null;
        var lastXY2=null as Array<Numeric> or Null;
        var avgY=null;
        var dataY=0;

        for(var i=0;i<data.size();i++){
            if(data[data.size()-1-i]==null||i>dc.getWidth()){
                lastXY1=null;
                continue;
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

            dataY=dc.getHeight()-(data[data.size()-1-i]-minMax[0])*koefY;
            if(data2.size()>0&&data2[data2.size()-1-i]!=null){
                avgY=dc.getHeight()-(data2[data2.size()-1-i]-minMax[0])*koefY;
            } else {
                avgY=null;
            }

            if(avgY!=null){
                
                // Line under average
                dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                dc.drawLine(dc.getWidth()-i,dataY>avgY?dataY:avgY,dc.getWidth()-i,dc.getHeight());

                if(dataY<avgY){
                    // Line above average
                    dc.setColor(colors.get(:lineHight),Graphics.COLOR_TRANSPARENT);
                    dc.drawLine(dc.getWidth()-i,dataY,dc.getWidth()-i,avgY);
                }

                // Draw AVG point
                if(colors.get(:avg)!=null||colors.get(:avg)!=Graphics.COLOR_TRANSPARENT){
                    dc.setPenWidth(2);
                    dc.setColor(colors.get(:avg),Graphics.COLOR_TRANSPARENT);
                    dc.drawPoint(dc.getWidth()-i,avgY);
                    dc.setPenWidth(1);
                }                
                if(lastXY2!=null){
                    // Connector max line with preview
                    dc.setColor(colors.get(:avg),Graphics.COLOR_TRANSPARENT);
                    dc.drawLine(lastXY2[0],lastXY2[1],dc.getWidth()-i,avgY);
                }    
            } else {
                dc.setColor(colors.get(:lineLow),Graphics.COLOR_TRANSPARENT);
                dc.drawLine(dc.getWidth()-i,dataY,dc.getWidth()-i,dc.getHeight());
            }

            if(lastXY1!=null){
                // Connector max line with preview
                dc.setPenWidth(2);
                dc.setColor(colors.get(:value),Graphics.COLOR_TRANSPARENT);
                dc.drawLine(lastXY1[0],lastXY1[1],dc.getWidth()-i,dataY);
            }
            
            
            lastXY1=[dc.getWidth()-i,dataY,0] as Array<Numeric>;
            lastXY2=[dc.getWidth()-i,avgY,0] as Array<Numeric>;

            /***
            if(data[data.size()-1-i]==minMax[1]){
                // Draw Max point value
                    dc.setColor(colors.get(:max),Graphics.COLOR_TRANSPARENT);
                    dc.fillCircle(dc.getWidth()-i,dataY,5);
            }
            /***/
        }

    }

    function toString() as String{
        return "DataStorage["+maxSize+"/"+data.size()+"]: "+data.toString();
    }
}