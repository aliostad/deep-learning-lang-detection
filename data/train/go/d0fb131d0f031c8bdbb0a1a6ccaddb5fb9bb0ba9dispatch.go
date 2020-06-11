// Task dispatcher.
package whitetree

// Dispatch a task.
func Dispatch(taskCtx TaskContext, parsers ParserPackage, handlers HandlerPackage) error {
	for _, parser := range parsers {
		handlerId, err := parser(taskCtx)

		// Parse successfully.
		if err == nil {
			handler, present := handlers[handlerId]
			// Try other parsers.
			if !present {
				continue
			}

			return handler(taskCtx)
		}
		// Try next parser.
		if err == ErrUnableToParse {
			continue
		}
		// Otherwise, something bad happened.
		return err
	}

	// No handler found.
	return ErrHandlerNotFound
}
