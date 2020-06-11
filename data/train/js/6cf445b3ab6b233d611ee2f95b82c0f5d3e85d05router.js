//Thanks!
//http://lostechies.com/derickbailey/2012/01/02/reducing-backbone-routers-to-nothing-more-than-configuration/
Website.AppRouter = Website.BaseRouter.extend({
  appRoutes: {
    'login':'showLogin',
    'logout':'showLogout',
    'tests':'showTests',
    'review':'showReview',
    'createPage':'showCreatePage',
    'page/:name/edit':'showEditPage',
    'page/:name/addMedia':'showAddMedia',
    'page/:pageName/:type/:mediaId':'showMedia',
    'media/:type/:id/edit':'showEditMedia',
    'page/:name':'showPage',
    '':'showIndex'
  }
});