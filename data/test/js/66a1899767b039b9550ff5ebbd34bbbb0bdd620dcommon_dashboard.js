define(['jquery', 'knockout', 'modules/lifecycle/service_dashboard', 'modules/lifecycle/lifecycleServiceUtil'],
        function($, ko, service_dashboard, util) {
            console.log("defining CommDashboardViewModel ...");

            function CommonDashboardViewModel() {
                var self = this;

                self.serviceInstList = [];
                self.selectedService = {};
                self.serviceMetricList = [];
                self.serviceList = ko.observableArray([]);


                self.beforeRoutingAction = function() {
                    //Call RESTAPI to get Service Engagements
                    self.serviceInstList = util.getServiceList();

                    $.ajax({
                        type: 'POST',
//                        url: "js/mock/lifecycle/service_metrics.json",
                        url: "rest/lifecycle/sql",
                        dataType: "json", // data type of response
                        contentType: "application/json; charset=utf-8",
                        async: false,
                        data: JSON.stringify({"NAME": "service_metrics"}),
                        success: function(data, textStatus, jqXHR) {
//                                console.log("Responce from  get_scenario_params :" + JSON.stringify(data));
                            if (!data) {
                                alert("No service Instances Exists!");
                            } else {
                                self.serviceMetricList = data;
                                self.getEngCountAndStatus();
                            }
                        }
                    });
                };

                self.getEngCountAndStatus = function() {
//                    console.log("self.serviceInstList inside  self.getEngCountAndStatus " + JSON.stringify(self.serviceInstList));
                    $.each(self.serviceInstList, function(idx, serviceInst) {
                        serviceInst['inProgressCount'] = 0;
                        serviceInst['setUpCount'] = 0;
                        serviceInst['completedCount'] = 0;
                        serviceInst['totalCount'] = 0;

                        $.each(self.serviceMetricList, function(idx, serviceMetric) {

                            if (serviceInst.serviceId === serviceMetric.SERVICE_ID) {

                                if (serviceMetric.ENG_STATUS === "Active") {
                                    serviceInst['inProgressCount'] = Number(serviceMetric.ENG_COUNT);
                                }
                                if (serviceMetric.ENG_STATUS === "New") {
                                    serviceInst['setUpCount'] = Number(serviceMetric.ENG_COUNT);
                                }
                                if (serviceMetric.ENG_STATUS === "Scoped") {
                                    serviceInst['inProgressCount'] = Number(serviceInst['inProgressCount']) + Number(serviceMetric.ENG_COUNT);
                                }
                                if (serviceMetric.ENG_STATUS === "Closed") {
                                    serviceInst['completedCount'] = Number(serviceMetric.ENG_COUNT);
                                }
                            }

                        });
                        serviceInst['totalCount'] = Number(serviceInst['completedCount']) + Number(serviceInst['inProgressCount']) + Number(serviceInst['setUpCount']);

                    });
                };

                self.viewServiceDashboard = function(data) {
                    self.selectedService = data;
                    service_dashboard.setService(self.selectedService);
                };
            }
            return new CommonDashboardViewModel();
        }
);

