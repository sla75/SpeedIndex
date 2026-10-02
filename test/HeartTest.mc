import Toybox.Activity;
import Toybox.AntPlus;
import Toybox.Lang;
import Toybox.Test;
import LogMonkey;

class HeartTest {
    (:test)
    function getZoneTest(logger) {
        var zones=Heart.ZONE_INFO;
        logger.warning("Zones =(Array[6]) [128, 153, 179, 204, 230, 240]");
        LogMonkey.Debug.logVariable("HeartTest","Zones ",zones);
        var values=[[0,0f],[1,0f],[64,63/128f],[127,126/128f],[128,127/128f],[129,1f],[153,1+24/25f],[230,4+25/26f],[236,5.5f],[240,5+9/10f],[241,6f],[250,6f]] as Array<Array<Numeric>>;
        var zone=null;
        for(var i=0;i<values.size();i++){
            LogMonkey.Debug.logMessage("HeartTest","###### "+i+". ("+values[i][0]+") ###############");
            LogMonkey.Debug.logVariable("HeartTest","zone1",values[i][1]);
            zone=Heart.getZone(values[i][0]) as Float;
            LogMonkey.Debug.logVariable("HeartTest","zone2",zone);
            Test.assert(values[i][1]==zone);
        }
        return true;
    }
}