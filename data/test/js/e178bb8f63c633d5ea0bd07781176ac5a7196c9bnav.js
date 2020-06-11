angular.module('navList', [])

.controller('navCtrl', function($scope, $location, User, Breadcrumb) {
  $scope.navClass = function(href) {
    return href === '#' + $location.path() ? 'active' : '';
  };

  $scope.nav = [{
    url: '#/about',
    title: 'About'
  }, {
    url: '#/pricing',
    title: 'Pricing'
  }]

  $scope.breadcrumbs = function() {
    return Breadcrumb.get()
  }

  $scope.navView = function() {
    if(User.get().id) return 'views/nav/nav-user.html'
    return 'views/nav/nav-guest.html'
  }

  $scope.user = function() {
    return User.get()
  }
  
});
