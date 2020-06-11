describe('MainController', function() {

    var mainController, scope, $controller;

    var mockSocket = {
        emit: function(){},
        on: function(){}
    };

    beforeEach(module('app'));
    beforeEach(inject(function($rootScope, _$controller_) {
        scope = $rootScope.$new();
        $controller = _$controller_;
        mainController = $controller('MainController', {
            $scope : scope,
            socket: mockSocket
        });
    }));

    it('main controller should be defined', function() {
        expect(mainController).toBeDefined();
    });

});
