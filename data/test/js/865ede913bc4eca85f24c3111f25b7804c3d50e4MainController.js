/**
* Created by lenovo on 2014/6/9.
*/
///<reference path="ScriptController.ts"/>
var MainController = (function () {
    function MainController() {
    }
    MainController.getInstance = function () {
        if (MainController._instance == undefined) {
            MainController._instance = new MainController();
        }
        return MainController._instance;
    };

    MainController.prototype.start = function () {
        setTimeout(function () {
            ScriptController.getInstance().start();
            ScriptController.getInstance().register("GameMain");
        }, 1000);
    };

    MainController.prototype.stop = function () {
        ScriptController.getInstance().stop();
    };
    return MainController;
})();
