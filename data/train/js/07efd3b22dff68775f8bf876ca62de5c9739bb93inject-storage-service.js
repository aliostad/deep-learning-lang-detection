export function initialize() {
  let application = arguments[1] || arguments[0];

  application.inject('service:session', 'storageService', 'storagekit/service:storage');
  application.inject('adapter', 'storageService', 'storagekit/service:storage');
  application.inject('controller', 'storageService', 'storagekit/service:storage');
  application.inject('model', 'storageService', 'storagekit/service:storage');
  application.inject('route', 'storageService', 'storagekit/service:storage');
}

export default {
  name: 'inject-storage-service',
  after: 'inject-storagekit',
  initialize: initialize
};
