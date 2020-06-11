var os = require('os');
var lnx = require('./linux-service');
function service(settings) {
	if(settings) {
		if("output" in settings) {
			if(settings.output == false) {
				delete settings.output;
			}
		}
		switch(os.platform()) {
			//case "win32".
			//	break;
			case "linux":
				this._service = new lnx.LinuxService(settings);
				break;
			default:
				throw new Error("Operating system not supported! OS: " + os.platform());
				break;
		}
		this.settings = settings;
	} else {
		throw new Error("No settings passed!");
	}
	
}
service.prototype.install = function(callback) {
	if(this._service)
		this._service.install(callback);
}
service.prototype.installSync = function() {
	if(this._service)
		return this._service.installSync();
}


service.prototype.uninstall = function(callback) {
	if(this._service)
		this._service.uninstall(callback);
}
service.prototype.uninstallSync = function() {
	if(this._service)
		return this._service.uninstallSync();
}

service.prototype.start = function() {
	if(this._service)
		this._service.start();
}
service.prototype.stop = function() {
	if(this._service)
		this._service.stop();
}
service.prototype.restart = function() {
	this.stop();
	this.start();
}
exports.Service = service;