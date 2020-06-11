'use strict';

exports.__esModule = true;

var _containerService = require('./container-service');

var _contractService = require('./contract-service');

var _customerService = require('./customer-service');

var _secupayDebitService = require('./secupay-debit-service');

var _secupayPrepayService = require('./secupay-prepay-service');

var _transactionService = require('./transaction-service');

var Payment = {};
exports.Payment = Payment;
Payment.ContainerService = _containerService.ContainerService;
Payment.ContractService = _contractService.ContractService;
Payment.CustomerService = _customerService.CustomerService;
Payment.SecupayDebitService = _secupayDebitService.SecupayDebitService;
Payment.SecupayPrepayService = _secupayPrepayService.SecupayPrepayService;
Payment.TransactionService = _transactionService.TransactionService;