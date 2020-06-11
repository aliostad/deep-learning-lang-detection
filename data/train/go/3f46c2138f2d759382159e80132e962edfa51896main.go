/*
    Package main is the entry point for the RPC Server that hosts the 
    instrument provider API.
*/
package main


import (    
    "net/http"

    "github.com/elusive/instrument-api/server/service"
    "github.com/elusive/instrument-api/server/svclog"
    "v.io/x/lib/vlog"
)

const listeningPort string = ":8080"

func main() {
    svclog.Start()

    router := service.Register()

    vlog.Info("Starting RPC Server for Instrument API on port ", listeningPort)
    http.ListenAndServe(listeningPort, router)
}

