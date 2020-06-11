package log

import (
	"github.com/astaxie/beego"
	"github.com/cristian-sima/Wisply/controllers/admin/log/harvest/process"
)

func getHarvest() func(*beego.Namespace) {
	ns := beego.NSNamespace("/harvest",
		beego.NSNamespace("/process/:process",
			beego.NSRouter("", &process.Process{}, "*:Display"),
			beego.NSNamespace("/operation/:operation",
				beego.NSRouter("", &process.Operation{}, "*:Display"),
			),
			beego.NSRouter("/history", &process.Process{}, "*:ShowHistory"),
			beego.NSRouter("/advance-options", &process.Process{}, "*:ShowAdvanceOptions"),
			beego.NSRouter("/delete", &process.Process{}, "POST:Delete"),
		),
	)
	return ns
}
