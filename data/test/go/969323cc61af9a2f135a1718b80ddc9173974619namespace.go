package namespace

import (
	"net/http"

	"github.com/cloudway/platform/api/server/httputils"
	"github.com/cloudway/platform/api/server/router"
	"github.com/cloudway/platform/broker"
)

type namespaceRouter struct {
	*broker.Broker
	routes []router.Route
}

func NewRouter(broker *broker.Broker) router.Router {
	r := &namespaceRouter{Broker: broker}

	r.routes = []router.Route{
		router.NewGetRoute("/namespace", r.get),
		router.NewPostRoute("/namespace", r.set),
		router.NewDeleteRoute("/namespace", r.delete),
	}

	return r
}

func (nr *namespaceRouter) Routes() []router.Route {
	return nr.routes
}

func (nr *namespaceRouter) NewUserBroker(r *http.Request) *broker.UserBroker {
	ctx := r.Context()
	user := httputils.UserFromContext(ctx)
	return nr.Broker.NewUserBroker(user, ctx)
}

func (nr *namespaceRouter) get(w http.ResponseWriter, r *http.Request, vars map[string]string) error {
	br := nr.NewUserBroker(r)
	if err := br.Refresh(); err != nil {
		return err
	}
	return httputils.WriteJSON(w, http.StatusOK, map[string]interface{}{
		"Namespace": br.Namespace(),
	})
}

func (nr *namespaceRouter) set(w http.ResponseWriter, r *http.Request, vars map[string]string) error {
	if err := httputils.ParseForm(r); err != nil {
		return err
	}
	return nr.NewUserBroker(r).CreateNamespace(r.FormValue("namespace"))
}

func (nr *namespaceRouter) delete(w http.ResponseWriter, r *http.Request, vars map[string]string) error {
	if err := httputils.ParseForm(r); err != nil {
		return err
	}
	_, force := r.Form["force"]
	return nr.NewUserBroker(r).RemoveNamespace(force)
}
