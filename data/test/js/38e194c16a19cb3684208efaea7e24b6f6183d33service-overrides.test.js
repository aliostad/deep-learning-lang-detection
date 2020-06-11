/* global window, document, require, QUnit */
var benv = require('benv');
var Q = require('q');

QUnit.module('angular service overrides', {
  setup: function () {
    var defer = Q.defer();
    benv.setup(function () {
      defer.resolve();
    });
    return defer.promise;
  },
  teardown: function () {
    benv.teardown();
  }
});

QUnit.test('environment sanity check', function () {
  QUnit.object(window, 'window object exists');
  QUnit.object(document, 'document object exists');
});

QUnit.test('last service overrides by default', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');

  var module = angular.module('A', []);
  var ServiceA = function () {
    this.name = 'ServiceA';
  };
  var ServiceB = function () {
    this.name = 'ServiceB';
  };

  // initial definition
  module.service('someService', ServiceA);

  // first override
  module.service('someService', ServiceB);

  var someService = angular.injector(['ng', 'A']).get('someService');
  QUnit.equal(someService.name, 'ServiceB', 'someService -> second service');

  // undefined override
  module.service('someService');

  QUnit.throws(function() {
    angular.injector(['ng', 'A']).get('someService');
  }, 'Error');

  // value override
  module.value('someService', new ServiceA());
  someService = angular.injector(['ng', 'A']).get('someService');
  QUnit.equal(someService.name, 'ServiceA', 'someService -> third service');

  // factory override
  module.factory('someService', function () {
    return new ServiceB();
  });
  someService = angular.injector(['ng', 'A']).get('someService');
  QUnit.equal(someService.name, 'ServiceB', 'someService -> fourth service');

  // provider override
  module.provider('someService', function () {
    this.$get = function () {
      return new ServiceA();
    };
  });
  someService = angular.injector(['ng', 'A']).get('someService');
  QUnit.equal(someService.name, 'ServiceA', 'someService -> fifth service');
});


QUnit.test('stop angular service override', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  angular.module('A1', []).service('someService', function () {});

  QUnit.throws(function () {
    angular.module('A2', []).service('someService', function () {});
  }, 'Error');
});

QUnit.test('stop angular service (value) override', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  angular.module('A1', []).service('someService', function () {});

  QUnit.throws(function () {
    angular.module('A2', []).value('someService', {});
  }, 'Error');
});

QUnit.test('stop angular service (factory) override', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  angular.module('A1', []).service('someService', function () {});

  QUnit.throws(function () {
    angular.module('A2', []).factory('someService', function () {});
  }, 'Error');
});

QUnit.test('stop angular service (provider) override', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  angular.module('A1', []).service('someService', function () {});

  QUnit.throws(function () {
    angular.module('A2', []).provider('someService', function () {});
  }, 'Error');
});


QUnit.test('stops service overrides with undefined', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  var module = angular.module('A', []);

  module.service('someService', function () {});

  QUnit.throws(function() {
    module.service('someService');
  }, 'Error');
});


QUnit.test('default behavior is not changed for initial service definition', function () {
  var angular = benv.require('../bower_components/angular/angular.js', 'angular');
  benv.require('../stop-angular-overrides.js');

  var module = angular.module('A', []);

  function SomeService () {
    this.name = 'SomeService';
  }

  // service behavior
  module.service('someService', SomeService);
  var someService = angular.injector(['ng', 'A']).get('someService');
  QUnit.equal(someService.name, 'SomeService');

  // factory behavior
  module.factory('someFactoryService', function () {
    return new SomeService();
  });
  var someFactoryService = angular.injector(['ng', 'A']).get('someFactoryService');
  QUnit.equal(someFactoryService.name, 'SomeService');

  // value behavior
  module.value('someValueService', new SomeService());
  var someValueService = angular.injector(['ng', 'A']).get('someValueService');
  QUnit.equal(someValueService.name, 'SomeService');

  // provider behavior
  module.provider('someProviderService', function () {
    this.$get = function () {
      return new SomeService();
    };
  });
  var someProviderService = angular.injector(['ng', 'A']).get('someProviderService');
  QUnit.equal(someProviderService.name, 'SomeService');
});
