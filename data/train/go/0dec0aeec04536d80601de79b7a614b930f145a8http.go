package http

import (
	"net"
	"net/http"
	"time"

	"github.com/abrander/alerto/plugins"
)

func init() {
	plugins.Register("http", NewHttp)
}

func NewHttp() plugins.Plugin {
	return new(Http)
}

type (
	Http struct {
		Url string `json:"url" description:"The URL to request"`
	}

	instrumentTransport struct {
		rtp       http.RoundTripper
		dialer    func(network, addr string) (net.Conn, error)
		connStart time.Time
		connEnd   time.Time
		reqStart  time.Time
		reqEnd    time.Time
	}
)

func (h Http) GetInfo() plugins.HumanInfo {
	return plugins.HumanInfo{
		Name:        "http",
		Description: "Check response from http and https servers",
	}
}

func newTransport(dialer func(network, addr string) (net.Conn, error)) *instrumentTransport {
	tr := &instrumentTransport{
		dialer: dialer,
	}

	tr.rtp = &http.Transport{
		Proxy:               http.ProxyFromEnvironment,
		Dial:                tr.dial,
		TLSHandshakeTimeout: 10 * time.Second,
	}

	return tr
}

func (tr *instrumentTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	tr.reqStart = time.Now()
	resp, err := tr.rtp.RoundTrip(r)
	tr.reqEnd = time.Now()

	return resp, err
}

func (tr *instrumentTransport) dial(network, addr string) (net.Conn, error) {
	tr.connStart = time.Now()
	cn, err := tr.dialer(network, addr)
	tr.connEnd = time.Now()

	return cn, err
}

func (tr *instrumentTransport) RequestDuration() time.Duration {
	return tr.Duration() - tr.ConnectDuration()
}

func (tr *instrumentTransport) ConnectDuration() time.Duration {
	return tr.connEnd.Sub(tr.connStart)
}

func (tr *instrumentTransport) Duration() time.Duration {
	return tr.reqEnd.Sub(tr.reqStart)
}

func (h *Http) Run(transport plugins.Transport, request plugins.Request) plugins.Result {
	start := time.Now()

	tr := newTransport(transport.Dial)
	client := &http.Client{Transport: tr}
	resp, err := client.Get(h.Url)
	if err != nil {
		return plugins.NewResult(plugins.Failed, plugins.NewMeasurementCollection("time", time.Now().Sub(start)), err.Error())
	}
	defer resp.Body.Close()

	c := plugins.NewMeasurementCollection(
		"status", resp.StatusCode,
		"time", tr.Duration(),
		"connectDuration", tr.ConnectDuration(),
		"requestDuration", tr.RequestDuration(),
	)

	return plugins.NewResult(plugins.Ok, c, "returned %d", resp.StatusCode)
}

// Ensure compliance
var _ plugins.Agent = (*Http)(nil)
