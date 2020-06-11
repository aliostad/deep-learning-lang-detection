package main

import (
	"github.com/yarf-framework/yarf"
)

// HelloMiddleware is compositing yarf.Middleware
type HelloMiddleware struct {
	yarf.Middleware
}

// PreDispatch renders a hardcoded string
func (m *HelloMiddleware) PreDispatch(c *yarf.Context) error {
	c.Render("Hello from middleware! \n\n")

	return nil
}

// PostDispatch includes code to be executed after every Resource request.
func (m *HelloMiddleware) PostDispatch(c *yarf.Context) error {
	c.Render("\n\nGoodbye from middleware!")

	return nil
}
