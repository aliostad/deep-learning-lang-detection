package controller.handler;

public enum HandlerType {
	ADD_PRODUCT("controller.handler.AddProductHandler"),
	AUTHORIZATION("controller.handler.AuthorizationHandler"),
	DELETE_PERSON("controller.handler.DeletePersonHandler"),
	DELETE_PRODUCT("controller.handler.DeleteProductHandler"),
	LOGIN("controller.handler.LoginHandler"),
	LOGOUT("controller.handler.LogoutHandler"),
	PRODUCT_OVERVIEW("controller.handler.ProductOverviewHandler"),
	REGISTER("controller.handler.RegisterHandler"),
	UPDATE_PERSON("controller.handler.UpdatePersonHandler"),
	UPDATE_PRODUCT("controller.handler.UpdateProductHandler"),
	USER_OVERVIEW("controller.handler.UserOverviewHandler");
	
	private final String classPath;
	
	HandlerType(String classPath) {
		this.classPath = classPath;
	}
	
	public String getClassPath() {
		return classPath;
	}
}
