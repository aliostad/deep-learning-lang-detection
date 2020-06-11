package reactor

/*
   This Module just register onSuccess and onError functions
   to Suber.
   While onSuccess be called, it's means request arriving, the
   onSuccess get request and parse the request, dispatch the request
   by request.command.
*/

import (
	"encoding/json"
	log "github.com/alecthomas/log4go"
)

type Router struct {
	Suber      *Subscriber
	AuthKey    string
	HandlerMap map[string]func(*Request) (*Response, error)
}

func NewRouter(
	suber *Subscriber,
	auth_key string,
	handlermap map[string]func(*Request) (*Response, error)) *Router {

	_router := &Router{Suber: suber, AuthKey: auth_key, HandlerMap: handlermap}
	return _router
}

/*
   Run the router and listening on event
   of the key on Message Queue.
   In redis, the event maybe the key of list struct
*/
func (router *Router) Run(event string) {
	/*
	   why Golang without unconstructor function ?
	   Notice defer method, it only unrelease your resource
	   while the while function return
	*/
	defer router.Suber.Close()

	/*
	   starting Subscribe from Message Queue and dispatch
	   task to it's map handler
	*/
	router.Suber.Sub(
		event,
		router.onSuccess, router.onError,
	)
}

func (router *Router) onSuccess(data string) error {
	log.Info("Router onSuccess be called, with data:%s", data)

	_request := Request{}
	if err := json.Unmarshal([]byte(data), &_request); err != nil {
		log.Error("json Unmarshal failed, error:%s", err)
		return err
	} else {
		router.dispatch(&_request)
		return nil
	}
}

func (router *Router) onError(data string) error {
	return nil
}

func (router *Router) dispatch(request *Request) {
	if callback, ok := router.HandlerMap[request.Command]; ok {
		if ret, err := callback(request); err != nil {
			if request.AuthKey != router.AuthKey {
				log.Error("Router dispatch, AuthKey auth failed")
			}
			log.Error("Router dispatch, callback called failed, error:%s", err)
		} else {
			log.Info("Router dispatch, callback called success")

			if _rjson, err := json.Marshal(ret); err == nil {
				log.Info("Router dispatch, ret data:%s", _rjson)
				router.Suber.Pub(request.ResponseKey, string(_rjson))
			} else {
				log.Error(
					"Router dispatch, callback called success, json Marshal failed, error:%s", err)
			}
		}
	}
}

func (router *Router) Close() {
	router.Suber.Close()
}
