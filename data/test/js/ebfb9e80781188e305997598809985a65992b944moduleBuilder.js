JuiS
	.module("framework")
	.service("AuthenticationService")
	.addMethod("framework/?service=AuthenticationService&method=login", "login", ["username","password"]);
JuiS
	.module("framework")
	.service("AuthenticationService")
	.addMethod("framework/?service=AuthenticationService&method=logout", "logout", []);
JuiS
	.module("contacts")
	.service("ContactService")
	.addMethod("modules/contacts/?service=ContactService&method=__construct", "__construct", ["environment"]);
JuiS
	.module("contacts")
	.service("ContactService")
	.addMethod("modules/contacts/?service=ContactService&method=create", "create", ["data"]);
JuiS
	.module("contacts")
	.service("ContactService")
	.addMethod("modules/contacts/?service=ContactService&method=update", "update", ["id","data"]);
JuiS
	.module("contacts")
	.service("ContactService")
	.addMethod("modules/contacts/?service=ContactService&method=findAll", "findAll", []);
JuiS
	.module("products")
	.service("ProductService")
	.addMethod("modules/products/?service=ProductService&method=__construct", "__construct", ["environment"]);
JuiS
	.module("products")
	.service("ProductService")
	.addMethod("modules/products/?service=ProductService&method=create", "create", ["data"]);
JuiS
	.module("products")
	.service("ProductService")
	.addMethod("modules/products/?service=ProductService&method=update", "update", ["id","data"]);
JuiS
	.module("products")
	.service("ProductService")
	.addMethod("modules/products/?service=ProductService&method=findAll", "findAll", []);
