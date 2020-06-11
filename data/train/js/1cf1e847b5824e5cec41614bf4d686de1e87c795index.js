'use strict';

var angular = require('angular');

angular.module('partsApp')
  .controller('AuthController', ["$window", "$location", "SigninService","SignupService", require('./auth.controller')])
  .controller('AboutController', require('./about.controller'))

  .controller('AccountController',["$scope", "$route", "$window", "$http", "GetUsersQuotes","PostNewQuote", "CheckForAuthService", require('./account.controller')])
  .controller('FormController',require('./form.controller'))
  .controller('ContactController', require('./contact.controller'))

  // user controllers
  .controller('UserDashController', ["$location" ,require('./user/userDash.controller')])
  .controller('QuoteRequestController', ["NewQuoteService",require('./user/quoteRequest.controller')])
  .controller('UserQuotesController', ["GetUsersQuotes", require('./user/pricedQuotes.controller')])

  // admin controllers
  .controller('AdminController', ["$scope", "AdminSummaryService", "DummyDataService", require('./admin.controller')])
  .controller('RequestedQuotesController', ["AdminQuotesService", "PutPriceForQuoteService", require('./admin/requestedQuotes.controller')])
  .controller('PricedQuotesController', ["AdminQuotesService", require('./admin/pricedQuotes.controller')])

  // error handling controllers
  .controller('ErrorController', require('./error.controller'));
