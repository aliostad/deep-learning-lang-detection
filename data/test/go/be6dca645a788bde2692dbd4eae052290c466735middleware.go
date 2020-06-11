package luddite

import "net/http"

type middleware struct {
	handler Handler
	next    *middleware
}

func (m *middleware) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	m.handler.HandleHTTP(NewResponseWriter(rw), req, m.next.dispatchHandler)
}

func (m *middleware) dispatchHandler(rw http.ResponseWriter, req *http.Request) {
	m.handler.HandleHTTP(rw, req, m.next.dispatchHandler)
}

func voidMiddleware() *middleware {
	return &middleware{
		handler: HandlerFunc(func(rw http.ResponseWriter, req *http.Request, next http.HandlerFunc) {}),
		next:    &middleware{},
	}
}

func buildMiddleware(handlers []Handler) *middleware {
	var next *middleware

	if len(handlers) == 0 {
		return voidMiddleware()
	} else if len(handlers) > 1 {
		next = buildMiddleware(handlers[1:])
	} else {
		next = voidMiddleware()
	}

	return &middleware{handlers[0], next}
}
