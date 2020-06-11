// Copyright 2017 Zhang Peihao <zhangpeihao@gmail.com>

// Package register 注册Broker
package register

import (
	"github.com/golang/glog"
	"github.com/zhangpeihao/zim/pkg/broker"
)

// NewBrokerHandler 新建Broker函数，参数：viper参数perfix
type NewBrokerHandler func(string) (broker.Broker, error)

var (
	brokerHandlers = make(map[string]NewBrokerHandler)
)

// Register 注册Broker
func Register(name string, handler NewBrokerHandler) {
	if _, found := brokerHandlers[name]; found {
		glog.Warningf("broker::Register() Broker[%s] existed\n")
	}
	brokerHandlers[name] = handler
}

// Init 初始化
func Init(viperPerfix string) error {
	for name, brokerHandler := range brokerHandlers {
		glog.Infof("broker::Init() Init broker[%s]\n", name)
		b, err := brokerHandler(viperPerfix)
		if err != nil {
			glog.Errorf("broker::Init() init broker[%s] init error: %s", name, err)
			return err
		}
		broker.Set(name, b)
	}
	return nil
}
