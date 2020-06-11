define([
    'underscore',
    './visitService',
    './journeyService',
    './memberService',
    './personService',
    './tableService',
    './dataDicService',
    './countryService',
    './unitService'
], function (_, vs, js, ms, ps, ts, ds, cs, unitService) {
    "use strict";

    var services = _.extend({}, vs, js, ms, ps, ts, ds, cs, unitService);

    var initialize = function (angModule) {
        _.each(services, function (service, name) {
            angModule.factory(name, service);
        });
    };

    return {
        initialize: initialize
    };
});
