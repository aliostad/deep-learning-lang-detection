function AskService() {
	//console.log("AskService:instance created")
  	Service.call(this);
};

AskService.prototype = Object.create(Service.prototype);
AskService.prototype.constructor = AskService;


AskService.prototype.create = function (url, data, callback) {
	console.log("AskService:create")
	this.doPOST(url, data, callback);
}


AskService.prototype.retrieve = function (url, callback) {
	//console.log("AskService:retrieve")
	this.doGET(url, callback);
}

AskService.prototype.update = function (url, data, callback) {
	console.log("AskService:update")
	this.doPUT(url, data, callback);
}


AskService.prototype.list = function (url, callback) {
	//console.log("AskService:list")
	this.doGET(url, callback);
}

/*
AskService.prototype.delete = function (url, callback) {
	console.log("AskService:delete")
	this.doDELETE(url);
}
*/