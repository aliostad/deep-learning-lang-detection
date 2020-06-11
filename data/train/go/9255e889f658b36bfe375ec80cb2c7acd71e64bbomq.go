package main

import (
	"net"
	"os/signal"
	"syscall"

	"os"

	log "github.com/astaxie/beego/logs"
	"github.com/ohmq/ohmyqueue/broker"
	"github.com/ohmq/ohmyqueue/clientrpc"
	"github.com/ohmq/ohmyqueue/config"
	"github.com/ohmq/ohmyqueue/inrpc"
	"github.com/ohmq/ohmyqueue/server"
	"google.golang.org/grpc"
)

func main() {
	broker := broker.NewBroker(config.Conf.Omq.Index, config.Conf.Omq.Clientport, config.Conf.Omq.Innerport)
	go broker.Start()
	lis, err := net.Listen("tcp", ":"+config.Conf.Omq.Clientport)
	if err != nil {
		log.Error(err)
		os.Exit(1)
	}
	s := grpc.NewServer()
	clientrpc.RegisterOmqServer(s, &server.RpcServer{Broker: broker})
	go s.Serve(lis)
	lis2, err := net.Listen("tcp", ":"+config.Conf.Omq.Innerport)
	if err != nil {
		log.Error(err)
		os.Exit(1)
	}
	s2 := grpc.NewServer()
	inrpc.RegisterInServer(s2, &server.InrpcServer{Broker: broker})
	go s2.Serve(lis2)
	sigch := make(chan os.Signal)
	signal.Notify(sigch, syscall.SIGTERM, syscall.SIGINT, syscall.SIGKILL)
	<-sigch
	broker.Stop()
}
