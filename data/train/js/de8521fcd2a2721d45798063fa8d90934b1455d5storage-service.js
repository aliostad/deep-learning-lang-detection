pytx.service("StorageService", function () {
  var StorageService = this;
  
  try {
    localStorage.dgrok = 'awesome';
    StorageService.backend = localStorage;
  }
  
  catch (e) {
    StorageService.backend = {};
  }
  
  StorageService.get = function (key) {
    return StorageService.backend[key];
  };
  
  StorageService.set = function (key, value) {
    StorageService.backend[key] = value;
  };
  
  StorageService.remove = function (key) {
    delete StorageService.backend[key];
  };
  
  return StorageService;
});
