'use strict';

var angular = require('angular');

var ProductsAdminModule = angular.module('broker.admin.products', [])
  .controller('ProductsAdminController', require('./products_admin_controller'))
  .controller('ListProductsController', require('./list_products_controller'))
  .controller('EditProductController', require('./edit_product_controller'))
  .controller('CreateProductController', require('./create_product_controller'))
  .controller('ProductFormController', require('./product_form_controller'))
  .config(require('./routes'));

module.exports = ProductsAdminModule;
