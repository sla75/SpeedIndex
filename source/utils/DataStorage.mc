import Toybox.Graphics;
import Toybox.Lang;
import LogMonkey;

class DataStorage {
    private var data as Array<Numeric>;
    private var maxSize as Number;

    function initialize(size as Number) {
        LogMonkey.Debug.logMessage("SpeedIndexView.DataStorage()",size.toString());
        self.maxSize=size;
        data=[] as Array<Numeric>;
    }
    function add(numeric as Numeric or Null) as Void {
        if(data.size()>=maxSize){
            //suma-=data[0];
            data=data.slice(1,null);
        }
        data.add(numeric);
        //suma+=numeric;
    }

    function getMinMax(size as Number) as [Numeric,Numeric] or Null{
        var mm=null;
        for(var i=data.size()-1;i>=data.size()-size;i--){
            if(i<0){
                break;
            }
            //LogMonkey.Debug.logVariable("DataStorage.getMinMax("+size+")","data["+i+"]",data[i]);
            if(data[i]==null){
                continue;
            }
            if(mm==null){
                mm=[data[i],data[i]] as [Numeric,Numeric];
                continue;
            }
            if(mm[0]>data[i]){
                mm[0]=data[i];
            } else if(mm[1]<data[i]){
                mm[1]=data[i];
            }
        }
        return mm;
    }

    function getAverage(size as Number) as Numeric or Null{
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

    function draw(dc as Dc,shiftX as Number) as Void {
        //dc.setColor(Graphics.COLOR_PINK,Graphics.COLOR_TRANSPARENT);
        //dc.drawLine(0,shiftX,dc.getWidth(),dc.getHeight());
        //dc.drawLine(dc.getWidth(),shiftX,0,dc.getHeight());

        var mm=getMinMax(dc.getWidth());
        LogMonkey.Debug.logVariable("DataStorage.draw()","mm",mm);
        if(mm==null||(mm[1]-mm[0]).toFloat()<0.1){
            return;
        }
        var k=(dc.getHeight()-shiftX)/(mm[1]-mm[0]).toFloat();
        LogMonkey.Debug.logVariable("DataStorage.draw()","k",k);
        var lastXY=null;
        for(var i=0;i<data.size();i++){
            if(data[i]==null||i>dc.getWidth()){
                continue;
            }
            if(lastXY==null){
                lastXY=[dc.getWidth()-0,dc.getHeight()-(data[data.size()-1]-mm[0])*k] as Array<Numeric>;
            }
            //LogMonkey.Debug.logMessage("DataStorage.draw()","dc.drawLine("+i+","+(dc.getHeight()-(data[i]-mm[0])*k)+","+i+","+dc.getHeight()+")");
            dc.setPenWidth(1);
            dc.setColor(Graphics.COLOR_YELLOW,Graphics.COLOR_TRANSPARENT);
            dc.drawLine(dc.getWidth()-i,dc.getHeight()-(data[data.size()-1-i]-mm[0])*k,dc.getWidth()-i,dc.getHeight());
            
            if(lastXY!=null){
                dc.setColor(Graphics.COLOR_ORANGE,Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(1);
                dc.drawLine(lastXY[0],lastXY[1],dc.getWidth()-i,dc.getHeight()-(data[data.size()-1-i]-mm[0])*k);
            }            
            if(data[data.size()-1-i]==mm[0]||data[data.size()-1-i]==mm[1]){
                dc.setColor(Graphics.COLOR_PINK,Graphics.COLOR_TRANSPARENT);
                dc.setPenWidth(3);
                dc.drawPoint(dc.getWidth()-i,dc.getHeight()-(data[data.size()-1-i]-mm[0])*k);
            }
            dc.setPenWidth(1);
            lastXY=[dc.getWidth()-i,dc.getHeight()-(data[data.size()-1-i]-mm[0])*k] as Array<Numeric>;
        }

    }

    function toString() as String{
        return "DataStorage["+maxSize+"/"+data.size()+"]: "+data.toString();
    }
}