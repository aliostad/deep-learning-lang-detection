requirejs([
    'modernizr',
    'jquery',
    'menuController',
    'privateController',
    'cardController',
    'loginController',
    'PasswordController',
    'UpScrollController',
    'DeliveryPopupController'
  ],function(
    modernizr, 
    jquery, 
    menuController, 
    privateController,
    cardController,
    loginController,
    PasswordController,
    UpScrollController,
    DeliveryPopupController
  ){
  $(document).ready(function(){
    new menuController();
    new privateController();
    new cardController();
    new loginController();
    new UpScrollController();
    new PasswordController();
    new DeliveryPopupController();

  });
});