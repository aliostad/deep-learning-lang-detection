if (support) support.include(support.path+"Support/DOM/DOM.js", support.path+"Support/DOM/Associative.js", {callback:function () {
	function Service (name, options) {
		{ // Pre
			
		}
	}
	if (Service) {
		support.service = new support.Pack ("service", function service_load () {
			{ // Internal management
				var services = {};
			}
			
			{ // External use
				this.register = function register (name, service) {
					if ( service instanceof support.service.Service) services[name] = service;
				};
			}
		});
	}
} // Callback
});