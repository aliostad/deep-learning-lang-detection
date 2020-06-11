define(["route1-controller",
  "route2-controller",
  "navigation-controller",
  "nested-controller"
], function (route1Ctrl, route2Ctrl, navigationCtrl, nestedCtrl) {
    var init = function (app) {
      app.controller('route1Controller', ['$scope', 'service1', '$q', route1Ctrl]);
      app.controller('route2Controller', ['$scope', '$location', '$q', 'service2', route2Ctrl]);
      app.controller('navigationController', ['$scope', '$location', navigationCtrl]);
      app.controller('nestedController', ['$scope', '$q', 'service2', nestedCtrl]);
  };
  return {init: init};
});
