Router.configure({
  controller: 'appController',
  layoutTemplate: 'layout',
  loadingTemplate : 'loading'
});

Router.route('/', {
  name: 'dashboard',
  controller: 'dashboardController'
});

Router.route('/users', {
  name: 'users',
  controller: 'usersController'
});

Router.route('/login', {
  name: 'login',
  controller: 'loginController'
});

Router.route('/bahan',{
  name: 'bahan',
  controller : 'bahanController'
});

Router.route('produksi',{
  name : 'produksi',
  controller : 'produksiController'
});

Router.route('request', {
  name : 'request',
  controller : 'requestController'
});

Router.route('order', {
  name : 'order',
  controller : 'orderController'
});

Router.route('suppliers', {
  name : 'suppliers',
  controller : 'suppliersController'
});

Router.route('export', {
  name : 'export',
  controller : 'exportController'
});
