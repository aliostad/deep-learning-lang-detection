// Copyright 2017 Zhang Peihao <zhangpeihao@gmail.com>

// Package mock 模拟Broker，用于测试
package mock

import (
	"context"
	"fmt"
	"time"

	"github.com/golang/glog"
	"github.com/zhangpeihao/zim/pkg/broker"
	"github.com/zhangpeihao/zim/pkg/broker/register"
	"github.com/zhangpeihao/zim/pkg/protocol"
)

// BrokerImpl Mock broker实现
type BrokerImpl struct {
}

var (
	// PublishMockHandler Publish模拟回调函数
	PublishMockHandler = make(map[string]func(string, *protocol.Command) (*protocol.Command, error))
	// SubscribeMockHandler Subscribe模拟回调函数，在函数中适当Sleep
	SubscribeMockHandler func(string) (*protocol.Command, error)
)

func init() {
	register.Register("mock", NewMockBroker)
}

// NewMockBroker 新建Mock broker
func NewMockBroker(viperPerfix string) (broker.Broker, error) {
	return &BrokerImpl{}, nil
}

// Publish 发布
func (b *BrokerImpl) Publish(tag string, cmd *protocol.Command) (*protocol.Command, error) {
	glog.Infof("broker::mock::Publish(%s)%s\n", tag, cmd)
	handler, found := PublishMockHandler[tag]
	if !found {
		glog.Warningf("broker::mock::Publish(%s) no handler!\n", tag)
		return nil, fmt.Errorf("not find publish handler for tag %s", tag)
	}

	return handler(tag, cmd)
}

// Subscribe 订阅
func (b *BrokerImpl) Subscribe(tag string, handler broker.SubscribeHandler) error {
	glog.Infof("broker::mock::Subscribe(%s)\n", tag)
	if SubscribeMockHandler == nil {
		return fmt.Errorf("SubscribeMockHandler not set")
	}
	for {
		cmd, err := SubscribeMockHandler(tag)
		if err != nil {
			glog.Warningf("broker::mock::Subscribe(%s) SubscribeMockHandler return %s!\n", tag, err)
			return err
		}
		if err = handler(tag, cmd); err != nil {
			glog.Warningf("broker::mock::Subscribe(%s) handler return %s!\n", tag, err)
			return err
		}
	}
}

// Run 运行
func (b *BrokerImpl) Run(ctx context.Context) error {
	return nil
}

// Close 关闭
func (b *BrokerImpl) Close(timeout time.Duration) error {
	return nil
}

// String 发布
func (b *BrokerImpl) String() string {
	return "mock"
}
