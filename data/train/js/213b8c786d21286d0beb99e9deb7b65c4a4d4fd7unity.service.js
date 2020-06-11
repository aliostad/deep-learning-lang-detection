'use strict';

angular.module('komanaiApp')
  .service('unity', function () {
    // AngularJS will instantiate a singleton by calling "new" on this function
    var service = {};
    service.u = new UnityObject2();
    service.currentPos = {};

    // TODO: does not belong here
    service.visibleImage = undefined;

    service.moveToPosition = function(x,y,z) {
      service.currentPos = {x:x, y:y, z:z}
      service.u.getUnity().SendMessage("MainCamera", "MoveToPosition", service.currentPos.x + "," + service.currentPos.y + "," + service.currentPos.z);
    }
    service.toStreetLevel = function() {
      service.currentPos.y = 0.05
      console.log(service.currentPos);
      service.u.getUnity().SendMessage("MainCamera", "MoveToPosition", service.currentPos.x + "," + service.currentPos.y + "," + service.currentPos.z);
    }
    service.to50mLevel = function() {
      console.log("click");
      service.currentPos.y = 1
      service.u.getUnity().SendMessage("MainCamera", "MoveToPosition", service.currentPos.x + "," + service.currentPos.y + "," + service.currentPos.z);
    }
    service.focusOnFireworks = function(num) {
      console.log("HOO", num);
      service.u.getUnity().SendMessage("MainCamera", "FocusOnFirework", num);
    }
    return service;
  });
