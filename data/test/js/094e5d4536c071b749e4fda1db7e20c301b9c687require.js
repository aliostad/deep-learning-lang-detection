function wireService(serviceDefinition) {
  require(serviceDefinition.getSource());
  log.info("just required " + serviceDefinition.getSource());
  var constructor = topLevelScope()[serviceDefinition.name];
  var serviceInstance = new constructor();
  log.info("just constructed " + serviceDefinition.name);
  var properties = serviceDefinition.properties;
  log.info("configuring properties " + properties);
  if(properties) {
    var entries = properties.entrySet().iterator();
    while(entries.hasNext()) {
      var entry = entries.next();
      if(entry.value instanceof org.bpmscript.js.IJavascriptService) {
        serviceInstance[entry.key] = wireService(entry.value);
      } else {
        serviceInstance[entry.key] = entry.value;
      }
    }
  }
  return serviceInstance;
}

function makeItHappen() {
  var serviceInstance = wireService(service);
  serviceInstance.test();
}

makeItHappen();
