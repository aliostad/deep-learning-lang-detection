// Copyright 2016-2017 Zhang Peihao <zhangpeihao@gmail.com>

package app

import (
	"bytes"
	"fmt"

	"github.com/golang/glog"
	"github.com/zhangpeihao/zim/pkg/broker"
	"github.com/zhangpeihao/zim/pkg/define"
)

// Info 最简单的路由信息
type Info struct {
	Broker string `json:"broker"`
	Tag    string `json:"tag"`
}

// InfoMap 最简单的路由信息Map
type InfoMap map[string]Info

// Router 路由
type Router struct {
	defaultBroker broker.Broker
	brokers       map[string]broker.Broker
}

// NewRouter 新建Router
func NewRouter(routerMap InfoMap) (r *Router, err error) {
	r = &Router{
		brokers: make(map[string]broker.Broker),
	}

	for key, routeInfo := range routerMap {
		switch routeInfo.Broker {
		case "httpapi":
			fallthrough
		case "mock":
			if key == "*" {
				if r.defaultBroker = broker.Get(routeInfo.Broker); r.defaultBroker == nil {
					return nil, fmt.Errorf("unsupport default broker: %s", routeInfo.Broker)
				}
			} else {
				if broker := broker.Get(routeInfo.Broker); broker != nil {
					r.brokers[key] = broker
				} else {
					return nil, fmt.Errorf("unsupport broker: %s", routeInfo.Broker)
				}
			}
		default:
			glog.Errorf("router::driver::jsonfile::NewRouter() unsupport protocol %s\n",
				routeInfo.Broker)
			return nil, define.ErrUnsupportProtocol
		}
	}
	return r, nil
}

// Find 查询路由
func (r *Router) Find(name string) broker.Broker {
	glog.Infof("Router::Find(%s)\n", name)
	broker, found := r.brokers[name]
	if !found {
		return r.defaultBroker
	}
	return broker
}

// String 输出
func (r *Router) String() string {
	buf := new(bytes.Buffer)
	if r.defaultBroker != nil {
		buf.WriteString("*: ")
		buf.WriteString(r.defaultBroker.String())
		buf.WriteString("\n")
	}
	for key, broker := range r.brokers {
		buf.WriteString(key)
		buf.WriteString(": ")
		buf.WriteString(broker.String())
		buf.WriteString("\n")
	}
	return string(buf.Bytes())
}
