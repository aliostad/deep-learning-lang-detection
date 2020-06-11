Polymer({
  service: null,

  deviceChanged: function() {
    var self = this;
    self.service = undefined;
    self.servicePromise = undefined;
    if (!self.device) {
      return;
    }
    var servicePromise = self.servicePromise =
      self.device.getService(navigator.bluetooth.uuids.canonicalUUID(0x180A))
        .then(function(service) { return service ? new DeviceInfoService(service) : null});

    servicePromise.then(function(service) {
      if (servicePromise !== self.servicePromise) {
        // Prevent races.
        return;
      }
      self.service = service;
    }).catch(window.onerror);
  },

  close: function() {
    this.fire('close');
  }
});
