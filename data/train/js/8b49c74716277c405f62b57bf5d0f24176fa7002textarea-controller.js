/**
 @file textarea-controller.js
 @controller TextareaController
 @description
 The following controller will be used to manage textarea
 @author skhajan
 @date 8/5/2015
 */
"use strict";

define([
    "angular",
    "bingo/scripts/commons/controllers/base-widget-controller"
], function (angular, BaseWidgetController) {
    var controllerModule = angular.module("bingo.widgets.html5.textarea-controller", []);
    controllerModule.controller("TextAreaController", TextAreaController);
    TextAreaController.$inject = ["$scope", "$attrs", "$element"];
    function TextAreaController($scope, $attrs, $element) {
        var vm = this;
        TextAreaController.super.apply(vm, arguments);
    }

    TextAreaController.prototype = {

    };
    return BaseWidgetController.prototype.successor(TextAreaController);
});