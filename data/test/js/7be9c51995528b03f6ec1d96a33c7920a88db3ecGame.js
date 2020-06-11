var PS = PS || {};
PS.Prelude = (function () {
    "use strict";
    function Show(show) {
        this.show = show;
    };
    function showStringImpl(s) {  return JSON.stringify(s);};
    var showString = function (_) {
        return new Show(showStringImpl);
    };
    var show = function (dict) {
        return dict.show;
    };
    return {
        Show: Show, 
        show: show, 
        showString: showString
    };
})();
var PS = PS || {};
PS.Debug_Trace = (function () {
    "use strict";
    var Prelude = PS.Prelude;
    function trace(s) {  return function() {    console.log(s);    return {};  };};
    var print = function (__dict_Show_55) {
        return function (o) {
            return trace(Prelude.show(__dict_Show_55)(o));
        };
    };
    return {
        print: print, 
        trace: trace
    };
})();
var PS = PS || {};
PS.Game = (function () {
    "use strict";
    var Prelude = PS.Prelude;
    var Debug_Trace = PS.Debug_Trace;
    var main = Debug_Trace.print(Prelude.showString({}))("Hello, World");
    return {
        main: main
    };
})();
PS.Game.main();