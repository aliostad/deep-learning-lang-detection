package handlers

import (
	"net/http"

	"github.com/danielkrainas/gobag/context"
	"github.com/gorilla/mux"

	"github.com/danielkrainas/csense/actions"
	"github.com/danielkrainas/csense/api/v1"
)

const ServerVersionHeader = "Csense-Version"
const ApiVersionHeader = "Csense-Api-Version"
const ApiVersion = "1"

type Api struct {
	router *mux.Router
}

func NewApi(actionPack actions.Pack) (*Api, error) {
	api := &Api{
		router: v1.RouterWithPrefix(""),
	}

	api.register(v1.RouteNameBase, Base)
	api.register(v1.RouteNameHooks, Hooks(actionPack))
	api.register(v1.RouteNameHook, HookMetadata(actionPack))

	return api, nil
}

func (api *Api) register(routeName string, dispatch http.HandlerFunc) {
	api.router.GetRoute(routeName).Handler(api.dispatcher(dispatch))
}

func (api *Api) dispatcher(dispatch http.HandlerFunc) http.Handler {
	return http.Handler(dispatch)
}

func (api *Api) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	w.Header().Add(ServerVersionHeader, acontext.GetVersion(r.Context()))
	w.Header().Add(ApiVersionHeader, ApiVersion)
	api.router.ServeHTTP(w, r)
}
