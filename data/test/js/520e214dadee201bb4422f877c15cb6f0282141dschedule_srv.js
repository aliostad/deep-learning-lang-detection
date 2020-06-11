'use strict';

angular.module('myApp.schedule')

.factory('ScheduleService', ['$firebase' , 'AppConfig', function($firebase, AppConfig) {
  var service = {};

  // Rooms Firebase
  service.roomsRef = new Firebase(AppConfig.fire_roomsurl);
  service.roomsSync = $firebase(service.roomsRef);
  service.rooms = service.roomsSync.$asArray();

  // Reserves Firebase
  service.reservesRef = new Firebase(AppConfig.fire_reservesurl);
  service.reservesSync = $firebase(service.reservesRef);
  service.reserves = service.reservesSync.$asArray();

  return service;
}]);