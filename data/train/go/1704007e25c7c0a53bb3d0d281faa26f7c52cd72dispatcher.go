package gognar

import (
	"net/http"
)

// DispatchHandler is a stack of Middleware Handlers that can be invoked as an http.Handler.
// Middleware are evaluated in the order that they are added to the stack.
type DispatchHandler struct {
	stack []func(next http.HandlerFunc) http.HandlerFunc
	final http.HandlerFunc
}

// Attach adds a Handler onto the middleware stack. Handlers are invoked in the order they are added to the DispatchHandler
func (h *DispatchHandler) Attach(middleware ...func(http.HandlerFunc) http.HandlerFunc) {
	h.stack = append(h.stack, middleware...)
}

// Attach the last Handler (controller) and it wrap it in a HandlerFunc.
func (h *DispatchHandler) Finalize(final http.HandlerFunc) {
	h.final = final
	for i := len(h.stack); i > 0; i-- {
		h.final = h.stack[i-1](h.final)
	}
}

func (h DispatchHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	h.final(w, r)
}
