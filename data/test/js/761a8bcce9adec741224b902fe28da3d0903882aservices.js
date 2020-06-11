define([
    'Lodash',
    'services/header/service',
    'services/main/service',
    'services/home/service',
    'services/home/product-filters/service',
    'services/home/product-changes-schedule/service',
    'services/product-info/service',
    'services/shared/modal/service',
    'services/shared/spin/service',
    'services/shop/service'
], function(_, HeaderService, MainService, HomeService, ProductFiltersService, ProductChangesScheduleService, ProductInfoService,
            ModalService, SpinService, ShopService) {
  "use strict";

  var services = {
      "HeaderService": HeaderService,
      "MainService": MainService,
      "HomeService": HomeService,
      "ProductFiltersService": ProductFiltersService,
      "ProductChangesScheduleService": ProductChangesScheduleService,
      "ProductInfoService": ProductInfoService,
      "ModalService": ModalService,
      "SpinService": SpinService,
      "ShopService": ShopService
  };

  var initialize = function (angModule) {
    _.each(services,function(service,name){
      angModule.factory(name,service);
    })
  }

  return {
    initialize: initialize
  };
});
