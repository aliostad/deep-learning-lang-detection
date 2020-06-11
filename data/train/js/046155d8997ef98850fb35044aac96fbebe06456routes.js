var MenuController           = require('./menu_controller');
var LoginController          = require('./login/login_controller');
var ReserveController        = require('./reserve/reserve_controller');
var ReserveSuccessController = require('./reserve/reserve_success_controller');
var ExistingController       = require('./existing/existing_controller');
var FinishController         = require('./finish/finish_controller');
var FinishSuccessController  = require('./finish/finish_success_controller');
var CompleteController         = require('./complete/complete_controller');
var CompleteSuccessController  = require('./complete/complete_success_controller');
var CarsController             = require('./cars/cars_controller');
var CarDetailController        = require('./cars/car_detail_controller');

module.exports = {
  '/': {
    templateUrl: 'menu.html', showMenuButton: false,
    controller: MenuController
  },

  '/login': {
    templateUrl: 'login/login.html', showMenuButton: false,
    controller: LoginController
  },

  '/reserve': {
    title: 'Rezervace',
    templateUrl: 'reserve/reserve.html',
    controller: ReserveController
  },

  '/reserve/:id/success': {
    title: 'Zarezervováno',
    templateUrl: 'reserve/reserve_success.html',
    controller: ReserveSuccessController,
    showMenuButton: false
  },

  '/reserve/:id/canceled': {
    title: 'Rezervace Zrušena',
    templateUrl: 'reserve/reserve_canceled.html',
    showMenuButton: false
  },

  '/existing': {
    title: 'Stávající Rezervace',
    templateUrl: 'existing/existing.html',
    controller: ExistingController
  },

  '/finish/:id': {
    title: 'Ukončení Rezervace',
    templateUrl: 'finish/finish.html',
    controller: FinishController
  },

  '/finish/:id/success': {
    title: 'Rezervace ukončena',
    templateUrl: 'finish/finish_success.html',
    controller: FinishSuccessController
  },

  '/complete/:id': {
    title: 'Ukončení Rezervace',
    templateUrl: 'complete/complete.html',
    controller: CompleteController
  },

  '/complete/:id/success': {
    title: 'Rezervace ukončena',
    templateUrl: 'complete/complete_success.html',
    controller: CompleteSuccessController
  },

  '/cars': {
    title: 'Auta',
    templateUrl: 'cars/cars.html',
    controller: CarsController
  },

  '/cars/:id': {
    title: 'Auta',
    templateUrl: 'cars/car_detail.html',
    controller: CarDetailController
  }
};
