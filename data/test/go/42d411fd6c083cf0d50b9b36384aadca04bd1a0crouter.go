package fingy

import (
	log "github.com/Sirupsen/logrus"
	"github.com/ant0ine/go-urlrouter"
	"github.com/nicolas-nannoni/fingy-gateway/events"
)

type Router struct {
	Router urlrouter.Router
}

type Context struct {
	Params map[string]string
}

func (r *Router) Entry(path string, dest func(c *Context)) {

	route := urlrouter.Route{
		PathExp: path,
		Dest:    dest,
	}
	r.Router.Routes = append(r.Router.Routes, route)
	r.Router.Start()
}

func (r *Router) Dispatch(evt *events.Event) {

	route, params, err := r.Router.FindRoute(evt.Path)
	if route == nil {
		log.Errorf("Unable to dispatch  %v: no matching route found", evt)
		return
	}
	if err != nil {
		log.Errorf("Unable to dispatch event %v: %v", evt, err)
		return
	}

	c := Context{
		Params: params,
	}
	route.Dest.(func(c *Context))(&c)
}
