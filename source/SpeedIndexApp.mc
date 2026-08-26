import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SpeedIndexApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }
    var view=null as SpeedIndexView;
    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        view=new SpeedIndexView();
        return [ view ];
    }

    function onSettingsChanged() { // triggered by settings change in GCM
        System.println("SpeedIndexApp.onSettingsChanged()");
        view.onSettingsChanged();
        WatchUi.requestUpdate();   // update the view to reflect changes
    }

}

function getApp() as SpeedIndexApp {
    return Application.getApp() as SpeedIndexApp;
}