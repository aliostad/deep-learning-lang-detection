(function(angular) {
    function PersonalInfoController($scope) {
        var self = this,
            mainController = $scope.main;

        function init() {
            self.user = {
                name: mainController.user.name ? mainController.user.name : '',
                email: mainController.user.email ? mainController.user.email : '', 
                phone: mainController.user.phone ? mainController.user.phone : '',
                address: mainController.user.address ? mainController.user.address : ''
            };
        }

        this.forward = function() {
            mainController.updateModel(this.user);
            mainController.forward();
        };

        init();
    }

    angular.module('shopping')
        .controller('PersonalInfoController', PersonalInfoController);
})(window.angular);