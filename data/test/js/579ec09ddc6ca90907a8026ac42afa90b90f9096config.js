app.config(function($routeProvider){
  $routeProvider.when("/about", {
      controller:"AboutController",
      templateUrl:"views/about.html"
    }).when("/quiz/:unit", {
      controller:"QuizController",
      templateUrl:"views/quiz.html"
    }).when("/unit/:unit",{
      controller:"UnitController",
      templateUrl:"views/unit.html"
    }).when("/queries",{
      controller:"QueriesController",
      templateUrl:"views/queries.html"
    }).when("/contact",{
      controller:"ContactController",
      templateUrl:"views/contact.html"
    }).when("/news",{
      controller:"NewsController",
      templateUrl:"views/news.html"
    }).otherwise({
      controller:"MainController",
      templateUrl:"views/index.html"
    });
});