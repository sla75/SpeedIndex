import Toybox.Activity;
import Toybox.AntPlus;
import Toybox.Lang;
import Toybox.Test;
import LogMonkey;

class HeartTest {
    (:test)
    function getZoneTest(logger) {
        var zones=Heart.ZONE_INFO;
        LogMonkey.Debug.logVariable("HeartTest","Zones ",zones);
        var values=[[0,0f],[1,1/128f],[64,64/128f],[127,127/128f],[128,1f],[129,1+1/25f],[153,1.9f],[230,4f],[235,5.5f],[240,5f],[241,6f],[250,6f]] as Array<Array<Numeric>>;
        var zone=null;
        for(var i=0;i<values.size();i++){
            LogMonkey.Debug.logMessage("HeartTest","###### "+i+". "+values[i][0]+" ###############");
            LogMonkey.Debug.logVariable("HeartTest","zone1",values[i][1]);
            zone=Heart.getZone(values[i][0]) as Float;
            LogMonkey.Debug.logVariable("HeartTest","zone2",zone);
            Test.assert(values[i][1]==zone);
        }
        return true;
    }
}