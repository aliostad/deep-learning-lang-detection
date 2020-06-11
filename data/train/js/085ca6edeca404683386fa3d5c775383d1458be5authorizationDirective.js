class Authorization { 

    constructor(lightBoxService,accountService,newCommentService,stateService) {

        this.lightBoxService = lightBoxService;
        this.accountService = accountService;
        this.newCommentService = newCommentService;
        this.stateService = stateService; 

        this.restrict = 'E';
        this.templateUrl = '/modules/account/authorization.html?v=3';
    }

    link(scope,element,attrs) {

        var lightBoxService = Authorization.instance.lightBoxService;
        var accountService = Authorization.instance.accountService;
        var newCommentService = Authorization.instance.newCommentService; 
        var stateService = Authorization.instance.stateService;

        scope.authorization = false; 
        scope.accountService = accountService;
        scope.context = lightBoxService.data.context; 
        scope.newComment = newCommentService.comment;

        accountService.email_exists(newCommentService.comment.email);

        if(stateService.data.state.name === 'mijnstation') { 

            scope.authorization = true; 
        }

        scope.enter = function() { 

            scope.authorization = true; 
        };

        scope.close = function() { 

            lightBoxService.close();

        };
    }

    static Factory(lightBoxService,accountService,newCommentService,stateService) { 
        Authorization.instance = new Authorization(lightBoxService,accountService,newCommentService,stateService); 
        return Authorization.instance;
    }
}

Authorization.$inject = ['lightBoxService','accountService','newCommentService','stateService']; 

export default Authorization;