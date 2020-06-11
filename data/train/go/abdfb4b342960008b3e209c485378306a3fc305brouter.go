// @APIVersion 1.0.0
// @Title opcode server API
// @Description beego has a very cool tools to autogenerate documents for your API
// @Contact qsg@corex-tek.com
// @TermsOfServiceUrl http://beego.me/
// @License Apache 2.0
// @LicenseUrl http://www.apache.org/licenses/LICENSE-2.0.html
package routers

import (
	"opcode-server/controllers"

	"github.com/astaxie/beego"
)

func init() {
	ns := beego.NewNamespace("/v1",
		beego.NSNamespace("/dispatch",
			beego.NSInclude(
				&controllers.DispatchController{},
			),
		),
	)
	beego.AddNamespace(ns)
}
