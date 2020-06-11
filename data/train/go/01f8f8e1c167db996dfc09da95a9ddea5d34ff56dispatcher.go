package rdispatch

import (
	"net/http"
	"time"

	"github.com/huangml/dispatch"
)

type RemoteDispatcherAdapter interface {
	Method(r *http.Request) RemoteMethod
	ResolveRequest(r *http.Request) dispatch.Request
	WriteResponse(r *http.Request, w http.ResponseWriter, rsp dispatch.Response)
}

type RemoteDispatcher struct {
	*dispatch.Dispatcher
	adapter RemoteDispatcherAdapter
}

func NewRemoteDispatcher(d *dispatch.Dispatcher, adapter RemoteDispatcherAdapter) *RemoteDispatcher {
	if adapter == nil {
		adapter = DefaultDispatcherAdapter{}
	}

	return &RemoteDispatcher{
		Dispatcher: d,
		adapter:    adapter,
	}
}

func (d *RemoteDispatcher) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	rr := d.adapter.ResolveRequest(r)
	if rr == nil {
		d.adapter.WriteResponse(r, w, dispatch.SimpleResponse(nil, statusError{http.StatusBadRequest, ""}))
		return
	}

	var rsp dispatch.Response

	switch d.adapter.Method(r) {
	case MethodCall:
		t := time.Second * 10
		if req, ok := rr.(*RemoteRequest); ok && req.TimeOut != 0 {
			t = req.TimeOut
		}
		rsp = d.Call(dispatch.NewContextWithTimeOut(t), rr)
	case MethodSend:
		err := d.Send(rr)
		rsp = dispatch.SimpleResponse(nil, ToStatusError(err))
	default:
		rsp = dispatch.SimpleResponse(nil, statusError{http.StatusBadRequest, ""})
	}

	d.adapter.WriteResponse(r, w, rsp)
}

type DefaultDispatcherAdapter struct{}

func (d DefaultDispatcherAdapter) Method(r *http.Request) RemoteMethod {
	return ParseMethodFromHTTP(r)
}

func (d DefaultDispatcherAdapter) ResolveRequest(r *http.Request) dispatch.Request {
	return ResolveRequest(r)
}

func (d DefaultDispatcherAdapter) WriteResponse(r *http.Request, w http.ResponseWriter, rsp dispatch.Response) {
	WriteResponse(r, w, rsp)
}
