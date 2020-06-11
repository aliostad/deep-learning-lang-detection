angular
    .module('BtCurrentMonitorApp')
    .factory('currentMonitorService', currentMonitorService);

function currentMonitorService(mqttService, captureService) {
    var service = {};

    service.start = function() {
        captureService.clear();
        mqttService.publish('/bt/multimeter/command', 'start');
    };

    service.stop = function() {
        mqttService.publish('/bt/multimeter/command', 'stop');    
    };

    service.state = function() {
        return captureService.state;    
    };

    return service; 
}