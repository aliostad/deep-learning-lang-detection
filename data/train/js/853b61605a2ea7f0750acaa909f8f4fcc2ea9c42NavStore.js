'use strict';

var NavStore = require('../../../../src/scripts/stores/NavStore');

describe('NavStore', function () {

    it('should notify listeners on emitNavigate', function () {
        var navListener1 = {
            callback: function() {}
        };
        spyOn(navListener1, 'callback');

        var navListener2 = {
            callback: function() {}
        };
        spyOn(navListener2, 'callback');

        var navListener3 = {
            callback: function() {}
        };
        spyOn(navListener3, 'callback');

        NavStore.addNavigateListener(navListener1.callback);
        NavStore.addNavigateListener(navListener2.callback);
        NavStore.addNavigateListener(navListener3.callback);
        NavStore.removeNavigateListener(navListener2.callback);

        NavStore.emitNavigate();

        expect(navListener1.callback.calls.count()).toEqual(1);
        expect(navListener2.callback.calls.count()).toEqual(0);
        expect(navListener3.callback.calls.count()).toEqual(1);
    });
});
