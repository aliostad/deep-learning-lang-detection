// Copyright (C) 2015 SPEEDLAND Project

package wcg

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func dispatch(router *Router, method string, path string) ([]*Route, *Response, *Request) {
	w := httptest.NewRecorder()
	r, _ := http.NewRequest(method, "http://example.com"+path, nil)
	req := NewRequest(r)
	res := NewResponse(w, req)
	// rq.EnableTrace = true
	return router.Dispatch(res, req), res, req
}

func TestRouter(t *testing.T) {
	var router *Router
	var matched []*Route

	handler := AnonymousHandler(func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	})

	stopHandler := AnonymousHandler(func(res *Response, req *Request) {
		res.Close()
	})

	// Simple Routing
	router = NewRouter()
	router.GET("/", handler)

	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[Simple Routing] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}

	// multiple routes.
	router = NewRouter()
	router.GET("/", handler)
	router.GET("/", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 2 {
		t.Errorf("[Multiple Routes] Dispatch should return %d routes, but got %d routes.", 2, len(matched))
	}

	// stop routing
	router = NewRouter()
	router.GET("/", stopHandler)
	router.GET("/", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[Stop Routing] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}

	matched, _, _ = dispatch(router, "GET", "/foo")
	if len(matched) != 0 {
		t.Errorf("[NotFound] Dispatch should return no routes, but got %d routes.", len(matched))
	}

	// middleware routes.
	beforeCalled := false
	afterCalled := false
	router = NewRouter()
	router.Before(stopHandler)
	router.Before(AnonymousHandler(func(*Response, *Request) { beforeCalled = true }))
	router.GET("/", handler)
	router.After(AnonymousHandler(func(*Response, *Request) { afterCalled = true }))

	dispatch(router, "GET", "/")
	if !beforeCalled {
		t.Errorf("[Before Middleware] beforeCalled should be true, but still false")
	}
	if !afterCalled {
		t.Errorf("[After Middleware] aftercalled should be true, but still false")
	}
}

func TestRouterNotFound(t *testing.T) {
	var router *Router
	router = NewRouter()
	// Default
	_, res, _ := dispatch(router, "GET", "/")
	if res.StatusCode != 404 {
		t.Errorf("[Not Found] status should be 404, but got %d", res.StatusCode)
	}

	router = NewRouter()
	router.NotFound = AnonymousHandler(func(res *Response, req *Request) {
		res.Redirect("/foo", 301)
	})
	_, res, _ = dispatch(router, "GET", "/")
	if res.StatusCode != 301 {
		t.Errorf("[Not Found as Redirect] status should be 301, but got %d", res.StatusCode)
	}
	if res.Header().Get("Location") != "/foo" {
		t.Errorf("[Not Found as Redirect] Location value be 'http://example.com/foo', but got %s", res.Header().Get("Location"))
	}
}

func TestRouterWithSomethingParameter(t *testing.T) {
	var assert = NewAssert(t)
	var router *Router
	var matched []*Route

	handler := AnonymousHandler(func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	})

	router = NewRouter()
	router.GET("/:foo", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	assert.EqInt(0, len(matched))

	matched, _, req := dispatch(router, "GET", "/aa")
	assert.EqInt(1, len(matched))
	assert.EqStr("aa", req.Param("foo"))

	matched, _, req = dispatch(router, "GET", "/http%253A%252F%252Fwww.google.com%252F")
	assert.EqInt(1, len(matched))
	assert.EqStr("http://www.google.com/", req.Param("foo"))

	router = NewRouter()
	router.GET("/:foo.html", handler)
	matched, _, req = dispatch(router, "GET", "/aa.html")
	assert.EqInt(1, len(matched))
	assert.EqStr("aa", req.Param("foo"))

	matched, _, _ = dispatch(router, "GET", "/aa.txt")
	assert.EqInt(0, len(matched))

	router = NewRouter()
	router.GET("/:foo/:bar.html", handler)
	matched, _, req = dispatch(router, "GET", "/aa/bb.html")
	assert.EqInt(1, len(matched))
	assert.EqStr("aa", req.Param("foo"))
	assert.EqStr("bb", req.Param("bar"))
}

func TestRouterWithAnythingParameter(t *testing.T) {
	var router *Router
	var matched []*Route

	handler := AnonymousHandler(func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	})

	router = NewRouter()
	router.GET("/*foo", handler)
	matched, _, req := dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[/*foo - GET /] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
	if req.Param("foo") != "" {
		t.Errorf("[/*foo - GET /] req.Param(\"foo\") should return '', but got %s", req.Param("foo"))
	}

	matched, _, req = dispatch(router, "GET", "/bar")
	if len(matched) != 1 {
		t.Errorf("[/*foo - GET /bar] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
	if req.Param("foo") != "bar" {
		t.Errorf("[/*foo - GET /bar] req.Param(\"foo\") should return 'bar', but got %s", req.Param("foo"))
	}

	// no variable name
	router = NewRouter()
	router.GET("/*", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[/* - GET /] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
}
