import Toybox.Activity;
import Toybox.AntPlus;
import Toybox.Lang;
import Toybox.Test;

class DataStorageGraphTest {
    (:test)
    function dataStorageAddTest(logger) {
        var ds=new DataStorageGraph(5);
        ds.add(null);
        System.println(ds);
        var minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","minmax",minmax);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax==null?true:false,true);
        //Test.assertEqual(ds.getAverage(ds.size())==null?true:false,true);
        Test.assertEqual(ds.size(),1);

        ds.add(5);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],5);
        Test.assertEqual(minmax[1],5);
        //Test.assertEqual(ds.getAverage(ds.size()),5f);
        Test.assertEqual(ds.size(),2);

        ds.add(9);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],5);
        Test.assertEqual(minmax[1],9);
        //Test.assertEqual(ds.getAverage(ds.size()),7f);
        Test.assertEqual(ds.size(),3);

        ds.add(null);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],5);
        Test.assertEqual(minmax[1],9);
        //Test.assertEqual(ds.getAverage(ds.size()),7f);
        Test.assertEqual(ds.size(),4);

        ds.add(13);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],5);
        Test.assertEqual(minmax[1],13);
        //Test.assertEqual(ds.getAverage(ds.size()),9f);
        Test.assertEqual(ds.size(),5);

        ds.add(2);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],2);
        Test.assertEqual(minmax[1],13);
        //Test.assertEqual(ds.getAverage(ds.size()),7.25f);
        Test.assertEqual(ds.size(),5);

        ds.add(4);
        System.println(ds);
        minmax=ds.getMinMax(ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","size",ds.size());
        LogMonkey.Debug.logVariable("DataStorageTest","min",minmax[0]);
        LogMonkey.Debug.logVariable("DataStorageTest","max",minmax[1]);
        //LogMonkey.Debug.logVariable("DataStorageTest","avg",ds.getAverage(ds.size()));
        Test.assertEqual(minmax[0],2);
        Test.assertEqual(minmax[1],13);
        //Test.assertEqual(ds.getAverage(ds.size()),7f);
        Test.assertEqual(ds.size(),5);
        return true;
    }
}