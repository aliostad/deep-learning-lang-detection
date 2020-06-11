function ServiceLoader(fileService, serviceFactory) {

	if (!fileService || !fileService.read || !fileService.ls)
		throw new Error('Expects a FileService');

	if (!serviceFactory || !serviceFactory.create)
		throw new Error('Expects a ServiceFactory');

	this.load = function (root) {
		var serviceNames = fileService.ls(root);

		if (!serviceNames || serviceNames.length == 0) {
			throw new Error("Folder '" + root + "' does not contain any services");
		}

		var serviceConfigs = serviceNames.map(makeServiceConfigReader(fileService, root));

		var services = [];
		var service;
		for (var i in serviceConfigs) {
			try {
				services.push(serviceFactory.create(serviceConfigs[i]));
			} catch (e) {
				console.log(e);
			}
		}

		return services;

	};

};

function makeServiceConfigReader(fileService, root) {
	return function readServiceConfigFile(service) {
		return JSON.parse(fileService.read(root + '/' + service + '/config.json'));
	};
}

module.exports = ServiceLoader;
