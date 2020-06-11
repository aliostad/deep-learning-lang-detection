define([
	'require',
	'js/page5/sub/serviceNetworkBusiness',
], function (require, _serviceNetworkBusiness) {
	'use strict'
	/**
	 * 宽带业务量
    */
	function ServiceNetworkBusiness() {
		this.title = "宽带业务量";
		this.elementId = "service-network-business";
		this.serviceNetworkData = [];
		this.serviceNetworkChart = {};
	}
	ServiceNetworkBusiness.prototype.init = function () {
		this.serviceNetworkChart = _serviceNetworkBusiness;
		this.serviceNetworkChart.init('js-service-network-business');
	}
	ServiceNetworkBusiness.prototype.setData = function (_serviceNetworkData) {
		this.serviceNetworkData = _serviceNetworkData;
	}
	ServiceNetworkBusiness.prototype.show = function () {
		this.serviceNetworkChart.setOption(this.serviceNetworkData);
	}

	return ServiceNetworkBusiness;
});