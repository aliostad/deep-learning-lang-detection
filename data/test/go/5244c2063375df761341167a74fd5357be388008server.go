package handlers

import (
	"fmt"
	"github.com/lanfang/go-lib/log"
	"github.com/lanfang/mysql-river/config"
	"github.com/lanfang/mysql-river/sync"
	"os"
)

var host string

func init() {
	host, _ = os.Hostname()
}

//var broker *sync.SyncClient

type BrokerServer struct {
	Name   string
	Id     string
	broker *sync.SyncClient
}

func (p *BrokerServer) OnMaster(msg string) error {
	log.Info("binglogbroker[%v]switch to master, now start sync binlog, msg:%+v", config.G_Config.BrokerConfig.Group, msg)
	var err error
	p.broker, err = sync.NewSyncClient(&config.G_Config)
	if err != nil {
		log.Info("binglogbroker[%v]switch to master msg:%+v, failed:%+v", config.G_Config.BrokerConfig.Group, msg, err)
		return err
	}
	p.broker.Start()
	Alert(fmt.Sprintf("host[%v], %v.%v switch to master, because of the error:%+v", host, config.SERVERNAME, config.G_Config.BrokerConfig.Group, msg))
	return nil
}

func (p *BrokerServer) OnSlave(msg string) error {
	log.Info("binglogbroker[%v]switch to slave, msg:%+v, now stop sync binlog", config.G_Config.BrokerConfig.Group, msg)
	if p.broker != nil {
		p.broker.Close()
		p.broker = nil
	}
	Alert(fmt.Sprintf("host[%v], %v.%v switch to slave, because of the error:%+v", host, config.SERVERNAME, config.G_Config.BrokerConfig.Group, msg))
	log.Info("binglogbroker[%v]switch to slave, msg:%+v, stop sync binlog succes", config.G_Config.BrokerConfig.Group, msg)
	return nil
}

func (p *BrokerServer) ServerName() string {
	return p.Name
}

func (p *BrokerServer) GroupId() string {
	return p.Id
}

func (p *BrokerServer) Close() {
	if p.broker != nil {
		p.broker.Close()
		p.broker = nil
	}
}

func (p *BrokerServer) IsRunaway() (bool, string) {
	if p.broker != nil {
		is_run, msg := p.broker.IsRunaway()
		return is_run, msg
	}
	log.Info("BrokerServer IsRunaway")
	return true, "no master server"
}

func Alert(msg string) {
	fmt.Printf("%v", msg)
}
