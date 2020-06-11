/*global define*/
define("widgetConfigService", [
	"baseService"
], function (Service) {
	"use strict";

	var serviceName = "widgetconfig";
	function WidgetConfigService(options) {
		var self = this;
		this.serviceName = serviceName;
		this.endpointType = this.CPUD_ENDPOINT_TYPE;
		this.resourceStrings = {
			get: "",
			post: ""
		};
		this.options = options;

		this.getConfig = function() {
			return this.validateEndpointResponse(
				self.get({}, {
					q: ""
				})
			);
		};
	}
	WidgetConfigService.serviceName = serviceName;
	WidgetConfigService.prototype = Service.prototype;


	return WidgetConfigService;
});
