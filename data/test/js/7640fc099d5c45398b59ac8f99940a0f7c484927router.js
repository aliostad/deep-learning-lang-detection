define(["marionette"], function(Marionette){
    var Router = Marionette.AppRouter.extend({
        appRoutes: {
            "about": "showAbout",
            "discount": "showDiscount",
            "gallery": "showGallery",
            "jobs": "showJobs",
            "contacts": "showContacts",
            "main": "showMain",
            "blahNativeSpeaker": "showBlahNativeSpeaker",
            "creativeWindow": "showCreativeWindow",
            "development": "showDevelopment",
            "engAdult": "showEngAdult",
            "engChild": "showEngChild",
            "engCorp": "showEngCorp",
            "engNativeSpeaker": "showEngNativeSpeaker",
            "engSchool": "showEngSchool",
            "fastReading": "showFastReading",
            "miniSad": "showMiniSad",
            "prepSchool": "showPrepSchool",
            "psychologist": "showPsychologist",
            "": "showMain",
            "*notFound": "showMain"
        }
    });
    return Router;
});