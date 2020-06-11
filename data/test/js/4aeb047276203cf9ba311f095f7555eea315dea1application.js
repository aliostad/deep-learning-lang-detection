window.app = angular.module('myApp', ['ngRoute'])
    .service('tokenService', lunch.TokenService)
    // web services
    .service('foodChoiceWebService', lunch.FoodChoiceWebService)
    .service('foodAvailabilityWebService', lunch.FoodAvailabilityWebService)
    .service('foodWebService', lunch.FoodWebService)
    // controllers
    .controller('lunchListController', lunch.LunchListController)
    .controller('signInController', lunch.SignInController)
    .controller('signUpController', lunch.SignUpController)
    .controller('supplierController', lunch.SupplierController)
    .controller('supplierOptionsController', lunch.SupplierOptionsController)
    .controller('chooseController', lunch.ChooseController)
    .controller('supplierFoodController', lunch.SupplierFoodController)
    .controller('supplierAddFoodController', lunch.SupplierAddFoodController)
    // directives
    .directive('calendar', lunch.calendarDirective);
