import Toybox.Graphics;
import Toybox.Lang;
import LogMonkey;

class DataStorageGraph {

    private var data as Array<Numeric>;
    private var maxSize as Number;
    private var average=null as Numeric or Null;
    private var minMaximumGraphValue=0 as Number;
    private var visible=true as Boolean;
    private var colors={:line=>Graphics.COLOR_YELLOW,:value=>Graphics.COLOR_ORANGE,:minmax=>Graphics.COLOR_BLACK} as Dictionary<Symbol,Graphics.ColorType>;

    function initialize(size as Number) {
        LogMonkey.Debug.logMessage("SpeedIndexView.DataStorage()",size.toString());
        self.maxSize=size;
        data=[] as Array<Numeric>;
    }
    public function setColors(colors as Dictionary<Symbol,Graphics.ColorType>){
        self.colors=colors;
    }
    function setMinMaximumGraphValue(value as Numeric) as Void {
        self.minMaximumGraphValue=value;
    }
    function setVisible(visible as Boolean) as Void {
        self.visible=visible;
    }
    function add(numeric as Numeric or Null) as Void {
        if(data.size()>=maxSize){
            //suma-=data[0];
            data=data.slice(1,null);
        }
        data.add(numeric);
        //suma+=numeric;
    }
    function setAvg(avg as Numeric or Null) as Void {
        self.average=avg;
    }

    function getMinMax(size as Number) as [Numeric,Numeric] or Null{
        var mm=null;
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
            if(mm==null){
                mm=[data[i],minMaximumGraphValue] as [Numeric,Numeric];
                continue;
            }
            if(mm[0]>value){
                mm[0]=data[i];
            } else if(mm[1]<data[i]){
                mm[1]=data[i];
            }
        }
        return mm;
    }

    private function X_getAverage(size as Number) as Numeric or Null{
        var suma=0;
        var dataSize=0;
        for(var i=data.size()-1;i>=data.size()-size;i--){
            if(data[i]!=null){
                suma+=data[i];
                dataSize++;
            }
        }
        return dataSize==0?null:suma/dataSize.toFloat();
    }
    function size() as Number {
        return data.size();
    }

    function draw(dc as Dc,locX as Number) as Void {
        if(!visible){
            return;
        }
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
        var lastXY=null as Array<Numeric> or Null;
        var avgY=self.average!=null?dc.getHeight()-(self.average-minMax[0])*koefY:null;
        var dataY=0;
        for(var i=0;i<data.size();i++){
            if(data[i]==null||i>dc.getWidth()){
                continue;
            }
            //if(lastXY==null){
            //    lastXY=[dc.getWidth()-0,dc.getHeight()-(data[data.size()-1]-mm[0])*k] as Array<Numeric>;
            //}
            //LogMonkey.Debug.logMessage("DataStorage.draw()","dc.drawLine("+i+","+(dc.getHeight()-(data[i]-mm[0])*k)+","+i+","+dc.getHeight()+")");
            
            // Value line
            dc.setPenWidth(1);
            dc.setColor(colors.get(:line),Graphics.COLOR_TRANSPARENT);
            dataY=dc.getHeight()-(data[data.size()-1-i]-minMax[0])*koefY;
            if(avgY!=null&&dataY<avgY){
                // Line over average
                dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_TRANSPARENT);
                dc.drawLine(dc.getWidth()-i,dataY,dc.getWidth()-i,avgY);
            } 
            // Line under average
            dc.setColor(Graphics.COLOR_YELLOW,Graphics.COLOR_TRANSPARENT);
            dc.drawLine(dc.getWidth()-i,dataY>avgY?dataY:avgY,dc.getWidth()-i,dc.getHeight());
            
            
            if(lastXY!=null){
                // Connector max line with preview
                dc.setColor(Graphics.COLOR_RED,Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(3);
                dc.drawLine(lastXY[0],lastXY[1],dc.getWidth()-i,dataY);
                if(lastXY[2]==1){
                    dc.setColor(Graphics.COLOR_DK_RED,Graphics.COLOR_TRANSPARENT);
                    dc.fillCircle(lastXY[0],lastXY[1],5);
                }
            }            
            
            dc.setPenWidth(1);
            lastXY=[dc.getWidth()-i,dataY,0] as Array<Numeric>;

            if(data[data.size()-1-i]==minMax[1]){
                lastXY[2]=1;
            }
        }

    }

    function toString() as String{
        return "DataStorage["+maxSize+"/"+data.size()+"]: "+data.toString();
    }
}