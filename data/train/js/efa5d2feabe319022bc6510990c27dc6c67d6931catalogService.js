angular.module('autoServices')
.factory('CatalogServices', ['$routeParams',
         function($routeParams) {
           var msgService = {};
           msgService.manufacturer = '';
           msgService.model = '';
           msgService.newOrUsedData = '';

           msgService.setManufacturer = function(manufacturer) {
             msgService.manufacturer = manufacturer;
           };

           msgService.getManufacturer = function() {
             return msgService.manufacturer;
           };

           msgService.getManufacturerId = function() {
             if (!msgService.manufacturer) return 0;
             return msgService.manufacturer.id;
           };

           msgService.setModel = function(model) {
             if (model && model.id) {
               model.model_id = model.id;
             }
             msgService.model = model;
           };

           msgService.getModel = function() {
             return msgService.model;
           };

           msgService.getModelId = function() {
             if (!msgService.model) return 0;
             if (msgService.model.id)
               return msgService.model.id;
             return msgService.model.model_id;
           };

           msgService.setNewOrUsedData = function(newOrUsed) {
             msgService.newOrUsedData = newOrUsed;
           };

           msgService.getNewOrUsed = function() {
             return msgService.newOrUsedData;
           };

           return msgService;
         }
]);
