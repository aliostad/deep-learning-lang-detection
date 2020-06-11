/* exported Service */

var SERVICE_PROTO = 'https',
	SERVICE_HOST = 'census.daybreakgames.com',
	SERVICE_BASE = 'ps2:v2',
	SERVICE_ID = 'soe';

function Service(serviceName) {
	this.get = function(data) {
		// add defaults
		var defaults = {
			'c:lang': 'en',
			'c:limit': 1000
		};
		data = $.extend({}, defaults, data);

		// make ajax request
		return $.ajax({
			url: getServiceEndpoint(),
			data: data,
			dataType: 'jsonp',
			timeout: 10000
		});
	};

	function getServiceEndpoint() {
		return [
			SERVICE_PROTO,
			'://',
			SERVICE_HOST,
			'/s:',
			SERVICE_ID,
			'/json/get/',
			SERVICE_BASE,
			'/',
			serviceName
		].join('');
	}
}
