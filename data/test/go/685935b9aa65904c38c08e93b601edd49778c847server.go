// Package app contains the broker server application.
package app

import (
	"github.com/emicklei/go-restful"
	"github.com/hkra/majordomo/cmd/broker/app/options"
	"github.com/hkra/majordomo/pkg/apiserver"
)

// BrokerServer is the command broker API server.
type BrokerServer struct {
	apiserver *apiserver.APIServer
}

func configureAPIServer(options *options.Options) *apiserver.Config {
	c := &apiserver.Config{
		Name:        "command broker",
		Port:        options.Port,
		BindAddress: options.BindAddress,
		UseTLS:      options.UseTLS,
	}
	return c
}

// New makes a new BrokerServer.
func New(options *options.Options) *BrokerServer {
	b := BrokerServer{
		apiserver: apiserver.New(configureAPIServer(options)),
	}
	b.apiserver.RegisterHandlers(registerHandlers)
	return &b
}

// Start runs the server and starts listening.
func (s *BrokerServer) Start() {
	s.apiserver.Start()
}

func registerHandlers(ws *restful.WebService) {
	ws.Route(ws.GET("/").To(testRoute))
}

func testRoute(request *restful.Request, response *restful.Response) {
	response.Write([]byte("Hello, server world!"))
}
