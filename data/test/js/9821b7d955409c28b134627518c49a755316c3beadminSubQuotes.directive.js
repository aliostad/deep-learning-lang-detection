'use strict';

function AdminSubQuotes () {
  return {
    restrict: 'E',
    scope: {
      quotes: '='
    },
    template: require('../../pages/partials/adminSubQuotes.html'),
    controller: function($scope){

      // loop through quotes add edit status
      $scope.quotes.forEach(function(quote){
        if (quote.details){
          // attach show attribute
          quote.total = 0.00;
          quote.showDetails = false;
          quote.showText = "Show";
          quote.showCommentBox = false;
          quote.details.forEach(function(machine){
            machine.parts.forEach(function(part){
              if (part.price) {
                quote.total += part.price * part.quantity;
              }
            });
          });
        }
      });

      // function to show order details
      $scope.showDetails = showDetails;
      function showDetails (quote) {
        quote.showDetails = !quote.showDetails;
        if (quote.showDetails) {
          quote.showText = "Hide";
        } else {
          quote.showText = "Show";
        }
      }

      // function to display comment section
      $scope.showComments = showComments;
      function showComments (quote) {
        quote.showCommentBox = !quote.showCommentBox;
      }

    } // end of controller
  };
}

module.exports = AdminSubQuotes;
