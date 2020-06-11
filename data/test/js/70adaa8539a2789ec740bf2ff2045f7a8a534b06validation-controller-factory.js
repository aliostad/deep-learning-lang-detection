System.register(['./validation-controller', './validator'], function(exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var validation_controller_1, validator_1;
    var ValidationControllerFactory;
    return {
        setters:[
            function (validation_controller_1_1) {
                validation_controller_1 = validation_controller_1_1;
            },
            function (validator_1_1) {
                validator_1 = validator_1_1;
            }],
        execute: function() {
            /**
             * Creates ValidationController instances.
             */
            ValidationControllerFactory = (function () {
                function ValidationControllerFactory(container) {
                    this.container = container;
                }
                ValidationControllerFactory.get = function (container) {
                    return new ValidationControllerFactory(container);
                };
                /**
                 * Creates a new controller instance.
                 */
                ValidationControllerFactory.prototype.create = function (validator) {
                    if (!validator) {
                        validator = this.container.get(validator_1.Validator);
                    }
                    return new validation_controller_1.ValidationController(validator);
                };
                /**
                 * Creates a new controller and registers it in the current element's container so that it's
                 * available to the validate binding behavior and renderers.
                 */
                ValidationControllerFactory.prototype.createForCurrentScope = function (validator) {
                    var controller = this.create(validator);
                    this.container.registerInstance(validation_controller_1.ValidationController, controller);
                    return controller;
                };
                return ValidationControllerFactory;
            }());
            exports_1("ValidationControllerFactory", ValidationControllerFactory);
            ValidationControllerFactory['protocol:aurelia:resolver'] = true;
        }
    }
});
