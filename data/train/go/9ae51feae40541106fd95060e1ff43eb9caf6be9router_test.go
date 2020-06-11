//
// The application that does not use this middleware, Request.Session is alwasy nil.
//
// Copyright (C) 2014 Yohei Sasaki
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

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

	handler := func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	}

	stopHandler := func(res *Response, req *Request) {
		res.Close()
	}

	// Simple Routing
	router = NewRouter()
	router.Get("/", handler)

	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[Simple Routing] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}

	// multiple routes.
	router = NewRouter()
	router.Get("/", handler)
	router.Get("/", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 2 {
		t.Errorf("[Multiple Routes] Dispatch should return %d routes, but got %d routes.", 2, len(matched))
	}

	// stop routing
	router = NewRouter()
	router.Get("/", stopHandler)
	router.Get("/", handler)
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
	router.Before(func(*Response, *Request) { beforeCalled = true })
	router.Get("/", handler)
	router.After(func(*Response, *Request) { afterCalled = true })

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
	router.NotFound(func(res *Response, req *Request) {
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
	var router *Router
	var matched []*Route

	handler := func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	}

	router = NewRouter()
	router.Get("/:foo", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 0 {
		t.Errorf("[/:foo - GET /] Dispatch should return no routes, but got %d routes.", len(matched))
	}

	matched, _, req := dispatch(router, "GET", "/aa")
	if len(matched) != 1 {
		t.Errorf("[/:foo - GET /aa] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
	if req.Param("foo") != "aa" {
		t.Errorf("[/:foo - GET /aa] req.Param(\"foo\") should return 'aa', but got %s", req.Param("foo"))
	}

	router = NewRouter()
	router.Get("/:foo.html", handler)
	matched, _, req = dispatch(router, "GET", "/aa.html")
	if len(matched) != 1 {
		t.Errorf("[/:foo.html - GET /aa.html] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
	if req.Param("foo") != "aa" {
		t.Errorf("[/:foo.html - GET /aa.html] req.Param(\"foo\") should return 'aa', but got %s", req.Param("foo"))
	}
	matched, _, _ = dispatch(router, "GET", "/aa.txt")
	if len(matched) != 0 {
		t.Errorf("[/:foo.html - GET /aa.txt] Dispatch should return no routes, , but got %d routes.", 1, len(matched))
	}

	router = NewRouter()
	router.Get("/:foo/:bar.html", handler)
	matched, _, req = dispatch(router, "GET", "/aa/bb.html")
	if len(matched) != 1 {
		t.Errorf("[/:foo/:bar.html - GET /aa/bb.html] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
	if req.Param("foo") != "aa" {
		t.Errorf("[/:foo/:bar.html - GET /aa/bb.html] req.Param(\"foo\") should return 'aa', but got %s", req.Param("foo"))
	}
	if req.Param("bar") != "bb" {
		t.Errorf("[/:foo/:bar.html - GET /aa/bb.html] req.Param(\"bar\") should return 'bb', but got %s", req.Param("bar"))
	}

}

func TestRouterWithAnythingParameter(t *testing.T) {
	var router *Router
	var matched []*Route

	handler := func(res *Response, req *Request) {
		res.WriteString("Hello World\n")
	}

	router = NewRouter()
	router.Get("/*foo", handler)
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
	router.Get("/*", handler)
	matched, _, _ = dispatch(router, "GET", "/")
	if len(matched) != 1 {
		t.Errorf("[/* - GET /] Dispatch should return %d routes, but got %d routes.", 1, len(matched))
	}
}
