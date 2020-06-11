define([], function() {

    var Router = Backbone.Marionette.AppRouter.extend({

        appRoutes: {
            "home": "showHomeView",
            "search/:term": "showSearchView",
            "profile": "showProfileView",
            "profile/:id": "showProfileView",
            "post": "showPostView",
            "post/:id": "showPostView",
            "group": "showGroupView",
            "group/:id": "showGroupView",
            "people": "showPeopleView",
            "bookmark": "showBookmarkView",
            "calendar": "showCalendarView",
            "notification": "showNotificationView",
            "activity": "showActivityView",
            "mailbox": "showMailBoxView",
            "tag": "showSkillsView",
            "solr": "showSolrView",
            "announcement": "showAnnouncementView"
        }
    });

    return Router;
});