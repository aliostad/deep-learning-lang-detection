app.factory('Service', ['$resource', function($resource) {
  function Service() {
    this.service = $resource('http://localhost:3000\:3000/api/:service/:id', {service: '@service', id: '@id'},
    {
          'update': { method:'PUT' }
    });
  };
  Service.prototype.all = function(service) {
    return this.service.query({service: service});
  };

  Service.prototype.delete = function(service, id) {
    return this.service.remove({service: service, id: id});
  };
  Service.prototype.create = function(service, attr) {
    attr.service = service;
    return this.service.save(attr);
  }
  Service.prototype.update = function(service, attr) {
    attr.service = service;
    return this.service.update(attr);
  }
  return new Service;
}]);