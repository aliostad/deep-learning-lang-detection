(function() {
  'use strict';
function ShowController($scope, $stateParams, $state, $controller, Restangular, testFactory, items) {
   angular.extend(this, $controller('DefaultController', {$scope: $scope, $stateParams: $stateParams, $state: $state}));

  getData($stateParams.show_id);
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
  .module('application.components.show', [])
  .controller('ShowController', ['$scope', '$stateParams', '$state', '$controller', 'Restangular', 'getApi', ShowController]);

})();  