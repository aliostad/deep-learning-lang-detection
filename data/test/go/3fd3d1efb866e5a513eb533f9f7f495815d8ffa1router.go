package routers

import (
	"code/controllers/index"
	"code/controllers/manager"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &index.IndexController{})
	beego.Router("/posts/:id([0-9]+)", &index.IndexController{}, "get:Posts")

	beego.Router("/upload", &manager.UploadController{}, "post:Post")

	beego.Router("/manager", &manager.WelcomeController{})
	beego.Router("/manager/login", &manager.LoginController{})
	beego.Router("/manager/logout", &manager.LoginController{}, "get:Logout")

	beego.Router("/manager/article/:type:string", &manager.ArticleController{})
	beego.Router("/manager/article/create", &manager.ArticleController{}, "get,post:Create")
	beego.Router("/manager/article/edit/:id([0-9]+)", &manager.ArticleController{}, "get:Edit")
	beego.Router("/manager/article/edit", &manager.ArticleController{}, "post:Edit")
	beego.Router("/manager/article/del", &manager.ArticleController{}, "post:Delete")
	beego.Router("/manager/article/view/:id([0-9]+)", &manager.ArticleController{}, "get:View")
	beego.Router("/manager/article/remove", &manager.ArticleController{}, "post:Trash")

	beego.Router("/manager/category", &manager.CategoryController{})
	beego.Router("/manager/category/create", &manager.CategoryController{}, "get,post:Create")
	beego.Router("/manager/category/edit/:id([0-9]+)", &manager.CategoryController{}, "get:Edit")
	beego.Router("/manager/category/edit", &manager.CategoryController{}, "post:Edit")
	beego.Router("/manager/category/del", &manager.CategoryController{}, "post:Delete")

	beego.Router("/manager/user", &manager.UserController{})
	beego.Router("/manager/user/create", &manager.UserController{}, "get,post:Create")
	beego.Router("/manager/user/del", &manager.UserController{}, "post:Delete")
	beego.Router("/manager/user/edit/:id([0-9]+)", &manager.UserController{}, "get:Edit")
	beego.Router("/manager/user/edit", &manager.UserController{}, "post:Edit")

}
