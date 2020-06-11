angular
    .module('addShow',[])
        .directive('addShow', function(){

       return {
           restrict:'A',
           templateUrl:'app/shared/addShow/addShow.html',
           link: function($scope){

               $scope.addForm = function(e){

                   $scope.showToAdd={};
                   $("#eventPic").attr("src","assets/img/camera.png");
                   var modal=$(".addShow");
                   modal.modal({closable:false});
                   modal.modal('show');
               };

               $scope.closeForm = function(){

                  $scope.showToAdd={};

               };

            }
       }
    });