package rdispatch

import (
	"net/http"

	"github.com/huangml/dispatch"
)

type RemoteDestAdapter interface {
	BuildRequest(r dispatch.Request, remoteAddr string, method string) (*http.Request, error)
	ResolveResponse(r *http.Response) dispatch.Response
	HTTPMethod(m RemoteMethod) string
}

type RemoteDest struct {
	remoteAddr string
	adapter    RemoteDestAdapter
}

func NewRemoteDest(remoteAddr string, adapter RemoteDestAdapter) *RemoteDest {
	if adapter == nil {
		adapter = DefaultDestAdapter{}
	}

	return &RemoteDest{
		remoteAddr: remoteAddr,
		adapter:    adapter,
	}
}

func (d *RemoteDest) Call(ctx *dispatch.Context, r dispatch.Request) dispatch.Response {
	rsp, err := d.doRemoteRequest(r, MethodCall)
	if err != nil {
		return dispatch.SimpleResponse(nil, ToStatusError(err))
	} else {
		return rsp
	}
}

func (d *RemoteDest) Send(r dispatch.Request) error {
	_, err := d.doRemoteRequest(r, MethodSend)
	return err
}

func (d *RemoteDest) doRemoteRequest(r dispatch.Request, method RemoteMethod) (dispatch.Response, error) {
	rr, err := d.adapter.BuildRequest(r, d.remoteAddr, d.adapter.HTTPMethod(method))
	if rr == nil || err != nil {
		return nil, err
	}

	var client http.Client
	rs, err := client.Do(rr)
	if err != nil {
		return nil, err
	}

	return d.adapter.ResolveResponse(rs), nil
}

type DefaultDestAdapter struct{}

func (d DefaultDestAdapter) BuildRequest(r dispatch.Request, remoteAddr string, method string) (*http.Request, error) {
	return BuildRequest(r, remoteAddr, method)
}

func (d DefaultDestAdapter) ResolveResponse(r *http.Response) dispatch.Response {
	return ResolveResponse(r)
}

func (d DefaultDestAdapter) HTTPMethod(m RemoteMethod) string {
	return HTTPMethod(m)
}
