factoryModule.factory('DeviceService', function () {
    var DeviceService = {};
    DeviceService.devices = [];
    DeviceService.currentDevice = {};

    DeviceService.getDevice = function (index) {
        return DeviceService.devices[index];
    }

    DeviceService.addDevice = function (item) {
        DeviceService.devices.push(item);
    }

    DeviceService.removeItem = function (item) {
        DeviceService.devices.splice(DeviceService.devices.indexOf(item), 1)
    }

    DeviceService.size = function () {
        return DeviceService.devices.length;
    }

    DeviceService.clear = function () {
        DeviceService.devices = [];
    }

    DeviceService.getDevices = function () {
        return DeviceService.devices;
    }

    DeviceService.setCurrentDevice = function (device) {
        DeviceService.currentDevice = device;
    }

    DeviceService.getCurrentDevice = function () {
        return DeviceService.currentDevice;
    }

    DeviceService.closeConnections = function () {

        for (var i = 0; i < DeviceService.devices.length; i++) {
            console.log("DeviceService :: closeConnections - Close connection for device " + DeviceService.devices[i].name);
            DeviceService.devices[i].close();
        }
    }

    return DeviceService;

});