"use strict"
module.exports = {

	dispatch: function (err, req, res, next) {
		var message = err.message;
		var status = err.status || 500;
		if (status == 500) {
			console.log(err.error || err);
		}
		res.json({ message: message }, status);
	},

	Error: function (error, message) {
		this.error = error;
		this.message = message;
		this.status = 500;
	},

	Unauthorized: function (message) {
		this.message = message;
		this.status = 401;
	},

	BadRequest: function (message) {
		this.message = message;
		this.status = 400;
	}

};
