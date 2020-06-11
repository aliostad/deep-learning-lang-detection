(function () {
  'use strict';

  /**
   * @ngdoc service
   * @name home.factory:ContentService
   *
   * @description
   *
   */
  angular
    .module('home')
    .factory('ContentService', ContentService);

  function ContentService(ConstantService) {
    var ContentServiceBase = {

      getContent: function (obj, lang) {
        return ConstantService.getObj(obj, 'cart.' + lang + '.content');
      },
      getErrorMessages: function (obj, lang) {
        return ConstantService.getObj(obj, 'cart.' + lang + '.errorMessages');
      }

    };

    return ContentServiceBase;
  }
}());
