requirejs([
    'modernizr',
    'jquery',
    'menuController',
    'brandsController',
    'brandPageController',
    'cardController',
    'loginController',
    'PasswordController',
    'UpScrollController'
  ],function(
    modernizr, 
    jquery, 
    menuController, 
    brandsController,
    brandPageController,
    cardController,
    loginController,
    PasswordController,
    UpScrollController
  ){
  $(document).ready(function(){
    new menuController();
    new brandsController();
    new brandPageController();
    new cardController();
    new loginController();
    new UpScrollController();
    new PasswordController();
  });
});