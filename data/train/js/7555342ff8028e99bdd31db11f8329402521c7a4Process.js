(function(){

	LetDooJS.Core.Process = function (_R) {

		var call = [],
			routeWaiting = [] ;


		LetDooJS.Core.Process.prototype.runAction = function (_R) {
			routeWaiting.push(_R);
			if(routeWaiting.length == 1) processAction(_R);
		};

		LetDooJS.Core.Process.callbackRender = function(){
			routeWaiting.shift();
			LetDooJS.Core.Controller.renderApplied = false;
			if(routeWaiting[0]) processAction(routeWaiting[0]);
		};

		function processAction (_R) {

			if (typeof _R == "function") {
				_R();
				LetDooJS.Core.Process.callbackRender();
				return false;
			}

			var nameController = _R.controller[0].toUpperCase() + _R.controller.substring(1) + "Controller";

			if(!call[nameController]){
				LetDooJS.System.load([nameController+"-Controller"] , function () {

					var controllerCalled = LetDooJS.System.getController(nameController);
					controllerCalled.bindController(nameController, LetDooJS.Controller[nameController]);

					var require = ( controllerCalled[nameController]["require"] ) ? controllerCalled[nameController]["require"] : [] ;
					LetDooJS.System.load(require, function () {
						if(controllerCalled[nameController]["init"]) controllerCalled[nameController]["init"](controllerCalled);
						callAction(controllerCalled, nameController, _R);
					});
				});
				call[nameController] = true;
			}else{
				var controllerCalled = LetDooJS.System.getController(nameController);
				callAction(controllerCalled, nameController, _R);
			}
		}

		function callAction(controller, nameController, _R) {
			var actionCalled = _R.action +"Action" ;
			if (_R.pattern) history.pushState( _R , _R.controller + "-" + actionCalled, LetDooJS.System.getWebPath() + _R.pattern);
			if (!controller[nameController][actionCalled]) throw "Action " + nameController + "::" + actionCalled + " not exist";
			controller[nameController][actionCalled](controller);

			if (!LetDooJS.Core.Controller.renderApplied) LetDooJS.Core.Process.callbackRender();
		}
	};

})();