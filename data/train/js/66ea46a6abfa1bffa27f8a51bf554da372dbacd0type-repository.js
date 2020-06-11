app.factory('typeRepository', ['guidGenerator', 'localStorageService', function(guidGenerator, localStorageService){
  var service = {
    list: [],

    save: function(item){
      var index = service.list.indexOf(item);
      if(index < 0 ){
        service.list.push(item);
      }else{
        service.list.splice(index, 1, item);
      }

      localStorageService.set('types', service.list);
    },

    delete: function(item){
      var index = service.list.indexOf(item);
      service.list.splice(index, 1);

      localStorageService.set('types', service.list);
    }
  };

  service.list = localStorageService.get('types');
  if(service.list == null)
    service.list = [];

  return service;
}])
