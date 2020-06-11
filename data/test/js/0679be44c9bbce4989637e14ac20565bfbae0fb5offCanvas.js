angular.module('services.offCanvas', [])

    //.factory('offCanvas', ['cnOffCanvas',function(cnOffCanvas) {
    //  return cnOffCanvas({
    //    controller: 'navCtrl',
    //    controllerAs: 'nav',
    //    template: '<nav class="off-canvas__nav" ng-swipe-left="nav.toggle()">the nav</nav>'
    //  })
      .factory('offCanvas', ['cnOffCanvas',function(cnOffCanvas) {
        return cnOffCanvas({
          controller: 'HomeCtrl',
          controllerAs: 'nav',
          template: '<nav class="off-canvas__nav" ng-swipe-left="nav.toggle()">the nav</nav>'
        })
}]);