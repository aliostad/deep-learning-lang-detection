define(['controllers/login_controller', 'controllers/BaseController', 'controllers/Tree3dController', 'models/login_model'], function(loginController, BaseController, Tree3dController, LoginModel) {
	return Backbone.Router.extend({

		initialize : function () {
			this._container = $('#wr');
			this._currentController = null;
			this.model = new LoginModel();
			this.model.checkLogin();
		},
		
		routes : {
			"tree" 		: "tree",
			"tree3d"	: "tree3d",
			"*actions"  : "login"
		},
		
		_runController : function (ControllerConstructor) {
			if (this._currentController) {
				this._currentController.destroy();
			}
			this._container.empty();
			this._currentController = new ControllerConstructor({el : this._container});
		},
		
		login : function () {
			this._runController(loginController);
		},
		
		tree : function () {
			this._runController(BaseController);
		},
		
		tree3d : function () {
			this._runController(Tree3dController);
		}
		
	});

});
