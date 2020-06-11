'use strict';
/* global sofa */

describe('sofa.StateResolverService', function () {

    var stateResolverService,
        qService,
        configService,
        httpService;


    beforeEach(function () {
        configService        = new sofa.ConfigService();
        qService             = new sofa.QService();
        httpService          = new sofa.mocks.httpService(qService);
        stateResolverService = new sofa.StateResolverService(qService, httpService, configService);
    });

    it('should be defined', function () {
        expect(stateResolverService).toBeDefined();
    });

    it('should resolve state', function (done) {
        var state = {
            url: 'some-url'
        };

        stateResolverService.registerState(state);

        stateResolverService
            .resolveState(state.url)
            .then(function (resolvedState) {
                expect(resolvedState).toEqual(state);
                done();
            });
    });
    
});


describe('sofa.StateResolverService.angular', function() {
    var StateResolverService, StateResolver;
    beforeEach(module('sofa.stateResolverService'));
    beforeEach(inject(function($injector) {
        StateResolverService = $injector.get('stateResolverService');
        StateResolver = $injector.get('stateResolver');
    }));
    it('should exists', function() {
        expect(StateResolverService).toBeDefined();
        expect(StateResolver).toBeDefined();
    });
});
