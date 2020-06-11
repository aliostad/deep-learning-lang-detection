package rdispatch

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"time"

	"github.com/huangml/dispatch"
	"github.com/huangml/mux"
)

type RemoteMethod int

const (
	MethodCall RemoteMethod = iota
	MethodSend
)

func (m RemoteMethod) String() string {
	switch m {
	case MethodCall:
		return "MethodCall"
	case MethodSend:
		return "MethodSend"
	default:
		return fmt.Sprintf("RemoteMethod(%d)", m)
	}
}

func HTTPMethod(m RemoteMethod) string {
	switch m {
	case MethodCall:
		return "PUT"
	case MethodSend:
		return "POST"
	default:
		return "PUT"
	}
}

func ParseMethodFromHTTP(r *http.Request) RemoteMethod {
	switch r.Method {
	case "PUT":
		return MethodCall
	case "POST":
		return MethodSend
	default:
		return MethodCall
	}
}

const (
	OctetStream = "application/octet-stream"
	Json        = "application/json"
	XProtoBuf   = "application/x-protobuf"
	TextPlain   = "text/plain"

	TimeOutKey     = "X-Dispatch-Timeout"
	ContentTypeKey = "Content-Type"
)

func ResolveRequest(r *http.Request) dispatch.Request {
	return &RemoteRequest{
		Request: dispatch.SimpleRequest(r.RequestURI, r.RequestURI, ParseSinkFromHTTP(r.Body, r.Header)),
		Auth:    ParseAuthFromHTTP(r),
		TimeOut: ParseTimeOutFromHTTP(r),
	}
}

func WriteResponse(r *http.Request, w http.ResponseWriter, rsp dispatch.Response) {
	if rsp == nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	if sink := rsp.Body(); sink != nil {
		w.Header().Set(ContentTypeKey, ContentTypeToHTTP(sink.ContentType))
		w.Write(sink.Bytes())
		return
	}

	if rsp.Error() == nil {
		w.WriteHeader(http.StatusOK)
		return
	}

	if e, ok := rsp.Error().(StatusError); ok {
		w.WriteHeader(e.StatusCode())
	} else {
		w.WriteHeader(http.StatusInternalServerError)
	}
}

func ResolveResponse(r *http.Response) dispatch.Response {
	if r.StatusCode != http.StatusOK {
		return dispatch.SimpleResponse(nil, statusError{statusCode: r.StatusCode})
	}
	return dispatch.SimpleResponse(ParseSinkFromHTTP(r.Body, r.Header), nil)
}

func BuildRequest(r dispatch.Request, remoteAddr string, method string) (*http.Request, error) {
	if remoteAddr == "" {
		return nil, errors.New("invalid remoteAddr")
	}
	if remoteAddr[len(remoteAddr)-1] == '/' {
		remoteAddr = remoteAddr[:len(remoteAddr)-1]
	}

	sink := r.Body()

	var buffer *bytes.Buffer
	if sink != nil {
		buffer = bytes.NewBuffer(sink.Bytes())
	}

	req, err := http.NewRequest(method, remoteAddr+mux.PathTrim(r.Address()), buffer)
	if err != nil || req == nil {
		return nil, err
	}

	if sink != nil {
		req.Header.Set(ContentTypeKey, ContentTypeToHTTP(sink.ContentType))
	}

	if r, ok := r.(*RemoteRequest); ok {
		if r.Auth != nil {
			req.SetBasicAuth(r.Auth.UserName, r.Auth.Password)
		}
		if r.TimeOut > 0 {
			req.Header.Set(TimeOutKey, r.TimeOut.String())
		}
	}

	return req, err
}

func ParseSinkFromHTTP(body io.ReadCloser, header http.Header) *dispatch.Sink {
	b, _ := ioutil.ReadAll(body)
	c := ContentTypeFromHTTP(header.Get(ContentTypeKey))
	s := dispatch.BytesSink(b)
	s.ContentType = c
	return s
}

func ParseAuthFromHTTP(r *http.Request) *Auth {
	if username, password, ok := r.BasicAuth(); ok {
		return &Auth{
			UserName: username,
			Password: password,
		}
	}
	return nil
}

func ParseTimeOutFromHTTP(r *http.Request) time.Duration {
	if t, err := time.ParseDuration(r.Header.Get(TimeOutKey)); err == nil {
		return t
	}

	return 0
}

func ContentTypeFromHTTP(v string) dispatch.ContentType {
	switch v {
	case OctetStream:
		return dispatch.Bytes
	case TextPlain:
		return dispatch.Text
	case Json:
		return dispatch.Json
	case XProtoBuf:
		return dispatch.Protobuf
	default:
		return dispatch.Bytes
	}
}

func ContentTypeToHTTP(c dispatch.ContentType) string {
	switch c {
	case dispatch.Bytes:
		return OctetStream
	case dispatch.Text:
		return TextPlain
	case dispatch.Json:
		return Json
	case dispatch.Protobuf:
		return XProtoBuf
	default:
		return OctetStream
	}
}
