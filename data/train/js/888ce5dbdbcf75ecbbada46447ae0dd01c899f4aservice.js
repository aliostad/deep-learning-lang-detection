/**
 * Created by arxxbx on 11/15/2014.
 */
var serviceModule=angular.module('app.serviceModule',[]);
serviceModule.service('MathService', function(){
    this.add = function(a,b) {
        return a+b;
    }
    this.substract=function(a,b) {
        return a-b;
    }
    this.multiply = function(a,b) {
        return a * b;
    }
    this.divide = function(a,b) {
        return a / b;
    }
});
serviceModule.service('CalculatorService',function(MathService) {
    this.square = function(a) {
        return MathService.multiply(a,a);
    }
    this.cube=function(a) {
        return MathService.multiply(a,MathService.multiply(a,a))
    }
});
