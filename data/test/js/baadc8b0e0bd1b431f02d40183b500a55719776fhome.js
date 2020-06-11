requirejs([
    'modernizr',
    'requestAnimationFramePolyfill',
    'jquery',
    'specialController',
    'featuredController',
    'menuController',
    'brandsController',
    'favoritesController',
    'incDecController',
    'cardController',
    'loginController',
    'PasswordController',
    'UpScrollController'
  ],function(
    modernizr, 
    requestAnimationFramePolyfill, 
    jquery, 
    specialController, 
    featuredController, 
    menuController, 
    brandsController, 
    favoritesController,
    incDecController,
    cardController,
    loginController,
    PasswordController,
    UpScrollController
  ){
  
  $(document).ready(function(){
    new specialController();
    new brandsController();
    new menuController();
    new favoritesController();
    new loginController();
    new UpScrollController();

    $('.inc-dec-widget').each(function(index, widget){
      new incDecController(widget);
    });
    new cardController();

    $('.featured-widget').each(function(index, widget){
      new featuredController(widget);
    });

    
        new PasswordController();

  });

});