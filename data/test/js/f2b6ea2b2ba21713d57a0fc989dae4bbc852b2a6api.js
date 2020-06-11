;(function(app) {
	var api = function(options) {
		_.extend(this, {		
			url_base: "/api/",
		});
		_.extend(this, options);
	}	
	api.generate = function(id) {
		return function(data, callback) {
			return $.ajax({
				type	: "POST",
  				url	: this.url_base + id,
				data 	: JSON.stringify(data),
  				success	: callback,
  				dataType: "json",
  				async	: false,
  				contentType : "application/json"
			});
		}
	}	
	
	api.prototype.reg_read = api.generate("1");
	api.prototype.reg_write = api.generate("2");

	api.prototype.mem_read = api.generate("3");
	api.prototype.mem_write = api.generate("4");
		
	api.prototype.poll = api.generate("5");
	
	app.api = new api();	
	
})(app);



