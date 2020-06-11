define([
    "angular",
    "angularMocks",
    "../../scripts/services/serviceExample"
    ], function (angular, mocks, ServiceExample) {

        describe("serviceExample test", function () {

            var service;

            beforeEach(mocks.module("example", function ($provide) {
            }));

            beforeEach(mocks.inject(function (_serviceExample_) {
                service = _serviceExample_;
            }));

            it("should get the value", function () {
                var data = 42;
                service.setServiceData(data);
                expect(service.getServiceData()).toEqual(data);
            });

        });

    });
