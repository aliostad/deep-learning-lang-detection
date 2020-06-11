/*global define*/
'use strict';

define([
  'db/storageService'
], function (storageService) {
  var moduleName = 'liste.service';
  angular.module(moduleName, [
    storageService
  ]).factory('listeService', function (storageService, $q) {
    'use strict';
    var service = {
      nomBase: "base",
      em: null,
      lists: [],
      initListeService: function() {
        if (service.em == null) {
          service.em = storageService.init(service.nomBase);
        }
      },
      loadListeService: function() {
        var deferred = $q.defer();
        service.initListeService();
        storageService.getAll(service.em).then(function(result) {
          service.lists = result;
          deferred.resolve();
        });
        return deferred.promise;
      }
    };
    return service;
  });

  return moduleName;
});

