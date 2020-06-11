var app = angular.module('ProductSearch',[]);
app.controller('SearchController', function($http, $location) {
  var controller = this;
  controller.query = $location.search().search;
  controller.zipcode = $location.search().zipcode || '95073';
  controller.isRunning = false;

  controller.submit = function() {
    $location.search('search',controller.query);
    $location.search('zipcode',controller.zipcode);

    controller.isRunning= true;

    $http.get('/api/search.json', {
      params: {
        search: controller.query,
        zipcode: controller.zipcode
      }

    }).success(function(data){
      controller.searchResults = data;
      controller.isRunning = false;

    }).error(function(data){
      alert("Something went wrong!");
      controller.isRunning = false;
    });
  }

  if (controller.query && controller.zipcode) {
    controller.submit();
  }

});
