var reportingApi = "#{Lightstone.dp.report.api.url}";
var schedulerApi = "#{Lightstone.dp.schedule.api.url}";
var apiEndpoint = "#{Lightstone.dp.bill.api.url}";

// Report API
if (reportingApi.indexOf("Lightstone.dp.report.api.url") > -1) {
    reportingApi = "http://dev.reporting.api.lightstone.co.za";
}
// Schedule API
if (schedulerApi.indexOf("Lightstone.dp.schedule.api.url") > -1) {
    schedulerApi = "http://dev.billing.scheduler.lightstone.co.za";
}
// Billing API
if (apiEndpoint.indexOf("Lightstone.dp.bill.api.url") > -1) {
    apiEndpoint = "http://dev.billing.api.lightstone.co.za";
}