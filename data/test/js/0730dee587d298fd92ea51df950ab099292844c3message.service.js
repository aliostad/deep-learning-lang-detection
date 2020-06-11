'use strict';

angular.module('spa.service.message', [])

        .factory('messageService', [function () {
                var messageService = {};

                messageService.setErrorMessage = function(controller, message) {
                    controller.error = true;
                    controller.errorMessage = message;
                };
                
                messageService.clearErrorMessage = function(controller) {
                    controller.error = false;
                    controller.errorMessage = "";
                };
                
                messageService.setSuccessMessage = function(controller, message) {
                    controller.success = true;
                    controller.successMessage = message;
                };
                
                messageService.clearSuccessMessage = function(controller) {
                    controller.success = false;
                    controller.successMessage = "";
                };
                
                messageService.clearAllMessages = function(controller) {
                    controller.error = false;
                    controller.errorMessage = "";
                    
                    controller.success = false;
                    controller.successMessage = "";
                    
                    controller.fromAdd = false;
                    controller.fromModify = false;
                };
                
                return messageService;

            }]);




