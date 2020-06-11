/**
 * Created by jaraquistain on 6/14/14.
 */
AW.namespace("AW.App");
(function (namespace) {
    //////////////////////////////
    // Angular Module
    //////////////////////////////
    namespace.module = angular.module('AW', []);

    //////////////////////////////
    // Angular Controllers
    //////////////////////////////
    namespace.module
        .controller('NavController', AW.Controllers.Nav.controller)
        .controller('HomeController', AW.Controllers.Home.controller)
        .controller('InfoController', AW.Controllers.Info.controller)
        .controller('VegasController', AW.Controllers.Vegas.controller)
        .controller('RsvpController', AW.Controllers.Rsvp.controller)
        .controller('RegistryController', AW.Controllers.Registry.controller)
        .controller('TestController', AW.Controllers.Test.controller)
        .controller('InviteController', AW.Controllers.Invite.controller);
}(AW.App));