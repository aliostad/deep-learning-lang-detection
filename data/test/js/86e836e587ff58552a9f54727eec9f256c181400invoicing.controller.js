class InvoicingController {
  constructor($log, lodash, files, OrderService, CustomerService, PositionService, PricelistService, InvoicingService, SettingsService) {
    'ngInject';

    var vm = this;
    vm.log = $log;
    vm._ = lodash;
    vm.pricelistService = PricelistService;
    vm.invoicingService = InvoicingService;
    vm.customerService = CustomerService;
    vm.positionService = PositionService;
    vm.orderService = OrderService;
    vm.settingsService = SettingsService;
    vm.itemsByPage = 20;
    vm.files = files.data;
    let api = vm.settingsService.getApiServer();
    vm.files = vm._.map(vm.files, function (f) {
      return {displayName: f.displayName, url: api + f.url};
    });

  }

}

export default InvoicingController ;
