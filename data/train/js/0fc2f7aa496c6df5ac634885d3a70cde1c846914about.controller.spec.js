describe('about controller', function() {

    beforeEach(module('app'));

    var $controller;

    beforeEach(inject(function(_$controller_) {
        // The injector unwraps the underscores (_) from around the parameter names when matching
        $controller = _$controller_;
    }));

    it('should not be undefined', function() {
        var controller = $controller('AboutController');
        expect(controller).not.toBeUndefined();
    });

    it('should not be null', function() {
        var controller = $controller('AboutController');
        expect(controller).not.toBeNull();
    });

});