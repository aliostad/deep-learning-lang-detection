hits_api = {
	api: undefined,

	rest: function() {
		if (! hits_api.api) {
			hits_api.api = new $.RestClient(
				hits_config.endpoint,
				{
					cache: 10,
					stripTrailingSlash: true,
					stringifyData: true,
					request: function(resource, options) {
						return $.ajax(options);
					},
					ajax: {
						contentType:"application/json; charset=utf-8"
					},
					fail: function(err) {
						if (err.status == 403)
							alert("403 Error");
							/*
							alertify.confirm("Authentication Failure: " + err.statusText, function (e) {
								if (e) {
									window.location = hits_util.getRoot() + 'login/';
								} else {
									throw("403 error - " + err.statusText);
								}
							});
							*/
						else {
							console.log(err);
							if (err.responseText) {
								alert("Unknown API Error: " + err.statusText + "<br><pre>" + err.responseText + "</pre>");
							}
						}
					}
				}
			);

			hits_api.api.add('app');
			hits_api.api.add('tag');
			hits_api.api.add('school');
			hits_api.api.school.add('app');
			hits_api.api.add('vendor');
			hits_api.api.vendor.add('info');
			hits_api.api.vendor.add('app');
			hits_api.api.app.add('action');
		}
		return hits_api.api;
	}
};
