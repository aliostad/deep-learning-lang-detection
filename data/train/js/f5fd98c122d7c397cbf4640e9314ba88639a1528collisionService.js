(function () {

    var app = angular.module('chapp3d');

    app.service('collisionService', collisionService);

    collisionService.$inject = ['callService'];

    function collisionService(callService) {

        var collisionTypes = ["Collider"];

        function manageCollision(collision, stream) {
            if (collision.action === "call") {
                //make a test call
                return callService.call(collision, stream);
            }
            if (collision.action === "close") {
                return callService.close(collision);
            }
        }



        var service = {
            manageCollision: manageCollision
        };

        return service;

    };

})();