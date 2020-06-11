// Restish package.
package restish

import "net/http"

// Contains the Resource Status Codes. Normally used to define the HTTP status code associated with the resource once
// processing is complete.
type StatusCode struct {
	Code   int
	Status string
}

const (
	ActionCreate = "create"
	ActionRead   = "read"
	ActionUpdate = "update"
	ActionDelete = "delete"
)

// HTTP Response Codes.
var (
	StatusOk             = StatusCode{200, "OK"}
	StatusCreated        = StatusCode{201, "Created"}
	StatusBadRequest     = StatusCode{400, "Bad Request"}
	StatusNotFound       = StatusCode{404, "Not Found"}
	StatusServerError    = StatusCode{500, "Internal Server Error"}
	StatusNotImplemented = StatusCode{501, "Not Implemented"}
	StatusTeapot         = StatusCode{418, "I'm a teapot"}
)

var (
	// All the Endpoint dispatchers
	dispatchers     = map[string]Dispatcher{}
	defaultDispatch Dispatcher
)

// Add a new controller to the dispatcher
func AddController(controller Controller, endpoint string) {
	dispatchers[endpoint] = &Dispatch{controller}
}

// Add the default controller. Used when a matching controller cannot be found
func AddDefaultController(controller Controller) {
	defaultDispatch = &Dispatch{controller}
}

// Find the dispatcher responsible for the provided resource
func GetDispatch(resource *Resource) (Dispatcher, error) {
	route := resource.Self

	if dispatch, ok := dispatchers[route.Href]; ok {
		return dispatch, nil
	}

	if nil == defaultDispatch {
		return nil, new(DispatchError)
	}

	return defaultDispatch, nil
}

// Convert an HTTP request into a rest resource ready for processing
func RequestResource(request *http.Request) *Resource {
	resource := NewResource(request.RequestURI)

	return resource
}

// Convert a Resource into a raw Response ready to be converted into the http response string (json/xml/etc)
func ResourceResponse(resource *Resource) map[string]interface{} {
	response := map[string]interface {} {
		"@xmlns": resource.Type,
		"@xmlns:atom": "http://www.w3.org/2005/Atom",
	}

	links := []map[string]string{}

	// Add links to the response
	for _, link := range resource.Links {
		links = append(links, map[string]string{
			"@rel":  link.Rel,
			"@href": link.Href,
			"@type": link.Type,
		})
	}
	response["atom:links"] = links

	// Add properties to the response
	for key, property := range resource.Properties {
		response[key] = property
	}

	return response

}
