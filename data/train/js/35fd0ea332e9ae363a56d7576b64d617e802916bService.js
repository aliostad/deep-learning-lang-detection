function updateServiceInformation(jsonHSGService) {
    var s = getUserCurrentProtocol();
    jsonHSGService.Common = s + "localhost/HSG.service.devqa/Common/CommonService.svc";
    jsonHSGService.Home = s + "localhost/HSG.service.devqa/Home/HomeService.svc";
    jsonHSGService.Inventory = s + "localhost/HSG.service.devqa/Inventory/InventoryService.svc";
    jsonHSGService.Marketing = s + "localhost/HSG.service.devqa/Marketing/MarketingService.svc";
    jsonHSGService.Order = s + "localhost/HSG.service.devqa/Order/OrderService.svc";
    jsonHSGService.Notification = s + "localhost/HSG.service.devqa/Notification/NotificationService.svc";
    jsonHSGService.Product = s + "localhost/HSG.service.devqa/Product/ProductService.svc";
    jsonHSGService.User = s + "localhost/HSG.service.devqa/User/UserService.svc";
    jsonHSGService.Reports = s + "localhost/HSG.service.devqa/Reports/ReportsService.svc";   
}