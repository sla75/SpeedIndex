import Toybox.Activity;
import Toybox.AntPlus;
import Toybox.Lang;
import Toybox.Test;

class HeartTest {
    (:test)
    function getZoneTest(logger) {
        var zone=Heart.ZONE_INFO;
        logger.debug("Zones "+zone);
        logger.debug(Heart.getZone(-1));
        Test.assertEqual(Heart.getZone(-1),0f);
        logger.debug(Heart.getZone(0));
        Test.assertEqual(Heart.getZone(0),0);
        logger.debug(Heart.getZone(zone[0]-1));
        Test.assertEqual(Heart.getZone(zone[0]-1),0);
        Test.assertEqual(Heart.getZone(zone[0]),1);
        Test.assertEqual(Heart.getZone(zone[0]+1),1);
        Test.assertEqual(Heart.getZone(zone[1]),1);
        Test.assertEqual(Heart.getZone(zone[2]),2);
        Test.assertEqual(Heart.getZone(zone[3]),3);
        Test.assertEqual(Heart.getZone(zone[4]),4);
        Test.assertEqual(Heart.getZone(zone[4]+1),5);
        Test.assertEqual(Heart.getZone(zone[5]),5);
        Test.assertEqual(Heart.getZone(zone[5]+1),6);

        return true;
    }
}