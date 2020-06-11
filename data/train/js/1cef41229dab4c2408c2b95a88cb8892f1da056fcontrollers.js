(function () {
    angular.module('MyApp')
        .controller('StartController', StartController)
        .controller('NewUserController', NewUserController)
        .controller('CreateController', NewTrickController)
        .controller('go', go);

    function StartController() {
        var vm = this;
    };

    function NewUserController() {
        var vm = this;
    };

    function CreateController() {
        var vm = this;
        console.log("It worked");
    };

    $scope.go = function (path) {
        $location.path(path);
    };
})();