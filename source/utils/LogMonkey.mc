import Toybox.Lang;
import Toybox.Time;
import Toybox.System;

//! The LogMonkey barrel provides some logging utilities to aid in
//! the development and debugging of Connect IQ apps. Information
//! can be logged to a certain log level via the available log levels.
//! The supported log levels are:
//!     - Debug: General debugging messages
//!     - Warn:  Warning messages about potential issues
//!     - Error: Errors that have occurred
module LogMonkey {

    // Create some static Logger variables which act as the APIs a
    // developer uses to log information to the different log levels.
    const Debug = new Logger("Debug", System);
    const Warn  = new Logger("WARN", System);
    const Error = new Logger("ERROR", System);
    (:debug)
    class Logger {

        private var mLogLevel as String;
        private var mLogStream;

        //! Creates a new Logger object.
        //! @param logLevel [Toybox::Lang::String] The log level value to log messages through this class to
        //! @param logStream [Toybox::Lang::Object] An object which defines a println(message) function
        function initialize(logLevel as String, logStream) {
            mLogLevel = logLevel;
            mLogStream = logStream;
        }

        // The string formats to use when printing log messages
        private static var FORMAT_VARIABLE = "$1$=($2$) $3$" as String;
        private static var FORMAT_VARIABLE_NULL = "$1$= <null>" as String;
        private static var FORMAT_LOG_MESSAGE = "$1$ [$2$] $3$: $4$" as String;
        private static var FORMAT_TIMESTAMP = "$1$:$2$:$3$" as String; // HH:MM:SS

        //! Forms a log message based on the given values.
        //! @param tag [Toybox::Lang::String] The tag to apply to the log message
        //! @param message [Toybox::Lang::String] The message to log
        //! @return [Toybox::Lang::String] A log message matching the format specified by FORMAT_TIMESTAMP
        private function formLogMessage(tag as String, message as String) as String {
            // Get a timestamp from the system
            var currentTime = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var timestamp = Lang.format(FORMAT_TIMESTAMP, [
                currentTime.hour.format("%02u"),
                currentTime.min.format("%02u"),
                currentTime.sec.format("%02u")
            ]);

            // Form the log message
            return Lang.format(FORMAT_LOG_MESSAGE, [timestamp, mLogLevel, tag, message]);
        }

        //! Handles the printing of a log message to the log file
        //! @param tag [Toybox::Lang::String] The tag to apply to the log message
        //! @param message [Toybox::Lang::String] The message to log
        private function log(tag as String, message as String) as Void {
            // Print the log message
            mLogStream.println(formLogMessage(tag, message));
        }

        //! Returns the type string of the given variable. Note, this function
        //! will currently only return names within the Toybox.Lang module. If the
        //! given variable isn't a type defined there then "Object" will be returned.
        //! @param variable [Toybox::Lang::Object] The variable to get the type of
        //! @return [Toybox::Lang::String] The name of the type of the given variable
        private function getVariableType(variable) as String {
            // If the given value is null we can't switch on it so perform
            // a null check here. The return value should just be "null".
            if (variable == null) {
                return "empty";
            }

            // Switch on the type of the variable and return the variable's
            // class name accordingly.
            switch (variable) {
                case instanceof Lang.Array:
                    return "Array["+variable.size()+"]";
                case instanceof Lang.Boolean:
                    return "Boolean";
                case instanceof Lang.Char:
                    return "Char";
                case instanceof Lang.Dictionary:
                    return "Dictionary";
                case instanceof Lang.Double:
                    return "Double";
                case instanceof Lang.Exception:
                    return "Exception";
                case instanceof Lang.Float:
                    return "Float";
                case instanceof Lang.Long:
                    return "Long";
                case instanceof Lang.Method:
                    return "Method";
                case instanceof Lang.Number:
                    return "Number";
                case instanceof Lang.String:
                    return "String";
                case instanceof Lang.Symbol:
                    return "Symbol";
                case instanceof Lang.WeakReference:
                    return "WeakReference";
                default:
                    return "Object";
            }
        }

        //! Log the given message under the given tag
        //! @param tag [Toybox::Lang::String] The tag to apply to the log message
        //! @param message [Toybox::Lang::String] The message to log
        function logMessage(tag as String, message as String) as Void {
            log(tag, message);
        }

        //! Log the given Exception under the given tag
        //! @param tag [Toybox::Lang::String] The tag to apply to the log message
        //! @param exception [Toybox::Lang::Exception] The Exception to log
        function logException(tag as String, exception as Exception) as Void {
            log(tag, exception.getErrorMessage());
            exception.printStackTrace();
            //TODO: Iteratre through stacktrace.
        }

        //! Log the given variable's information under the given tag
        //! @param tag [Toybox::Lang::String] The tag to apply to the log message
        //! @param variableName [Toybox::Lang::String] The name of the variable being logged
        //! @param variable [Toybox::Lang::Object] The variable to log
        function logVariable(tag, variableName, variable) as Void {
            if (variable == null) {
                log(tag, Lang.format(FORMAT_VARIABLE_NULL, [variableName]));
            } else {
                log(tag, Lang.format(FORMAT_VARIABLE, [variableName, getVariableType(variable), variable.toString()]));
            }
        }

    }
    (:release)
    class Logger {

        function initialize(logLevel as String, logStream) {
        }

        function logMessage(tag as String, message as String) as Void {
        }

        function logException(tag as String, exception as Exception) as Void {
        }

        function logVariable(tag, variableName, variable) as Void {
        }

    }
}