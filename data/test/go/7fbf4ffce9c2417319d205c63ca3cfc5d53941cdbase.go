package handlers

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/snickers54/microservices/gateway/context"
	"github.com/snickers54/microservices/gateway/middlewares"
	"github.com/spf13/viper"
)

func statsHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	subRouter.GET("/stats", statsSummarize)
}

func clusterHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	subRouter.GET("/cluster", clusterDescribe)
	subRouter.POST("/cluster/nodes", middlewares.Sync, middlewares.CloseBody, clusterRegister)
}

func servicesHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	subRouter.GET("/services", servicesDescribe)
	subRouter.POST("/services", servicesRegister, middlewares.Sync, middlewares.CloseBody)
}

func routesHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	subRouter.POST("/routes", routeRegister)
}

func dispatchHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	patternDispatch := "/api/{path:.*}"
	replayMiddlewares := []context.AppHandler{
		dispatchToService,
		middlewares.WriteReplay,
		middlewares.CloseBody,
		middlewares.StatsReplay,
	}
	subRouter.GET(patternDispatch, replayMiddlewares...)
	subRouter.POST(patternDispatch, replayMiddlewares...)
	subRouter.PUT(patternDispatch, replayMiddlewares...)
	subRouter.DELETE(patternDispatch, replayMiddlewares...)
}

func baseHandlers(router *mux.Router) {
	subRouter := NewGSubRouter(router)
	subRouter.GET("/healthcheck", nodePing)
}

func Start() {
	router := mux.NewRouter()
	router.StrictSlash(false)

	baseHandlers(router)
	statsHandlers(router)
	clusterHandlers(router)
	servicesHandlers(router)
	dispatchHandlers(router)
	routesHandlers(router)
	log.Fatal(http.ListenAndServe(":"+viper.GetString("node.port"), router))
}
