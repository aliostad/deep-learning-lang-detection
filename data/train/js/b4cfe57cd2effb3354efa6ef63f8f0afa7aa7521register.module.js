import sharedService from '../shared/shared.service.js'

import registerService from './register.service.js'
import registerComponent from './register.component.js'
import registerRoutes from './register.routes.js'

export default
  angular
    .module('flight.register', [])
    .service('sharedService', sharedService)
    .service('registerService', registerService)
    .component('registerComponent', registerComponent)
    .config(['$stateProvider', '$urlRouterProvider', registerRoutes])
    .name
