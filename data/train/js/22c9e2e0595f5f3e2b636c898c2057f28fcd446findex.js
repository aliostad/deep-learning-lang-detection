import angular from 'angular';
import '../app-core/index';

import WishesController from './controllers/wishes.controller';
import WishesAddController from './controllers/wishes.add.controller';
import EditController from './controllers/wishes.edit.controller';
import DeleteController from './controllers/wishes.delete.controller';

import WishService from './services/wish.service';

import wishItem from './directives/wishes.directive';



angular
  .module('app.wish', ['app.core'])
  .controller('WishesController', WishesController)
  .controller('WishesAddController', WishesAddController)
  .controller('EditController', EditController)
  .controller('DeleteController', DeleteController)

  .service('WishService', WishService)

  .directive('wishItem', wishItem)
;