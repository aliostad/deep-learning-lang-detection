// Restish Dispatcher. A Restish Controller is a Dispatcher, used to dispatch Resources to the appropriate action handler
// The four standard actions are the usual CRUD methods create, read, update and delete. Each action will be dispatched
// to the corresponding controller function.
package restish

// Dispatchers are used to handle Resources. They take a Resource as input and return a processed Resource.
type Dispatcher interface {
	// Dispatches a Resource using the Action string. Returns a resource
	Request(*Resource, string) (*Resource, StatusCode)
}

type Dispatch struct {
	Controller
}

// Dispatch the resource to the action controller function.
func (handler *Dispatch) Request(resource *Resource, action string) (*Resource, StatusCode) {
	handledResource := resource
	status := StatusBadRequest

	switch {
	case ActionCreate == action:
		handledResource, status = handler.Create(resource)
	case ActionRead == action:
		handledResource, status = handler.Read(resource)
	case ActionUpdate == action:
		handledResource, status = handler.Update(resource)
	case ActionDelete == action:
		handledResource, status = handler.Delete(resource)
	}

	return handledResource, status
}
