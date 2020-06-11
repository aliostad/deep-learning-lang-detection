//########################################################################
//###################START NavItems#######################################
app.factory('NavItems', ['$http', function($http){
  var Url    = "partials/json_files/nav_items.json";
  var NavItems = $http.get(Url).then(function(response){
     return response.data;
  });
  return NavItems;
}]);
//###################END NavItems#########################################
//########################################################################
