window.omniscience.factory('informationService', function informationService() {
	"use strict";

	var _services = {}; //key is service.type.raw

	return {
		get: function (rawServiceType) {
			if (typeof rawServiceType === "string" && rawServiceType.length > 0)
				return _services[rawServiceType];
		},
		put: function (serviceInformation) {
			if (typeof serviceInformation === "object" && typeof serviceInformation.type === "object"
					&& typeof serviceInformation.type.raw === "string" && serviceInformation.type.raw.length > 0)
				_services[serviceInformation.type.raw] = serviceInformation;
		},
		init: function () {
			_services = {};
		}
	};
});