package middleware

import (
	"github.com/boario/boar-go/instrument"
	"github.com/labstack/echo"
)

func NewEchoRequest(c echo.Context) instrument.Request {
	req := instrument.NewRequest(c.Request().Host, c.Request().URL.RequestURI(), c.Path(), c.Request().Method, c.QueryParams())

	return req
}

func ExtractHeader(c echo.Context, header string) (str string) {
	head := c.Request().Header[header]
	if len(head) > 0 {
		str = head[0]
	}
	return
}

func InstrumentMiddleware(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		req := NewEchoRequest(c)
		tr := instrument.NewTracer(nil, "handle_request.echo", "")
		c.Set("Tracer", tr)
		err := next(c)
		tr.Stop()
		req.Stop(tr, ExtractHeader(c, "X-Request-Id"), ExtractHeader(c, "X-Hop-Count"), c.Response().Status, c.Request().Header)
		// b, _ := json.Marshal(req)
		// log.Printf("%s", string(b))
		return err
	}
}
