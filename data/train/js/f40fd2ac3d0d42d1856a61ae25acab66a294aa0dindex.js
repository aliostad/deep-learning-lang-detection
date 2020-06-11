var kernelServices = exports
	//,flatiron = require('flatiron')
	,kernel = require('../../app')
	,fs = require('fs')
	,path = require('path')
	,services = {};

exports.getService = function(serviceName) {
	var servicePath, loadedServiceName
		,files, i = 0, availableServiceName;
			
	if(serviceName in services) {
		return services[serviceName];
	}
	
	// check for exact name match
	servicePath = path.join(__dirname, serviceName+'.js');
	if(fs.existsSync(servicePath)) {
		return services[serviceName] = require(servicePath);
	}

	// iterate loaded services
	for(loadedServiceName in services) {
		if(kernelServices.serviceProvides(services[loadedServiceName], serviceName)) {
			return services[loadedServiceName];
		}
	}
	
	// iterate all unloaded but available services
	files = fs.readdirSync(__dirname);
	for(; i < files.length; i++) {
		availableServiceName = files[i];
		
		if (availableServiceName.substr(-3) === '.js') {
			availableServiceName = availableServiceName.substr(0, availableServiceName.length - 3);
		}
		
		if(availableServiceName == 'index' || availableServiceName in services) {
			console.log('skipping file', availableServiceName);
			continue;
		}
		
		services[availableServiceName] = require(path.join(__dirname, availableServiceName));
		
		if(kernelServices.serviceProvides(services[availableServiceName], serviceName)) {
			return services[availableServiceName];
		}
	}
	
	return false;
};

exports.serviceProvides = function(service, serviceName) {
	var provides = service.provides;

	if(!provides) {
		return false;
	}

	if(typeof provides == 'string' && provides == serviceName) {
		return true;
	}
	
	if(Array.isArray(provides) && provides.indexOf(serviceName) != -1) {
		return true;
	}
	
	if(typeof provides == 'function' && provides(serviceName)) {
		return true;
	}
	
	return false;
};