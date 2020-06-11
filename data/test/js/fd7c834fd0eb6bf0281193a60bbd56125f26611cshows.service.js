;( function(){

  'use strict';

  angular.module('App')

  .factory('ShowService', [ '$http', 'API', function ($http, API) {

    var endpoint = API.URL + 'api/shows/';

    // get shows
    var getShows = function(){

      return $http.get(endpoint);

    };

    // get single show
    var getShow = function(id){

      return $http.get(endpoint + id);

    };
    // make show

    var newShow = function(show){

      return $http.post(endpoint, show, API.CONFIG);

    };

    // edit show

    var editShow = function(show, id){

      return $http.put(endpoint + id, show, API.CONFIG);

    };

    // delete show
    var deleteShow = function(id){
      return $http.delete(endpoint + id, API.CONFIG);
    };


    return {

      getShows : getShows,
      getShow : getShow,
      newShow : newShow,
      editShow: editShow,
      deleteShow: deleteShow

    };
  }]);



}());
