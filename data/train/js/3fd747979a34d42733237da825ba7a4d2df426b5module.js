import { router } from './router';
import { LagashBooksController } from './controller';
import { LagashBooksCreateController } from './create/controller';
import { LagashBooksUpdateController } from './update/controller';
import { LagashBooksEjemplarController } from './ejemplar/controller';
import { LagashBooksListController } from './list/controller';

angular.module('wolf.lagash.books', [
  'ui.router'
])
.config(router)
.controller('LagashBooksController', LagashBooksController)
.controller('LagashBooksCreateController', LagashBooksCreateController)
.controller('LagashBooksUpdateController', LagashBooksUpdateController)
.controller('LagashBooksEjemplarController', LagashBooksEjemplarController)
.controller('LagashBooksListController', LagashBooksListController)
.run(($log) => {
  $log.debug('run lagash books end');
});
