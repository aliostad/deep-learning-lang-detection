'use strict';

var emitterMixin = require('emitter-mixin');
var skivvyUtils = require('skivvy-utils');

var loadConfigJson = require('./helpers/loadConfigJson');
var initProject = require('./api/initProject');

var DEFAULT_ENVIRONMENT_NAME = require('./constants').DEFAULT_ENVIRONMENT_NAME;

function Api(path, environment) {
	try {
		loadConfigJson(path);
	} catch (error) {
		throw error;
	}
	this.path = path;
	this.environment = environment || DEFAULT_ENVIRONMENT_NAME;
}

Api.initProject = initProject;

Api.prototype.path = null;
Api.prototype.redispatcher = null;

addEmitterMethods(Api);

Api.events = require('./events');
Api.constants = require('./constants');
Api.errors = require('./errors');
Api.utils = skivvyUtils;

Api.prototype.events = Api.events;
Api.prototype.errors = Api.errors;
Api.prototype.utils = Api.utils;

Api.prototype.getEnvironmentConfig = require('./api/getEnvironmentConfig');
Api.prototype.getPackageConfig = require('./api/getPackageConfig');
Api.prototype.getTaskConfig = require('./api/getTaskConfig');
Api.prototype.installPackage = require('./api/installPackage');
Api.prototype.uninstallPackage = require('./api/uninstallPackage');
Api.prototype.updatePackage = require('./api/updatePackage');
Api.prototype.listPackages = require('./api/listPackages');
Api.prototype.updateEnvironmentConfig = require('./api/updateEnvironmentConfig');
Api.prototype.updatePackageConfig = require('./api/updatePackageConfig');
Api.prototype.updateTaskConfig = require('./api/updateTaskConfig');
Api.prototype.run = require('./api/run');


function addEmitterMethods(Api) {
	emitterMixin(Api);
	emitterMixin(Api.prototype);

	var emit = Api.prototype.emit;
	Api.prototype.emit = function(type, listener) {
		var hasListeners = emit.apply(this, arguments);
		return Api.emit.apply(Api, arguments) || hasListeners;
	};
}

module.exports = Api;
