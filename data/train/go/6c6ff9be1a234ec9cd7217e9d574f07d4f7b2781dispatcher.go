package command

// Dispatcher defines the interface for a command dispatcher.
type Dispatcher interface {
	// Dispatch dispatches the given command to all known handlers.
	//
	// If no handler returns `true` for `CanHandle` call it will return a
	// `NoHandlerFoundError`.
	Dispatch(cmd interface{}) error

	// DispatchOptional works the same way as `Dispatch` but it will not return an
	// error if all handler's `CanHandle` call returns `false`.
	DispatchOptional(cmd interface{}) error

	// AppendHandlers append the given handler to the list of known handlers.
	//
	// This is useful if you want to add more handler after creating a dispatcher.
	AppendHandlers(handlers ...Handler)
}
