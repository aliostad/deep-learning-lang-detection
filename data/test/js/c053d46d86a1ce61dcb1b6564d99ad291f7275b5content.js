requirejs([
    'modernizr',
    'jquery',
    'menuController',
    'loginController',
    'PasswordController',
    'UpScrollController'
  ],function(
    modernizr, 
    jquery,
    menuController,
    loginController,
    PasswordController,
    UpScrollController
  ){
    $(document).ready(function(){
      new menuController();
      new loginController();
      new UpScrollController();
      
      $('input[type=password]').each(function(index, widget){
        new PasswordController(widget);
      });
      require([
        'slideController',
        'jquery.scrollTo' 
      ], function(
        slideController
      ){
        new slideController();
      });
    });
  });