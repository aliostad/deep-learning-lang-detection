(function(angular){
    "use strict";

    angular.module("mfl.reports.services", [
        "api.wrapper"
    ])

    .service("mfl.reports.services.wrappers",
        ["api", function(api) {
            this.filters = api.setBaseUrl("api/common/filtering_summaries/");
            this.facilities = api.setBaseUrl("api/facilities/facilities/");
            this.reporting = api.setBaseUrl("api/reporting/");
            this.chul_reporting = api.setBaseUrl("api/reporting/chul/");
            this.up_down_grades = api.setBaseUrl("api/reporting/upgrades_downgrades/");
            this.helpers = api.apiHelpers;
        }]
    );

})(window.angular);
