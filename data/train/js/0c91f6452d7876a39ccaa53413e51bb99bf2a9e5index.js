var TaxinvoiceService = require('./lib/TaxinvoiceService');
var StatementService = require('./lib/StatementService');
var CashbillService = require('./lib/CashbillService');
var MessageService = require('./lib/MessageService');
var FaxService = require('./lib/FaxService');
var HTTaxinvoiceService = require('./lib/HTTaxinvoiceService');
var HTCashbillService = require('./lib/HTCashbillService');
var ClosedownService = require('./lib/ClosedownService');
var linkhub = require('linkhub');

var configuration = {LinkID : '',SecretKey : '',IsTest : false};

exports.config = function(config) {
	configuration = config;
}

exports.MgtKeyType = {SELL:'SELL', BUY:'BUY', TRUSTEE:'TRUSTEE'};

exports.TaxinvoiceService = function() {
  if(!this._TaxinvoiceService) {
    this._TaxinvoiceService = new TaxinvoiceService(configuration);
  }
  return this._TaxinvoiceService;
}

exports.StatementService = function(){
  if(!this._StatementService){
    this._StatementService = new StatementService(configuration);
  }
  return this._StatementService;
}

exports.CashbillService = function() {
  if(!this._CashbillService) {
    this._CashbillService = new CashbillService(configuration);
  }
  return this._CashbillService;
}

exports.MessageType = {SMS : 'SMS', LMS : 'LMS', MMS : 'MMS'};

exports.MessageService = function() {
  if(!this._MessageService) {
    this._MessageService = new MessageService(configuration);
  }
  return this._MessageService;
}

exports.FaxService = function() {
  if(!this._FaxService) {
    this._FaxService = new FaxService(configuration);
  }
  return this._FaxService;
}

exports.HTTaxinvoiceService = function() {
  if(!this._HTTaxinvoiceService) {
    this._HTTaxinvoiceService = new HTTaxinvoiceService(configuration);
  }
  return this._HTTaxinvoiceService;
}

exports.HTCashbillService = function() {
  if(!this._HTCashbillService) {
    this._HTCashbillService = new HTCashbillService(configuration);
  }
  return this._HTCashbillService;
}

exports.ClosedownService = function() {
  if(!this._ClosedownService) {
    this._ClosedownService = new ClosedownService(configuration);
  }
  return this._ClosedownService;
}
