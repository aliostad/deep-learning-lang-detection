function $ServiceProvider() {
	var _services = {};
	return {
		provides: provides,
		provide:  provide
	};

	function provides(serviceName, serviceCode, isSingleton) {
		var serviceDescriptor = new ServiceDescriptor(this, serviceName, serviceCode, isSingleton);
		_services[serviceName] = serviceDescriptor;
		return serviceDescriptor;
	}

	function provide(serviceName, throwError) {
		var serviceCode = _services.hasOwnProperty(serviceName) ? _services[serviceName] : null;
		if (serviceCode === null && throwError) {
			throw new Error('$ServiceProvider: service "' + serviceName + '" not found');
		}
		var ret = serviceCode.get();
		return ret;
	}

	// inner class
	function ServiceDescriptor(serviceProvider, serviceName, serviceCode, isSingleton) {
		var _serviceProvider;
		var _serviceName = serviceName;
		var _serviceCode;
		var _isSingleton;
		var _serviceObject;
		var _initArguments;
		var _constructor;
		return {
			by:              by,
			loadFrom:        loadFrom,
			now:             now,
			asSingleton:     asSingleton,
			initializedWith: initializedWith,
			provides:        provides,
			get:             get
		};

		function by(serviceCode) {

			return this;
		}

		function asSingleton(isSingleton) {
			if (isSingleton === undefined) {
				isSingleton = true;
			}
			_isSingleton = Boolean(isSingleton);
			return this;
		}

		function initializedWith() {
			_initArguments = arguments;
			return this;
		}

		function get() {
			var service;
			if (_isSingleton) {
				if (!_serviceObject) {
					_serviceObject = _createService();
				}
				service = _serviceObject;
			} else {
				service = _createService();
			}
			return service;

		}

		function loadFrom(url) {
			return this;
		}

		function now() {
			if (!_checkValidity()) {
				throw new Error('ServiceDescriptor: Invalid data for "' + _serviceName + '"');
			}
			return this;
		}

		function provides(serviceName, serviceCode, isSingleton) {
			if (!_checkValidity()) {
				throw new Error('ServiceDescriptor: Invalid data for "' + _serviceName + '"');
			}
			return _serviceProvider.provides(serviceName, serviceCode, isSingleton);
		}

		/**
		 * Checks if this descriptor has enough values to provide a Service.
		 * @private
		 */
		function _checkValidity() {
			return false;
		}

		function _locateService() {

		}

		function _createService() {
			function F() {
				return _serviceCode.apply(this, _initArguments);
			}

			F.prototype = serviceCode.prototype;
			return new F();
		}
	}
}

