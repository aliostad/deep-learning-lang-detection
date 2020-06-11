/**
 * Define the different Angular services for this module.
 */
module.exports = angular.module('common.clover-api', [])
	.constant('cloverConfig', require('./CloverConfig'))
	.service('customersService', require('./CustomersService'))
	.service('inventoryService', require('./InventoryService'))
	.service('ordersService', require('./OrdersService'))
	.service('paymentsService', require('./PaymentsService'))
	.service('payService', require('./PayService'))
	.service('taxRatesService', require('./TaxRatesService'))
	.service('tendersService', require('./TendersService'))
	.service('productModel', require('./../models/ProductModel'));