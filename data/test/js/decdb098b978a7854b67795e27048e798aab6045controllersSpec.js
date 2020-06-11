'use strict';

/* jasmine specs for controllers go here */

describe('controllers', function(){
    beforeEach(function() {
        module('hash0.controllers');
        module('hash0.services');
    });

    it('should have all expected controllers', inject(function($controller, $rootScope, metadata) {
        var scope = $rootScope.$new();
        var dispatcherController = $controller('DispatcherController', {
            '$scope': scope,
            'metadata': metadata
        });
        expect(dispatcherController).toBeDefined();

        var setupController = $controller('SetupController', {
            '$scope': scope
        });
        expect(setupController).toBeDefined();

        var unlockController = $controller('UnlockController', {
            '$scope': scope
        });
        expect(unlockController).toBeDefined();

        var generationController = $controller('GenerationController', {
            '$scope': scope
        });
        expect(generationController).toBeDefined();

        var mappingController = $controller('MappingController', {
            '$scope': scope
        });
        expect(mappingController).toBeDefined();
    }));
});
