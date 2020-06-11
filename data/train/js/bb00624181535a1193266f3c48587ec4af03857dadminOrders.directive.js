'use strict';

function AdminOrders () {
  return {
    restrict: 'E',
    scope: {
      orders: '='
    },
    template: require('../../pages/partials/adminOrders.html'),
    controller: function($scope){

      // loop through orders add edit status
      $scope.orders.forEach(function(order){
        if (order.details){
          // attach show attribute
          order.showDetails = false;
          order.showText = "Show";
          order.showCommentBox = false;
          // order.details.forEach(function(machine){
          //   machine.parts.forEach(function(part){
          //     // do stuff for each part
          //   });
          // });
        }
      });

      // function to show order details
      $scope.showDetails = showDetails;
      function showDetails (order) {
        order.showDetails = !order.showDetails;
        if (order.showDetails) {
          order.showText = "Hide";
        } else {
          order.showText = "Show";
        }
      }

      // function to display comment section
      $scope.showComments = showComments;
      function showComments (order) {
        order.showCommentBox = !order.showCommentBox;
      }

    } //end of controller
  };
}

module.exports = AdminOrders;
