var Service = require('./service');

// ACCOUNTS endpoints
// http://developer.oanda.com/rest-practice/accounts/
var AccountsService = function () {

	// GET /v1/accounts
	this.getAccounts = function (onComplete, username) {
		var service = new Service('accounts', onComplete);
		service.pushAcctIdParam();
		service.pushParam({ username: username }, true);
		service.get();
	};

	// GET /v1/accounts/:account_id
	this.getAccountInfo = function (onComplete) {
		var service = new Service('accounts/:account_id', onComplete);
		service.setAcctIdActionParam();
		service.get();
	};

};

module.exports = AccountsService;