package main

import (
	"log"
	"socketio_server/router"
	"testing"
)

func init() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
}

func TestRouter(t *testing.T) {
	r := router.GetRouter()
	ctx := &router.Context{
		nil,
		map[string]string{},
	}
	rh := r.AddRouter("/:name-:tel", func(ctx *router.Context) {
		if ctx.Params["name"] != "tom" || ctx.Params["tel"] != "123" {
			t.Errorf("add router: tom-123 failed, %s\n", ctx.Params)
		} else {
			t.Log("sucess:", ctx.Params)
		}
	})
	log.Printf("add /:name-:tel | %v", rh)

	rh = r.AddRouterMethod("/", "Get", func(ctx *router.Context) {
		t.Log("sucess: /", ctx.Params)
	})
	log.Printf("add /| %v", rh)

	rh = r.AddRouterMethod("/:name/:addr", "Post", func(ctx *router.Context) {
		if ctx.Params["name"] != "Jame" || ctx.Params["addr"] != "yufei" {
			t.Errorf("add router: Jame/yufei failed, %s\n", ctx.Params)
		} else {
			t.Log("sucess:", ctx.Params)
		}
	})
	log.Printf("add /:name/:addr | %v", rh)

	rh = r.AddRouter("/chat_room/:room.:user", func(ctx *router.Context) {
		if ctx.Params["room"] != "1" || ctx.Params["user"] != "2" {
			t.Errorf("add router: /:room.:user failed, %s\n", ctx.Params)
		} else {
			t.Log("sucess:", ctx.Params)
		}
	})
	log.Printf("add /:room.:user | %v", rh)

	rh = r.AddRouterMethod("/javascript/:subpath", "get", func(ctx *router.Context) {
		if ctx.Params["subpath"] != "a" {
			t.Errorf("add router: /javascript/:subpath failed, %s\n", ctx.Params)
		} else {
			t.Log("sucess:", ctx.Params)
		}
	})
	log.Printf("add /javascript/:subpath | %v", rh)

	err := r.Dispatch(ctx, "/tom-123", "")
	if err != nil {
		t.Errorf("Dispatch tom-123 failed: %v\n", err)
	}
	err = r.Dispatch(ctx, "/", "get")
	if err != nil {
		t.Errorf("Dispatch / failed: %v\n", err)
	}
	err = r.Dispatch(ctx, "/", "post")
	if err == nil {
		t.Errorf("Dispatch post / should failed \n")
	} else {
		t.Log("success: Dispatch post / should failed:", err)
	}
	err = r.Dispatch(ctx, "/Jame/yufei", "post")
	if err != nil {
		t.Errorf("Dispatch Jame/yufei failed: %v\n", err)
	}
	err = r.Dispatch(ctx, "/chat_room/1.2", "")
	if err != nil {
		t.Errorf("Dispatch /chat_room/1.2 failed: %v\n", err)
	}
	err = r.Dispatch(ctx, "/javascript/a/b", "get")
	if err != nil {
		t.Errorf("Dispatch /javascript/a/b failed: %v\n", err)
	}
	err = r.Dispatch(ctx, "/someelse/javascript/a/b", "get")
	if err == nil {
		t.Errorf("Dispatch /someelse/javascript/a/b should failed\n")
	} else {
		t.Log("sucess: /someelse/javascript/a/b should failed:", err)
	}
}
