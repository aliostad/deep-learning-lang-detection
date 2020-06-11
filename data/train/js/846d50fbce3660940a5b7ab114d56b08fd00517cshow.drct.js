/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


angular.module('app.core').directive('showOverview', function (StoreFactory)
{
    var v =
            {"templateUrl": "components/show/show.tpl.html",
                "restict": "E",
                //these are var <-> directionality
                "scope": {"show": "=", "showRating": '=', "showDiary": '='



                },
                "controller": function ($scope)
                {
                    $scope.trackShow = function (show) {
                        StoreFactory.addShow(show);
                    };

                    $scope.unTrackShow = function (id) {
                        StoreFactory.removeShow(id);
                    };

                    $scope.hasShow = function (id) {
                        return (StoreFactory.getShow(id) !== false);
                    };
                }
            };
    return v;
});


 