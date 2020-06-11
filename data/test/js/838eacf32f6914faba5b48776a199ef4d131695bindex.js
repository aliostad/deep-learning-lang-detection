(function() {
  'use strict';

  var constants = require('../../../constants');

  angular.module(constants.MODULES.COMMON)
    .factory('GiveTransferService', require('./giveTransfer.service'))
    .factory('PaymentService', require('./payment.service'))
    .factory('Programs', require('./programs.service'))
    .factory('DonationService', require('./donation.service'))
    .factory('GiveFlow', require('./giveFlow.service'))
    .factory('PaymentDisplayDetailService', require('./paymentDisplayDetail.service'))
    .constant('CC_BRAND_CODES', require('./ccBrand.constants'))
    ;
})();
