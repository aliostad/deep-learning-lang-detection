angular.module('TechChat.controllers',[]).controller('MessageListController',function($scope,$state,popupService,$window,Message){

    $scope.messages=Message.query();

    $scope.deleteMessage=function(message){
	console.log(message);
        if(popupService.showPopup('Really delete this?')){
            message.$delete(function(){
                $window.location.href='';
            });
        }
    }

}).controller('MessageViewController',function($scope,$stateParams,Message){

    $scope.message=Message.get({id:$stateParams.id});
    console.log($scope.message);

}).controller('MessageCreateController',function($scope,$state,$stateParams,Message){

    $scope.message=new Message();

    $scope.addMessage=function(){
	console.log($scope.message);
        $scope.message.$save(function(){
            $state.go('newMessage');
        });
    }

}).controller('MessageEditController',function($scope,$state,$stateParams,Message){

    $scope.updateMessage=function(){
	console.log($scope.message);
        $scope.message[0].$update(function(){
            $state.go('getMessages');
        });
    };

    $scope.loadMessage=function(){
        $scope.message=Message.get({id:$stateParams.id});
        console.log($scope.message);
    };

    $scope.loadMessage();
});
