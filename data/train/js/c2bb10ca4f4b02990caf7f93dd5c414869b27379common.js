var useVM = false;

if (useVM == false) {

    var MasterSpecServiceUrl = "http://localhost/ServiceHost/SpecificationService.svc";
    var MasterSearchServiceUrl = "http://localhost/ServiceHost/SpecificationSearchService.svc";
    var MasterEmmisServiceUrl = "http://localhost/ServiceHost/EmmisDataService.svc"

}
else {

    var MasterSpecServiceUrl = "http://osmmobile-e530/ServiceHost/SpecificationService.svc";
    var MasterSearchServiceUrl = "http://osmmobile-e530/ServiceHost/SpecificationSearchService.svc";
    var MasterEmmisServiceUrl = "http://osmmobile-e530/ServiceHost/EmmisDataService.svc";
}