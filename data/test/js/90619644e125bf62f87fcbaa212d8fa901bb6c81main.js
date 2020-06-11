import angular from 'angular';
import 'angular-ui-router';
import 'angular-foundation';
import configFunction from './config';
import 'angular-cookies';

import CreateAcctController from './controllers/admin/createAcctController';
import LogInController from './controllers/admin/loginController';
import TopBarController from './controllers/admin/topBarController';
import AddUserController from './controllers/house/addUserController';
import SingleBillController from './controllers/singleBillController';
import TreasurerDashboardController from './controllers/treasurerDashboardController.js';
import AddBillsController from './controllers/house/addBillsController';
import MemberService from './services/memberService';
import AdminService from './services/adminService';
import BillService from './services/billService';
import SinglePersonController from './controllers/house/singlePersonController';
import EditBillController from './controllers/editBillController';





angular
  .module('app', ['ui.router', 'mm.foundation', 'ngCookies'])
  .constant('SERVER', {
    URL: 'https://pure-gorge-6188.herokuapp.com',
    CONFIG: {
      headers: {}
    }
  })
  .config(configFunction)
  .controller('TreasurerDashboardController', TreasurerDashboardController)
  .controller('CreateAcctController', CreateAcctController)
  .controller('LogInController', LogInController)
  .controller('AddUserController', AddUserController)
  .controller('TopBarController', TopBarController)
  .controller('AddBillsController', AddBillsController)
  .controller('SinglePersonController', SinglePersonController)
  .controller('SingleBillController', SingleBillController)
  .controller('EditBillController', EditBillController)
  .service('AdminService', AdminService)
  .service('MemberService', MemberService)
  .service('BillService', BillService)
;
