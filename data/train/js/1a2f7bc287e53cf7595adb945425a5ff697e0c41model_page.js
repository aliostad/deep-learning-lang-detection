define("model_page", ["jquery", "pubsub" ],function($, View){

		// Private State
		var view = View;

		// Private Methods
		function nav_login(){
			nav("page_login");
		};
		function nav_home(){
			nav("home");
		};
		function nav_my_workspace() {
			nav("my_workspace");
		};

		function nav(page_name){
			$('.menuItem').removeClass('ui-state-active');
			view.render(page_name);
		};

		function bind_model() {
			$.subscribe("logged_out", function(){ 
				nav_home();
			});
		};

		bind_model();


		return {
			nav_home: nav_home,
			nav_login: nav_login,
			nav_my_workspace: nav_my_workspace
		};
});