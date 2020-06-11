define([
	'require',
	'js/page5/sub/serviceVoiceBusiness',
], function (require, _serviceVoiceBusiness) {
	'use strict'
	/**
	 * 固网业务量
    */
	function ServiceVoiceBusiness() {
		this.title = "固网业务量";
		this.elementId = "service-voice-business";
		this.serviceVoiceData = [];
		this.serviceVoiceChart = {};
	}
	ServiceVoiceBusiness.prototype.init = function () {
		this.serviceVoiceChart = _serviceVoiceBusiness;
		this.serviceVoiceChart.init('js-service-voice-business');
	}
	ServiceVoiceBusiness.prototype.setData = function (_serviceVoiceData) {
		this.serviceVoiceData = _serviceVoiceData;
	}
	ServiceVoiceBusiness.prototype.show = function () {
		this.serviceVoiceChart.setOption(this.serviceVoiceData);
	}

	return ServiceVoiceBusiness;
});