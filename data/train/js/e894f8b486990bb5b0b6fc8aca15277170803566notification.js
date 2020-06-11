var serviceList = [];

function serviceBound(service) {
  serviceList.push(service);
}

function serviceFound(service) {
  service.bindService({ onBind: serviceBound });
}

function findNotificationService() {
  webinos.discovery.findServices(
    new ServiceType('http://webinos.org/api/notifications'),
    { onFound: serviceFound }
  );
}

function notify() {
  for (var s in serviceList) {
    var notification = new serviceList[s].WebNotification(
      "Hello world!", 
      { body: "Thanks, webinos" }
    );
  }
}

window.onload = findNotificationService;
