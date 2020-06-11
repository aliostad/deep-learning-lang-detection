function NotificationService () {
	console.log("NotificationService :instance created")
  	Service.call(this);
};

NotificationService.prototype = Object.create(Service.prototype);
NotificationService.prototype.constructor = NotificationService;


NotificationService.prototype.mark = function (url, callback) {
	this.doPUT(url, {}, callback);
}

NotificationService.prototype.list = function (url, callback) {
	this.doGET(url, callback);
}

NotificationService.prototype.delete = function (url, callback) {
	this.doDELETE(url, callback);
}