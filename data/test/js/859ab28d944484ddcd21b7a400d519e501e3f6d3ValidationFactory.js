(function () {
    var ValidationFactory = function () {


        factory = {};

        factory.showErrorsConfig = function () {

            console.log("validation factory reached")
            var _showSuccess;
            _showSuccess = false;
            this.showSuccess = function (showSuccess) {
                return _showSuccess = showSuccess;
            };
            this.$get = function () {
                return { showSuccess: _showSuccess };
            };
        };
        return factory;
    }


    ValidationFactory.$inject = [];
    angular.module('EDRLightbox').factory('ValidationFactory', ValidationFactory);

}());