package jsonrpc

import "encoding/json"

const (
	SupportedVersion = "2.0"

	InvalidRequest = -32600
	MethodNotFound = -32601
	InvalidParams  = -32602
	InternalError  = -32603
	ParseError     = -32700
)

var (
	InternalErrorTemplate = `{"jsonrpc":"2.0","error":{"code":-32603,"message":"%s"},"id": null}`
	DefaultInternalError  = []byte(`{"jsonrpc":"2.0","error":{"code":-32603,"message":"Internal Error"},"id": null}`)
)

type (
	Proxy interface {
		Encode(Response)
	}
	// Method for JSONRPC requests
	Method interface {
		Process(json.RawMessage) (json.Marshaler, *Error)
	}
	// Handler for JSONRPC notifications
	Handler interface {
		Process(json.RawMessage)
	}
	// Callback for JSONRPC response callback
	Callback interface {
		Process(Response)
	}
)

// Dispatcher holds RPC call routing implementation
type Dispatcher interface {
	DispatchResponse(Response)
	DispatchNotification(Request)
	DispatchRequest(Request, Responder)
}
