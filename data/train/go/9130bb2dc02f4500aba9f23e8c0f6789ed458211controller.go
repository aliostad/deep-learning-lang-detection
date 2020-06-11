// Package controller loads the routes for each of the controllers.
package controller

import (
	"github.com/arapov/pile/controller/about"
	"github.com/arapov/pile/controller/debug"
	"github.com/arapov/pile/controller/home"
	"github.com/arapov/pile/controller/login"
	"github.com/arapov/pile/controller/notepad"
	"github.com/arapov/pile/controller/register"
	"github.com/arapov/pile/controller/roster"
	"github.com/arapov/pile/controller/static"
	"github.com/arapov/pile/controller/status"
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
	roster.Load()
}
