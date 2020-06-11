// Copyright 2016-2017 Zhang Peihao <zhangpeihao@gmail.com>

// Package broker 异步消息接口
package broker

import (
	"context"
	"time"

	"github.com/golang/glog"
	"github.com/zhangpeihao/zim/pkg/define"
	"github.com/zhangpeihao/zim/pkg/protocol"
)

// Broker 异步消息接口
type Broker interface {
	define.Server
	// Publish 发布消息到消息队列
	Publish(tag string, cmd *protocol.Command) (*protocol.Command, error)
	// Subscribe 从消息队列订阅消息
	Subscribe(tag string, handler SubscribeHandler) error
	// String 串行化输出
	String() string
}

// SubscribeHandler 订阅消息处理函数，返回error，消息将保留在队列中
type SubscribeHandler func(tag string, cmd *protocol.Command) error

var (
	brokers = make(map[string]Broker)
)

// Set 获取Broker
func Set(name string, broker Broker) {
	brokers[name] = broker
}

// Get 获取Broker
func Get(name string) Broker {
	if broker, found := brokers[name]; found {
		return broker
	}
	return nil
}

// Run 运行
func Run(ctx context.Context) (err error) {
	glog.Infoln("broker::define::Run()")
	defer glog.Infoln("broker::define::Run() done")
	for _, broker := range brokers {
		if err = broker.Run(ctx); err != nil {
			glog.Errorln("broker::Run() error:", err)
			break
		}
	}
	return
}

// Close 关闭
func Close(timeout time.Duration) error {
	var err error
	for _, broker := range brokers {
		closeErr := broker.Close(timeout)
		if err == nil {
			err = closeErr
		}
	}
	return err
}
