var portal = require('/lib/xp/portal');
exports.service = {};

exports.service.serviceUrl = function (service, params, module) {
    var url;
    if (params && module) {
        url = portal.serviceUrl({
            service: service,
            params: params,
            application: module
        });
    } else if (params) {
        url = portal.serviceUrl({
            service: service,
            params: params
        });
    } else if (module) {
        url = portal.serviceUrl({
            service: service,
            application: module
        });
    } else {
        url = portal.serviceUrl({
            service: service
        });
    }
    return url;
};