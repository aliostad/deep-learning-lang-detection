define([
  '../app-controllers',

  './root/ArticleController',
  './root/RootController',
  './root/SectionController',
  './root/NavigationController',

  './admin/EditorController',
  './admin/LandingController',
  './admin/ManagerController',
  './admin/Manager2Controller',
  './admin/NavigationAdminController',
  './admin/NavAdminDetailCtrl',
  './admin/UserAdminController',
  './admin/LandingImage',

  './user/UserController',
  './user/ProfileController',
  './user/ACtrl',

  './PartialSectionController'

], function (controllers) {
  return controllers;
});
