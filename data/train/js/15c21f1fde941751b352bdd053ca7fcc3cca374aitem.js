requirejs([
  'modernizr',
  'jquery',
  'menuController',
  'featuredController',
  'lineController',
  'tabsController',
  'compareController',
  'favoritesController',
  'itemController',
  'fullViewController',
  'catalogueController',
  'faqController',
  'cardController',
  'incDecController',
  'loginController',
  'controlsController',
  'PasswordController',
  'UpScrollController'
],function(
  modernizr, 
  jquery, 
  menuController, 
  featuredController, 
  lineController, 
  tabsController, 
  compareController, 
  favoritesController, 
  itemController, 
  fullViewController, 
  catalogueController, 
  faqController,
  cardController,
  incDecController,
  loginController,
  controlsController,
  PasswordController,
  UpScrollController
){
  $(document).ready(function(){
    new controlsController();
    new menuController();
    $('.featured-widget').each(function(index, widget){
      new featuredController(widget);
    });
    $('.inc-dec-widget').each(function(index, widget){
      new incDecController(widget);
    });
    new cardController();
    $('.catalogue-widget').each(function(index, widget){
      new catalogueController(widget);
    });

    new PasswordController();
    new UpScrollController();
    new lineController();
    new tabsController();
    new compareController();
    new favoritesController();
    new itemController();
    new fullViewController();
    new faqController();
    new loginController();
  });
});