// Package controller loads the routes for each of the controllers.
package controller

import (
	"github.com/blue-jay/blueshift/controller/about"
	"github.com/blue-jay/blueshift/controller/debug"
	"github.com/blue-jay/blueshift/controller/home"
	"github.com/blue-jay/blueshift/controller/login"
	"github.com/blue-jay/blueshift/controller/notepad"
	"github.com/blue-jay/blueshift/controller/register"
	"github.com/blue-jay/blueshift/controller/static"
	"github.com/blue-jay/blueshift/controller/status"
)

// LoadRoutes loads the routes for each of the controllers.
func LoadRoutes() {
	about.Load()
	debug.Load()
	register.Load()
	login.Load()
	home.Load()
	static.Load()
	status.Load()
	notepad.Load()
}
