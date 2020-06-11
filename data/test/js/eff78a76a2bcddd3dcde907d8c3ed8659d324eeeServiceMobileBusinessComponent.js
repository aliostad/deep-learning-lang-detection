define([
	'require',
	'js/page5/sub/serviceMobileBusiness',
], function (require, _serviceMobileBusiness) {
	'use strict'
	/**
	 * 移动业务量
    */
	function ServiceMobileBusiness() {
		this.title = "移动业务量";
		this.elementId = "service-mobile-business";
		this.serviceMobileData = [];
		this.serviceMobileChart = {};
	}
	ServiceMobileBusiness.prototype.init = function () {
		this.serviceMobileChart = _serviceMobileBusiness;
		this.serviceMobileChart.init('js-service-mobile-business');
	}
	ServiceMobileBusiness.prototype.setData = function (_serviceMobileData) {
		this.serviceMobileData = _serviceMobileData;
	}
	ServiceMobileBusiness.prototype.show = function () {
		this.serviceMobileChart.setOption(this.serviceMobileData);
	}

	return ServiceMobileBusiness;
});