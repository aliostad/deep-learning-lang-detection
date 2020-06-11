angular.module('MyApp')
    .service('UserDataInitService', ['NotebookListService',
        'SelectedNotebookService' , '$auth', 'LoginDetectService', 'mySocket',
        'MeetingInfoService', 'ChatService', 'DataHandlingService',
        function(NotebookListService, SelectedNotebookService, $auth,
            LoginDetectService, mySocket, MeetingInfoService, ChatService,
            DataHandlingService){

    var that = this;

    that.init = function(){
        if(LoginDetectService.isUserLoggedin()){
            mySocket.ioconnect({forceNew: true, query: 'token=' + $auth.getToken()});

            DataHandlingService.init();
            ChatService.init();
            MeetingInfoService.init();

            NotebookListService.init();
            SelectedNotebookService.init();
            // Set flag to false
            LoginDetectService.resetLogin();
            console.log("Login token "+$auth.getToken());
        }
    };
}]);
