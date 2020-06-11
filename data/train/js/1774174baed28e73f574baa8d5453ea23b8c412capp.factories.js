/*global angular*/

(function () {
  'use strict';
  angular.module('gh.factories', [])

  .factory('PageFactory', function () {
    var page = { 
      showExpandedItem: false,
      title: 'Gareth Hughes'
    };

    return {
      newPage: function (title) {
        page.showExpandedItem = false;
        page.title = title;
      },

      setShowExpandedItem: function (showExpandedItem) {
        page.showExpandedItem = showExpandedItem;
      },

      showExpandedItem: function () {
        return page.showExpandedItem;
      },

      title: function () {
        return page.title;
      }
    };
  });
}());