angular.module('application', ['ionic'])

/* CONTROLLERS */
.controller('AppController', AppController)
.controller('HomeController', HomeController)
.controller('LoginController', LoginController)
.controller('LatRecController', LatRecController)
.controller('MyRecController', MyRecController)
.controller('PlannerController', PlannerController)
.controller('ShopListController', ShopListController)

/* APP */
.run(appRun)

.config(appConfig);

/* http://ccoenraets.github.io/ionic-tutorial/create-ionic-application.html */