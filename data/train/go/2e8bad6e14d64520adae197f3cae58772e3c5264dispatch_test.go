package dispatch_test

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"runtime"
	"testing"

	"github.com/nbio/st"
	"github.com/ryanfaerman/dispatch"
)

func TestHome(t *testing.T) {
	s := newTestServer(t)
	_, res := s.request("GET", "/")
	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)
	st.Assert(t, string(body), "welcome")
}

func TestBork(t *testing.T) {
	s := newTestServer(t)
	_, res := s.request("GET", "/bork")
	defer res.Body.Close()

	st.Expect(t, res.StatusCode, 404)
}

func TestEcho(t *testing.T) {
	s := newTestServer(t)
	_, res := s.request("GET", "/api/echo/hip-hop")
	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	st.Expect(t, res.Header.Get("X-Awesome"), "awesome")
	st.Expect(t, res.Header.Get("Content-Type"), "application/json")
	st.Expect(t, res.StatusCode, 200)
	st.Expect(t, string(body), "{\"phrase\":\"hip-hop\"}\n")
}

func TestMirror(t *testing.T) {
	s := newTestServer(t)
	_, res := s.request("GET", "/api/mirror/hip-hop")
	defer res.Body.Close()
	body, _ := ioutil.ReadAll(res.Body)

	st.Expect(t, res.Header.Get("X-Awesome"), "awesome")
	st.Expect(t, res.Header.Get("Content-Type"), "application/xml")
	st.Expect(t, res.StatusCode, 200)
	st.Expect(t, string(body), "<map><phrase>hip-hop</phrase></map>")
}

// func TestRedirect(t *testing.T) {
// 	s := newTestServer(t)
// 	_, res := s.request("GET", "/bounce")
// 	defer res.Body.Close()

// 	st.Expect(t, res.StatusCode, 301)
// }

// testServer

type testServer struct {
	*httptest.Server
	t *testing.T
}

func (s *testServer) request(method, path string) (*http.Request, *http.Response) {
	req, err := http.NewRequest(method, s.URL+path, nil)
	if err != nil {
		s.t.Fatal(err)
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		s.t.Fatal(err)
	}
	return req, res
}

func newTestServer(t *testing.T) *testServer {
	r := dispatch.New()
	r.Use(logger)
	r.GET("/", index)
	r.GET("/bork", borked)
	r.GET("/bounce", bouncer)

	api := r.Group("/api", awesome)
	api.GET("/echo/:phrase", echoJSON)
	api.GET("/mirror/:phrase", echoXML)

	s := &testServer{httptest.NewServer(r), t}
	runtime.SetFinalizer(s, func(s *testServer) { s.Server.Close() })
	return s
}

func logger(next http.Handler) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		fmt.Printf("%s %s\n", req.Method, req.URL.String())
		next.ServeHTTP(w, req)
	}
}

func awesome(next http.Handler) http.HandlerFunc {
	return func(w http.ResponseWriter, req *http.Request) {
		w.Header().Set("X-Awesome", "awesome")
		next.ServeHTTP(w, req)
	}
}

func index(w http.ResponseWriter, r *http.Request) {
	dispatch.Response(w).String(200, "welcome")
}

func bouncer(w http.ResponseWriter, r *http.Request) {
	dispatch.Response(w).Redirect(301, "http://example.com")
}

func echoJSON(w http.ResponseWriter, req *http.Request) {
	phrase := dispatch.Params(req).ByName("phrase")
	dispatch.Response(w).JSON(200, dispatch.H{"phrase": phrase})
}

func echoXML(w http.ResponseWriter, req *http.Request) {
	phrase := dispatch.Params(req).ByName("phrase")
	dispatch.Response(w).XML(200, dispatch.H{"phrase": phrase})
}

func borked(w http.ResponseWriter, r *http.Request) {
	dispatch.Response(w).NotFound()
}
