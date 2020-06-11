/// <reference path="../../../lib/jquery.d.ts"/>
/// <reference path="../../../lib/box2dweb.d.ts"/>
/// <reference path="../../../lib/three.d.ts"/>
/// <reference path="../../../lib/lib.ts"/>
/// <reference path="../../../imjcart/logic/controller/value/ControllerConst.ts"/>
/// <reference path="../../../imjcart/logic/controller/event/ControllerEvent.ts"/>
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var imjcart;
(function (imjcart) {
    (function (logic) {
        (function (controller) {
            var Controller = (function (_super) {
                __extends(Controller, _super);
                function Controller() {
                    var _this = this;
                    _super.call(this);
                    Controller._instance = this;

                    //
                    $(document).keydown(function (evt) {
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_UP || evt.keyCode == controller.value.ControllerConst.KEYCODE_W) {
                            _this.startEngine({
                                value: 1
                            });
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_DOWN || evt.keyCode == controller.value.ControllerConst.KEYCODE_S) {
                            _this.startEngine({
                                value: -1
                            });
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_LEFT || evt.keyCode == controller.value.ControllerConst.KEYCODE_A) {
                            _this.setSteeringAngle({
                                //value: 0.5
                                value: 0.75
                            });
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_RIGHT || evt.keyCode == controller.value.ControllerConst.KEYCODE_D) {
                            _this.setSteeringAngle({
                                //value: -0.5
                                value: -0.75
                            });
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_SPACE) {
                            _this.changeCameraAngle();
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_SHIFT) {
                            _this.changeCameraAngle();
                        }
                    });
                    $(document).keyup(function (evt) {
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_LEFT || evt.keyCode == controller.value.ControllerConst.KEYCODE_RIGHT || evt.keyCode == controller.value.ControllerConst.KEYCODE_A || evt.keyCode == controller.value.ControllerConst.KEYCODE_D) {
                            _this.clearSteeringAngle();
                        }
                        if (evt.keyCode == controller.value.ControllerConst.KEYCODE_UP || evt.keyCode == controller.value.ControllerConst.KEYCODE_DOWN || evt.keyCode == controller.value.ControllerConst.KEYCODE_W || evt.keyCode == controller.value.ControllerConst.KEYCODE_S) {
                            _this.stopEngine();
                        }
                    });
                }
                Controller.getInstance = function () {
                    if (Controller._instance === null) {
                        Controller._instance = new Controller();
                    }
                    return Controller._instance;
                };

                Controller.prototype.startEngine = function (params) {
                    var value = params.value;

                    // エンジン開始イベント
                    this.dispatchEvent(controller.event.ControllerEvent.START_ENGINE_EVENT, { value: value });
                };

                Controller.prototype.setSteeringAngle = function (params) {
                    var value = params.value;

                    // ステアリング変更イベント
                    this.dispatchEvent(controller.event.ControllerEvent.SET_STEERING_ANGLE_EVENT, { value: value });
                };

                Controller.prototype.clearSteeringAngle = function () {
                    // ステアリングを元に戻すイベント
                    this.dispatchEvent(controller.event.ControllerEvent.CLEAR_STEERING_ANGLE_EVENT);
                };

                Controller.prototype.stopEngine = function () {
                    // エンジン停止イベント
                    this.dispatchEvent(controller.event.ControllerEvent.STOP_ENGINE_EVENT);
                };

                Controller.prototype.changeCameraAngle = function () {
                    // カメラアングル変更イベント
                    this.dispatchEvent(controller.event.ControllerEvent.CHANGE_CAMERA_ANGLE_EVENT);
                };
                Controller._instance = null;
                return Controller;
            })(lib.event.EventDispacher);
            controller.Controller = Controller;
        })(logic.controller || (logic.controller = {}));
        var controller = logic.controller;
    })(imjcart.logic || (imjcart.logic = {}));
    var logic = imjcart.logic;
})(imjcart || (imjcart = {}));
