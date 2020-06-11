// Copyright 2016 Zhang Peihao <zhangpeihao@gmail.com>

package test

import (
	"strings"
	"testing"

	"github.com/zhangpeihao/zim/pkg/app"
	_ "github.com/zhangpeihao/zim/pkg/broker/mock"
	"github.com/zhangpeihao/zim/pkg/broker/register"
)

func TestRouter(t *testing.T) {
	var err error
	// 初始化broker
	if err = register.Init("test"); err != nil {
		t.Fatal("register.Init() error:", err)
	}

	routerMap := app.InfoMap{
		"*": {
			Broker: "mock",
		},
		"login": {
			Broker: "mock",
		},
		"msg": {
			Broker: "mock",
		},
		"logout": {
			Broker: "mock",
		},
	}
	r, err := app.NewRouter(routerMap)
	if err != nil {
		t.Fatalf("NewRouter error: %s\n", err)
	}
	broker := r.Find("msg")
	if broker == nil {
		t.Fatalf("Find(%s) return nil", "msg")
	}

	broker = r.Find("xxx")
	if broker == nil {
		t.Fatalf("Find(%s) return nil", "xxx")
	}

	strs := strings.Split(strings.Trim(r.String(), "\n"), "\n")

	if len(strs) != len(routerMap) {
		t.Errorf("Router string Got:\n%s\n", r.String())
	}

	routerMap = app.InfoMap{
		"login": {
			Broker: "xxx",
		},
	}
	_, err = app.NewRouter(routerMap)
	if err == nil {
		t.Errorf("TestErrorRouter should return error\n")
	}
}
