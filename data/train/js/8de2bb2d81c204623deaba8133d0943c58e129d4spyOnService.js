'use strict';

window.spyOnService = (function() {
  return function spyOnService(service_name) {
    var _service;
    angular.mock.inject([ service_name, function(service) {
      _service = service;
      R.pipe(R.functions,
             R.reject(R.match(/\$$/)),
             R.forEach(function(k) {
               var arity = service[k].length;
               spyOn(service, k).and.callFake(function() {
                 return service[k]._retVal;
               });
               service[k]._retVal = service_name+'.'+k+'.returnValue';
               service[k+'$'] = R.curryN(arity, service[k]);
             })
            )(service);
    }]);
    return _service;
  };
})();
