function ShowCtrl($scope, $routeParams, Restangular, testFactory, items) {
  getData($routeParams.show_id);
  function getData(showid) {
    testFactory.getShow(showid).then(function(show) {
      angular.forEach(show.files, function(file, key0){
        show.files[key0].url = 'http://archive.org/download/' + show.identifier + '/' + file.file_name;
        show.files[key0].artist = show.creator;
        show.files[key0].id = show.identifier + '-' + file.track;          
        });
      $scope.show = show        
    });                
    console.log($scope);
  }
};

angular
  .module('teakwoodApp.components.show', [])

  .config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/show/:show_id', {
      templateUrl: 'frontend/static/app/components/show/show.html',
      controller: 'ShowCtrl',
      controllerAs: 'show'
    });
  }])

  .controller('ShowCtrl', ['$scope', '$routeParams', 'Restangular', 'getApi', ShowCtrl]);