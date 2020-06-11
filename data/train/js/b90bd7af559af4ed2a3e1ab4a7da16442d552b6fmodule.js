/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var serviceModule = angular.module('serviceModule',['ui.bootstrap']);

serviceModule.factory('serviceService', ['$http','$rootScope','$location','APIURL',function($http,$rootScope,$location,APIURL) { 
  return new ServiceService($http, $rootScope, $location,APIURL); 
}]);  

serviceModule.controller('serviceController', ['$scope','serviceService','commonToolService',serviceController]); 
serviceModule.controller('serviceDisplayController', ['$scope','serviceService','customerService','$routeParams','$modal',serviceDisplayController]);

