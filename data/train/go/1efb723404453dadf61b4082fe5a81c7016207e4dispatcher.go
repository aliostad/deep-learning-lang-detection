package apps

import (
	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"

	"github.com/rs1n/tonicapp/src/apps/api"
	"github.com/rs1n/tonicapp/src/apps/web"
)

type Dispatcher struct {
	apiApplication *api.ApiApplication
	webApplication *web.WebApplication
}

func NewDispatcher(db *sqlx.DB) *Dispatcher {
	return &Dispatcher{
		apiApplication: api.NewApiApplication(db),
		webApplication: web.NewWebApplication(),
	}
}

// Dispatch dispatches incoming requests.
func (d *Dispatcher) Dispatch(router gin.IRouter) {
	d.apiApplication.Route(router)
	d.webApplication.Route(router)
}
