requirejs([
    'modernizr',
    'jquery',
    'menuController',
    'inspirationController',
    'featuredController',
    'catalogueController',
    'controlsController',
    'managerController',
    'compareController',
    'favoritesController',
    'incDecController',
    'cardController',
    'lineController',
    'orderController',
    'loginController',
    'PasswordController',
    'UpScrollController',
    'TogglerController',
    'FastController'
  ],function(
    modernizr, 
    jquery, 
    menuController, 
    inspirationController, 
    featuredController, 
    catalogueController, 
    controlsController, 
    managerController, 
    compareController, 
    favoritesController,
    incDecController,
    cardController,
    lineController,
    orderController,
    loginController,
    PasswordController,
    UpScrollController,
    TogglerController,
    FastController
  ){
  $(document).ready(function(){
    new inspirationController();
    new menuController();
    new loginController();

    $('.inc-dec-widget').each(function(index, widget){
      new incDecController(widget);
    });
    new cardController();
    
    $('.catalogue-widget').each(function(index, widget){
      new catalogueController(widget);
    });

    new FastController();
    
    new lineController();
    new controlsController();
    new managerController();
    new compareController();
    new favoritesController();
    
    $('.featured-widget').each(function(index, widget){
      new featuredController(widget);
    });

    $('.filter-toggler').each(function(index, widget){
      new TogglerController(widget);
    });


    new PasswordController();

    new orderController();
    new UpScrollController();
  });
});