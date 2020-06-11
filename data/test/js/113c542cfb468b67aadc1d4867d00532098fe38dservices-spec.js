describe('factory: SessionService', function () {
    var SessionsService, $location, $q, $log, _, AuthService, DashboardService, OrganisationService, Session;

    beforeEach(module('fooforms', function ($provide) {
        AuthService = {};
        DashboardService = {};
        OrganisationService = {};
        Session = {};

        $provide.value('AuthService', AuthService);
        $provide.value('DashboardService', DashboardService);
        $provide.value('OrganisationService', OrganisationService);
        $provide.value('Session', Session);
    }));

    beforeEach(inject(function (_SessionsService_) {
        SessionsService = _SessionsService_;

    }));
});