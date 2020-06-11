
var service = acre.require('/freebase/apps/appeditor/lib_appeditor_service');

function run_fb_service(service_url, service, args) {
    if (typeof service_url !== 'undefined')
        acre.freebase.service_url = service_url;

    var res = null;
    switch (service) {
    case 'touch':
        res = acre.freebase.touch();
        break;
    case 'mqlread':
        res = acre.freebase.mqlread.apply(null, args);
        break;
    default:
        throw "Invalid service name";
    }
    return res;
}

if (acre.current_script == acre.request.script) {
    service.GetService(function() {
        var args = service.parse_request_args(['service']);

        return run_fb_service(args.service_url, args.service, JSON.parse(args.args || '[]'));
    }, this);
}