function makeApi(services, apiFactory, process) {
	var api = [];
	if (services) {

		for (var i in services) {

			api.push(apiFactory.create(services[i], process));
		}
	}
	return api;
}

function mergeApi(api) {
	var merged = [];

	api.map(function (service) {
		for (var path in service) {
			merged[path] = service[path];
		}
	});

	return merged;
}

function ApiBuilder(serviceLoader, apiFactory, process) {

	if (!serviceLoader || !serviceLoader.load) {
		throw new Error('Expected a ServiceLoader');
	}

	if (!apiFactory || !apiFactory.create) {
		throw new Error('Expected a ApiFactory');
	}

	if (!process || !process.exec) {
		throw new Error('Expected a Process');
	}

	this.build = function (path) {
		var services = serviceLoader.load(path);

		var api = makeApi(services, apiFactory, process);

		return mergeApi(api);
	};

};

module.exports = ApiBuilder;
