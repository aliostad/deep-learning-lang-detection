define(['controller/appCtrl',
        'controller/loginCtrl',
        'controller/settingCtrl',
        'controller/aboutCtrl',
        'controller/feedbackCtrl',
        'controller/timelineCtrl',
        'controller/itemCtrl',
        'controller/postCtrl',
        'controller/contactCtrl',
        'controller/commentCtrl',
        'controller/messageCtrl',
        'controller/languageCtrl',
        'controller/archiveCtrl',
        'controller/kuhalnicaCtrl',
        'controller/kuhalnicaitemCtrl',
        'controller/recipeCtrl',
        'controller/moviesCtrl',
        'controller/moviesItemCtrl',
        'controller/signupCtrl'],function(appCtrl,loginCtrl,settingCtrl,aboutCtrl,feedbackCtrl,timelineCtrl,itemCtrl,postCtrl,contactCtrl,commentCtrl,messageCtrl,languageCtrl,archiveCtrl,kuhalnicaCtrl,kuhalnicaitemCtrl, recipeCtrl, moviesCtrl,moviesItemCtrl, signupCtrl) {

    var module = {
        module: function(name){

            var controller;

            switch (name){
                case 'appCtrl':
                    controller = appCtrl;
                    break;
                case 'loginCtrl':
                    controller = loginCtrl;
                    break;
                case 'settingCtrl':
                    controller = settingCtrl;
                    break;
                case 'aboutCtrl':
                    controller = aboutCtrl;
                    break;
                case 'feedbackCtrl':
                    controller = feedbackCtrl;
                    break;
                case 'timelineCtrl':
                    controller = timelineCtrl;
                    break;
                case 'itemCtrl':
                    controller = itemCtrl;
                    break;
                case 'postCtrl':
                    controller = postCtrl;
                    break;
                case 'contactCtrl':
                    controller = contactCtrl;
                    break;
                case 'commentCtrl':
                    controller = commentCtrl;
                    break;
                case 'messageCtrl':
                    controller = messageCtrl;
                    break;
                case 'languageCtrl':
                    controller = languageCtrl;
                    break;
                case 'archiveCtrl':
                    controller = archiveCtrl;
                    break;
                case 'kuhalnicaCtrl':
                    controller = kuhalnicaCtrl;
                    break;
                case 'kuhalnicaitemCtrl':
                    controller = kuhalnicaitemCtrl;
                    break;
                case 'recipeCtrl':
                    controller = recipeCtrl;
                    break;
                case 'moviesCtrl':
                    controller = moviesCtrl;
                    break;
                case 'moviesItemCtrl':
                    controller = moviesItemCtrl;
                    break;
                case 'signupCtrl':
                    controller = signupCtrl;
                    break;
            }

            return controller;
        }
    };

    return module;

});