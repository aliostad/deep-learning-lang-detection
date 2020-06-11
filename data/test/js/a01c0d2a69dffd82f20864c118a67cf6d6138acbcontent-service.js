'use strict';

/**
 * @ngdoc function
 * @name gitSearchWivoApp.endpoint:ContentService
 * @description
 * # ContentService
 * Controller of the gitSearchWivoApp to retrieve information from own conexion web service
 */

angular
.module('gitSearchWivoApp.endpoints')
.factory('ContentService', ContentService);
ContentService.$injector = ['UrlService', 'ConnectionService'];

function ContentService(UrlService, ConnectionService) {
  var service = {};
  service.getFavorites = getFavorites;
  service.getLanguages = getLanguages;
  service.isFavorite = isFavorite;
  service.addFavorite = addFavorite;
  service.removeFavorite = removeFavorite;

  function getLanguages(){
      return ConnectionService.get(UrlService.getLanguages(),{});
  }

  function getFavorites(page, pageSize){
    return ConnectionService.get(UrlService.getFavorites(page, pageSize), {});
  }

  function isFavorite(login){
    return ConnectionService.get(UrlService.isFavorite(login),{});
  }

  function addFavorite(jsonTosend){
  //  console.log(JSON.stringify(jsonTosend));
    return ConnectionService.post(UrlService.addFavorite(), {}, jsonTosend);
  }

  function removeFavorite(login){
    return ConnectionService.post(UrlService.removeFavorite(login),{},{});
  }

  return service;
}
