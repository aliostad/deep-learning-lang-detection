/*global define*/
define("userProfileService", [
	"baseService"
], function (Service) {
	"use strict";

	var serviceName = "userProfile";
	function UserProfileService(options) {
		var self = this;
		this.serviceName = serviceName;
		this.endpointType = this.CPUD_ENDPOINT_TYPE;
		this.resourceStrings = {
			get: "",
			post: ""
		};
		this.options = options;

		this.getUserProfile = function() {
			return this.validateEndpointResponse(
				self.get({}, {
					q: ""
				})
			);
		};
	}
	UserProfileService.serviceName = serviceName;
	UserProfileService.prototype = Service.prototype;


	return UserProfileService;
});
