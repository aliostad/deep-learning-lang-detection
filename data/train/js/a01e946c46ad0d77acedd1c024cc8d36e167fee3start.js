(function(options) {
  var router = new Router(options);

  Backbone.history.start();
})({
  urls: {
    indexRoute: 'tipsController',
    createRoute: 'tipsController',
    searchRoute: 'tipsController',
    tagRoute: 'tipsController',
    commentsCreateRoute: 'commentsController',
    commentsRoute: 'commentsController'
  },
  controllers: {
    tipsController: extendControllerTips.initialize(),
    commentsController: extendControllerComments.initialize(),
    usersController: extendControllerUsers.initialize()
  }
});
