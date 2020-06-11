class RespondForm {

    constructor(__env,tempService,newCommentService,submitService,cookieService) {

        this.env = __env;
        this.tempService = tempService;
        this.newCommentService = newCommentService;
        this.submitService = submitService;
        this.cookieService = cookieService;

        this.restrict = 'E';
        this.templateUrl = '/modules/dialogue/stream/respondform.html';

    }

    link(scope,element,attrs) {

        var env = RespondForm.instance.env;
        var tempService = RespondForm.instance.tempService;
        var newCommentService = RespondForm.instance.newCommentService;
        var submitService = RespondForm.instance.submitService;
        var cookieService = RespondForm.instance.cookieService;

        scope.temp = tempService.temp; 
        scope.nieuwereactie = newCommentService.comment;
        scope.submitService = RespondForm.instance.submitService;
        
        scope.toggleForm = function() { newCommentService.toggle(); }; 

        scope.nieuwereactie = cookieService.get(scope.nieuwereactie); 

        scope.abonnement =  { bericht : false  }; 
        scope.abonnement.gegevens = false;

        scope.submit = function(newComment,subscription,posttype,slug,forum) { submitService.submit(newComment,subscription,posttype,slug,forum); };

    }

    static Factory(__env,tempService,newCommentService,submitService,cookieService){ 

        RespondForm.instance = new RespondForm(__env,tempService,newCommentService,submitService,cookieService);
        return RespondForm.instance; 
    }

}

RespondForm.$inject = ['__env','tempService','newCommentService','submitService','cookieService']; 

export default RespondForm; 