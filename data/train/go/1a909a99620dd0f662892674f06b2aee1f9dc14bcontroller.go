package controller

import (
	"servicecontrol.io/servicecontrol/controller/account"
	"servicecontrol.io/servicecontrol/controller/billing"
	"servicecontrol.io/servicecontrol/controller/capabilities"
	"servicecontrol.io/servicecontrol/controller/dashboard"
	"servicecontrol.io/servicecontrol/controller/login"
	"servicecontrol.io/servicecontrol/controller/logout"
	"servicecontrol.io/servicecontrol/controller/register"
	"servicecontrol.io/servicecontrol/controller/services"
	"servicecontrol.io/servicecontrol/controller/static"
	"servicecontrol.io/servicecontrol/controller/status"
	"servicecontrol.io/servicecontrol/controller/support"
	"servicecontrol.io/servicecontrol/controller/usage"
)

// LoadRoutes loads all routes for all controllers
func LoadRoutes() {
	dashboard.Load()
	static.Load()
	capabilities.Load()
	services.Load()
	usage.Load()
	support.Load()
	login.Load()
	logout.Load()
	account.Load()
	billing.Load()
	register.Load()
	status.Load()
}
