requirejs([
    'modernizr',
    'jquery',
    'brandsController',
    'responceController',
    'menuController',
    'inspirationController',
    'featuredController',
    'compareController',
    'favoritesController',
    'incDecController',
    'cardController',
    'loginController',
    'PasswordController',
    'UpScrollController'
  ],function(
    modernizr, 
    jquery, 
    brandsController, 
    responceController, 
    menuController, 
    inspirationController, 
    featuredController, 
    compareController, 
    favoritesController,
    incDecController,
    cardController,
    loginController,
    PasswordController,
    UpScrollController
  ){
  $(document).ready(function(){

    
        new PasswordController();

    new brandsController();
    new responceController();
    new inspirationController();
    new menuController();
    new compareController();
    new favoritesController();
    new loginController();

    $('.inc-dec-widget').each(function(index, widget){
      new incDecController(widget);
    });
    new cardController();

    $('.featured-widget').each(function(index, widget){
      new featuredController(widget);
    });

    new UpScrollController();
  });
});