'use strict';

app.controller('showListCtrl', function($scope, $resource, settings) {
  $scope.tiles = [];
  $scope.predicate = 'show.id';
  $scope.showListGrid = {
    margins: [20, 20],
    columns: 12,
    draggable: {
      handle: 'h3'
    },
    resizable: {
      enabled: false
    }
  };

  $scope.setShow = function(show) {
    $scope.selectedShow = show;
  };

  $scope.createShow = function() {
    var show = {
      name: $scope.newShow
    };
    $resource(settings.get('rest.templ.show-update')).save(
      null,
      show,
      function(data) {
        $scope.selectedShow = data;
        var tile = {
          show: data,
          sizeX: 2,
          sizeY: 2
        }
        $scope.tiles.push(data);
        $scope.openAddShow = false;
        $scope.newShow = '';
      },
      function(data, status) {
        throw {
          message: 'Could not save show',
          status: status
        }
      });
  };

  function init() {
    $resource(settings.get('rest.templ.show-list')).query(
      null,
      function(data) {
        angular.forEach(data, function(show) {
          var tile = {
            show: show,
            sizeX: 2,
            sizeY: 2
          }
          $scope.tiles.push(tile);
        });
      },
      function(data, status) {
        throw {
          message: 'Could not collected tiles from server',
          status: status
        }
      });
  }

  init();
});

app.directive('showList', function() {
  return {
    templateUrl: '/directives/showList/showList.html',
    controller: 'showListCtrl',
    restrict: 'E',
    replace: true,
    transclude: true
  };

});
