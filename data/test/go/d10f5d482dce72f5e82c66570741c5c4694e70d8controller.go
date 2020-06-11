// Package controller loads the routes for each of the controllers.
package controller

import (
	"github.com/UNO-SOFT/szamlazo/controller/about"
	"github.com/UNO-SOFT/szamlazo/controller/debug"
	"github.com/UNO-SOFT/szamlazo/controller/home"
	"github.com/UNO-SOFT/szamlazo/controller/login"
	"github.com/UNO-SOFT/szamlazo/controller/notepad"
	"github.com/UNO-SOFT/szamlazo/controller/register"
	"github.com/UNO-SOFT/szamlazo/controller/static"
	"github.com/UNO-SOFT/szamlazo/controller/status"
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
