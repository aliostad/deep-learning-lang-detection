import config from './index.config';
import routerConfig from './index.route';
import runBlock from './index.run';
/// Controllers
import MainController from './components/main/main.controller';
import HomeController from './components/home/home.controller';
import AboutController from './components/about/about.controller';
import ServicesController from './components/services/services.controller';
import ProductsController from './components/products/products.controller';
import ViewProductController from './components/products/view/viewProduct.controller';
import LoginController from './components/login/login.controller';
/// Services
import ProductsService from './components/core/data/products.service';
import EmailService from './components/core/email/email.service';

import SideNavController from './components/sidenav/sidenav.controller';
import ToolbarController from './components/core/toolbar/toolbar.controller';

import AnchorSmoothScrollService from './components/core/helpers/AnchorSmoothScroll.service';

// Init angular
angular
  .module('enw', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngSanitize',
    'ui.router',
    'ngMaterial',
    'ngMessages',
    'angular-flexslider',
    'satellizer',
    'textAngular'
  ])
  .config(config)
  .config(routerConfig)
  .run(runBlock)
  .constant('API', {
    url: 'http://api.essentialnordicwalking.com.au/api'
  })

  .controller('MainController', MainController)
  .controller('HomeController', HomeController)
  .controller('AboutController', AboutController)
  .controller('ServicesController', ServicesController)
  .controller('ProductsController', ProductsController)
  .controller('ViewProductController', ViewProductController)
  .controller('LoginController', LoginController)
  .controller('SideNavController',SideNavController)
  .controller('ToolbarController', ToolbarController)

  .service('ProductsService', ProductsService)
  .service('EmailService', EmailService)

  .service('AnchorSmoothScrollService', AnchorSmoothScrollService)
  ;
