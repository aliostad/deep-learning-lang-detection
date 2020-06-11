package apps

import (
	"github.com/go-chi/chi"
	"github.com/rs1n/tonic"

	"github.com/rs1n/tonic-app/src/apps/api"
	"github.com/rs1n/tonic-app/src/apps/web"
)

type Dispatcher struct {
	apiApplication *api.ApiApplication
	webApplication *web.WebApplication
}

func NewDispatcher(env *tonic.Env) *Dispatcher {
	return &Dispatcher{
		apiApplication: api.NewApiApplication(env),
		webApplication: web.NewWebApplication(env),
	}
}

// Dispatch dispatches incoming requests.
func (d *Dispatcher) Dispatch(router chi.Router) {
	d.apiApplication.Route(router)
	d.webApplication.Route(router)
}
