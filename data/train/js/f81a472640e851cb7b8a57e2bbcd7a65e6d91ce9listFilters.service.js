(function () {
    'use strict';

    angular
        .module('caucusHistoryAdmin')
        .service('ListFiltersService', ListFiltersService);

    ListFiltersService.$inject = ['CandidatesService', 'ResultsService'];
    function ListFiltersService(CandidatesService, ResultsService) {
        var service = {};

        service.years = ResultsService.getYears();
        service.year = {selected: service.years[1]};
        service.parties = [{party:'R', name: 'Republican'}, {party: 'D', name: 'Democrat'}];
        service.party = {selected: service.parties[0]};
        service.counties = ResultsService.getCounties();
        service.county = {selected: null};

        return service;


    }

})();