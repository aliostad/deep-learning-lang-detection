describe('EmbedTagService', function () {
    'use strict';

    var embed, baseService, embedTagService, oEmbedProvider, oEmbedProviderService;

    beforeEach(module('ngEmbed'));
    beforeEach(inject(function (_baseService_, _embedTagService_, _oEmbedProvider_, _oEmbedProviderService_) {
        baseService = _baseService_;
        embedTagService = _embedTagService_;
        oEmbedProvider = _oEmbedProvider_;
        oEmbedProviderService =_oEmbedProviderService_;
    }));

    it('should inherit from base service', function () {
        expect(embedTagService.prototype.constructor).toEqual(baseService);
    });

    it('should have a getEmbed method', function () {
        expect(embedTagService.getEmbed).toBeTruthy();
    });

    it('should', function() {

    });
});