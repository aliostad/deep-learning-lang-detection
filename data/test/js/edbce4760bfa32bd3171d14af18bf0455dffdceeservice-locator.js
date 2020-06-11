var services = {
		'patient': require('./patient-service'),
		'doctor': 'doctor-service'
	};

module.exports = {
	getService: function (serviceInfo) {
		var service = services[serviceInfo.serviceName];
		
		if ( !service ) throw Error('Illegal Service name: ', serviceInfo.serviceName);
		
		if ( typeof service === 'string' ) {
			services[serviceInfo.serviceName] = require('./' + service);
			service = services[serviceInfo.serviceName];
		}
		
		if ( !service[serviceInfo.serviceMethod] )
			throw Error('Illegal Service method call: ' + serviceInfo.serviceName + '[' + serviceInfo.serviceMethod + ']');
			
		return function (cb) {
			return service[serviceInfo.serviceMethod]({ params: serviceInfo.serviceMethodArgs, cb: cb });
		};
	}
};
