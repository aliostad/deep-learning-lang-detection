
define(["./unitjs"], function(unitjs)
{
	function TestSuite() {
		function runNextTestCase() {
			api.testCases[++api.currentTestCase]
				? api.testCases[api.currentTestCase].run(api)
				: done();
		}

		function done() {
			api.timeEnd = unitjs.now();

			if (api.isPassed == null)
				api.isPassed = true;

			api.callListeners("suiteDone", [api]);
			api.isWorking = false; // should go after the listener is called
		}


		var api = this;

		api.testCases = [];
		api.currentTestCase = -1;
		api.listeners = [];
		api.timeStart = 0;
		api.timeEnd = 0;
		api.isPassed = null;
		api.isWorking = false;


		api.callListeners = function(methodName, args) {
			if (api.isWorking)
				for (var i = 0, listener; i < api.listeners.length; i++) {
					listener = api.listeners[i];
					listener[methodName].apply(listener, args);
				}
			return api;
		};

		api.addTestCases = function() {
			for (var i = 0; i < arguments.length; i++)
				api.testCases.push(arguments[i]);
			return api;
		};

		api.addListeners = function() {
			for (var i = 0; i < arguments.length; i++)
				api.listeners.push(arguments[i]);
			return api;
		};

		api.run = function() {
			if (!api.isWorking) {
				api.isWorking = true;
				api.callListeners("suiteBegin", [api]);
				api.currentTestCase = -1;
				api.timeStart = unitjs.now();
				runNextTestCase();
			}
			return api;
		};

		api.stop = function() {
			if (api.isWorking) {
				api.testCases[api.currentTestCase].stop();
				done();
			}
			return api;
		};

		api.caseDone = function() {
			if (api.isWorking) {
				if (!api.testCases[api.currentTestCase].isPassed)
					api.isPassed = false;
				runNextTestCase();
			}
			return api;
		}
	}

	return TestSuite;
});
