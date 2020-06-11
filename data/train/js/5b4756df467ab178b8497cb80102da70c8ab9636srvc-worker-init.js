nracer.service("WorkerService", function (NotifService) {
  var WorkerService = this;
  
  WorkerService.chrome_app = false;
  
  WorkerService.init_worker = function (scope) {
    if (window.chrome && window.chrome.runtime && window.chrome.runtime.getManifest) {
      WorkerService.chrome_app = true;
    }
    
    if ('serviceWorker' in navigator && !WorkerService.chrome_app) {
      navigator.serviceWorker.register('/service-worker.js')
      
      .then(function (registration) {
        console.log('ServiceWorker Success: ',    registration.scope);
        
        scope.$apply(function () {
          NotifService.data.registration = registration;
          //NotifService.data.available = true;
          //NotifService.get_subscription(scope);
        });
      })
      
      .catch (function(err) {
        console.log('ServiceWorker registration failed: ', err);
      });
    }
  };
  
  return WorkerService;
});
