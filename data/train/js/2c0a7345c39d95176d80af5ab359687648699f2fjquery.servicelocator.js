(function($){

	var _serviceLocator = {};

	function Service() {}
	Service.prototype.execute = function (type, options, fixture, useFixture) {
		if (typeof useFixture != "undefined" && useFixture) {
			options.success(fixture);
			return;
		}

		$[type](options);
	};

	$.extend({
		addService: function (name, options) {
			var newService = $.extend (new Service(), options);
			_serviceLocator[name] = newService;
			return newService;
		}, 
		getService: function (name) {
			return _serviceLocator[name];
		}
	});

})( jQuery );
