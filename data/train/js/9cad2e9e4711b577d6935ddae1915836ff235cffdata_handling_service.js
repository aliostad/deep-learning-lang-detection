angular.module('MyApp')
    .service('DataHandlingService', ['mySocket','ChatService', 'CameraShareService',
        function(mySocket, ChatService, CameraShareService){

    var that = this;
    that.init = function(){
        mySocket.on('ReceiveData', function(data){
            if(data.service === "ChatService"){
                ChatService.receive(data);
            }
            if(data.service === "CameraShareService"){
                CameraShareService.receive(data);
            }
        });
    };
}]);
