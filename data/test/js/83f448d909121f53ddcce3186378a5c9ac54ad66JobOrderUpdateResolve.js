define(function () {
  return {
    joborder: ['JobOrderService', '$stateParams', function (JobOrderService, $stateParams) {
      if ($stateParams.joborderCode) {
        return JobOrderService.get({trackingNo: $stateParams.joborderCode});
      }
    }],
//    serviceTypes: ['$q', 'ServiceTypeService', function ($q, ServiceTypeService) {
//      var data = $q.defer();
//      return ServiceTypeService.findEnabled({page: 1}, function (response) {
//        data.resolve(response.data);
//      });
//      return data.promise;
//    }],
    jobItemTypes: ['JobItemTypeService', function (JobItemTypeService) {
      return JobItemTypeService.query();
    }]
  };
});
