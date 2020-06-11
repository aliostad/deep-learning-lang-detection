package router

import (
	"testing"

	. "github.com/smartystreets/goconvey/convey"
)

func TestRouter(t *testing.T) {

	Convey("Given non-regex routes", t, func() {
		router := New()
		router.Get("read", "/articles/:name")
		router.Compile()

		route, params := router.Dispatch("GET", "/articles/article-title")
		_, params2 := router.Dispatch("GET", "/articles/10")
		route3, params3 := router.Dispatch("GET", "/photos/10")

		Convey("It should return named parameters", func() {
			So(params, ShouldNotBeNil)
			So(params2, ShouldNotBeNil)
			So(params["name"], ShouldEqual, "article-title")
			So(params2["name"], ShouldEqual, 10)
		})

		Convey("It should return the route name", func() {
			So(route.Name, ShouldEqual, "read")
		})

		Convey("It should fail when the route doesn't match", func() {
			So(route3, ShouldBeNil)
			So(params3, ShouldBeNil)
		})

		Convey("It should return the extension in the params", func() {
			So(params["ext"], ShouldNotBeNil)
			So(params["ext"], ShouldEqual, "")
		})
	})

	Convey("Given regex routes", t, func() {
		router := New()
		router.Get("read", "/articles/:id([0-9]+)")
		router.Get("title", "/articles/bla/:title([a-z0-9-]+)")
		router.Get("users", "/users/:id([0-9]+)")
		router.Get("readable_int", "/readable/:id(int)")
		router.Get("readable_alpha", "/readable/a/:name(alpha)")
		router.Get("readable_slug", "/readable/s/:name(slug)")
		router.Get("readable_alphanumeric", "/readable/an/:name(alphanumeric)")
		router.Get("readable_md5", "/readable/md5/:hash(md5)")
		router.Get("readable_mongo", "/readable/mongo/:id(mongo)")
		router.Compile()

		Convey("It should match the correct route", func() {
			route, _ := router.Dispatch("GET", "/articles/bla/my-title")
			So(route.Name, ShouldEqual, "title")
		})

		Convey("It should return named parameters", func() {
			route, params := router.Dispatch("GET", "/articles/bla/my-title")

			So(route.Name, ShouldEqual, "title")
			// So(params, ShouldEqual, "")
			So(params["title"], ShouldEqual, "my-title")
		})

		Convey("It should accept and match human-readable route-definitions", func() {
			route, params := router.Dispatch("GET", "/readable/10")
			So(route.Name, ShouldEqual, "readable_int")
			So(params["id"], ShouldEqual, 10)

			route, params = router.Dispatch("GET", "/readable/a/abc")
			So(route.Name, ShouldEqual, "readable_alpha")
			So(params["name"], ShouldEqual, "abc")

			route, _ = router.Dispatch("GET", "/readable/a/a-b-c")
			So(route, ShouldBeNil)

			route, _ = router.Dispatch("GET", "/readable/a/a123")
			So(route, ShouldBeNil)

			route, params = router.Dispatch("GET", "/readable/s/a-b-c")
			So(route.Name, ShouldEqual, "readable_slug")
			So(params["name"], ShouldEqual, "a-b-c")

			route, params = router.Dispatch("GET", "/readable/s/abc")
			So(route.Name, ShouldEqual, "readable_slug")
			So(params["name"], ShouldEqual, "abc")

			route, params = router.Dispatch("GET", "/readable/an/abc123")
			So(route.Name, ShouldEqual, "readable_alphanumeric")
			So(params["name"], ShouldEqual, "abc123")

			route, params = router.Dispatch("GET", "/readable/an/abc")
			So(route.Name, ShouldEqual, "readable_alphanumeric")
			So(params["name"], ShouldEqual, "abc")

			route, params = router.Dispatch("GET", "/readable/an/123")
			So(route.Name, ShouldEqual, "readable_alphanumeric")
			So(params["name"], ShouldEqual, 123)

			route, _ = router.Dispatch("GET", "/readable/an/abc-123")
			So(route, ShouldBeNil)

			route, params = router.Dispatch("GET", "/readable/md5/49f68a5c8493ec2c0bf489821c21fc3b")
			So(route.Name, ShouldEqual, "readable_md5")
			So(params["hash"], ShouldEqual, "49f68a5c8493ec2c0bf489821c21fc3b")

			route, params = router.Dispatch("GET", "/readable/mongo/52ae7a391db36bc0ff000001")
			So(route.Name, ShouldEqual, "readable_mongo")
			So(params["id"], ShouldEqual, "52ae7a391db36bc0ff000001")
		})

		Convey("It should fail when the route doesn't match", func() {
			route, params := router.Dispatch("GET", "/users/john")

			So(route, ShouldBeNil)
			So(params, ShouldBeNil)
		})

	})

	Convey("Given route definitions", t, func() {
		router := New()
		router.Get("read", "/articles/:id([0-9]+)")
		router.Compile()

		Convey("It should convert numeric parameters to int types", func() {
			_, params := router.Dispatch("GET", "/articles/25")

			So(params["id"], ShouldEqual, 25)
			So(params["id"], ShouldHaveSameTypeAs, 0)
		})

		Convey("It should return the route object matched", func() {
			route, _ := router.Dispatch("GET", "/articles/25")

			So(route, ShouldNotBeNil)
			So(route, ShouldHaveSameTypeAs, router.Get("bla_name", "/test/bla"))
		})
	})

	Convey("Given a route name", t, func() {
		router := New()
		router.Get("read", "/articles/:section/:id/:slug")
		router.Compile()

		Convey("It should generate route URL", func() {
			url := router.URL("read", "section", "entertainment", "id", 10, "slug", "a-b-c")

			So(url, ShouldEqual, "/articles/entertainment/10/a-b-c")
		})

	})

	Convey("Given identical routes defined for GET, POST, PUT, and DELETE method types", t, func() {
		router := New()
		router.Get("find_all", "/articles")
		router.Get("read", "/articles/:id(int)")
		router.Post("create", "/articles")
		router.Put("update", "/articles/:id(int)")
		router.Delete("delete", "/articles/:id(int)")
		router.Compile()

		Convey("It should match routes that match the request method", func() {
			route, _ := router.Dispatch("GET", "/articles/10")
			So(route.Name, ShouldEqual, "read")

			route, _ = router.Dispatch("POST", "/articles")
			So(route.Name, ShouldEqual, "create")

			route, _ = router.Dispatch("PUT", "/articles/10")
			So(route.Name, ShouldEqual, "update")

			route, _ = router.Dispatch("DELETE", "/articles/10")
			So(route.Name, ShouldEqual, "delete")

			route, _ = router.Dispatch("GET", "/articles")
			So(route.Name, ShouldEqual, "find_all")
		})
	})

	Convey("Given a router with valid extensions of none, json, and csv", t, func() {
		router := New()
		router.ValidExtensions("", "json", "csv")
		router.Get("read", "/articles/:id(int)")
		router.Compile()

		Convey("It should only accept requests matching those extensions", func() {
			route, params := router.Dispatch("GET", "/articles/10.json")
			So(route, ShouldNotBeNil)
			So(route.Name, ShouldEqual, "read")
			So(params["id"], ShouldEqual, 10)

			route, params = router.Dispatch("GET", "/articles/10.csv")
			So(route, ShouldNotBeNil)
			So(route.Name, ShouldEqual, "read")
			So(params["id"], ShouldEqual, 10)

			route, params = router.Dispatch("GET", "/articles/10")
			So(route, ShouldNotBeNil)
			So(route.Name, ShouldEqual, "read")
			So(params["id"], ShouldEqual, 10)

			route, _ = router.Dispatch("GET", "/articles/10.xml")
			So(route, ShouldBeNil)
		})

		Convey("It should return the extension in the params", func() {
			_, params := router.Dispatch("GET", "/articles/10.json")
			So(params["ext"], ShouldEqual, "json")

			_, params = router.Dispatch("GET", "/articles/10.csv")
			So(params["ext"], ShouldEqual, "csv")

			_, params = router.Dispatch("GET", "/articles/10")
			So(params["ext"], ShouldEqual, "")
		})

	})

	Convey("Given a group definition", t, func() {
		router := New()
		router.Group("/articles", "articles", func(r *Router) {
			r.Get("read", "/:id(int)")
			r.Get("section", "/:section(slug)/:id(int)")
			r.Get("mongo", "/:id(mongo)")
		})
		router.Compile()

		Convey("It should return matched route name and named parameters", func() {
			route, params := router.Dispatch("GET", "/articles/10")
			So(route.Name, ShouldEqual, "articles_read")
			So(params["id"], ShouldEqual, 10)

			route, params = router.Dispatch("GET", "/articles/entertainment/10")
			So(route.Name, ShouldEqual, "articles_section")
			So(params["section"], ShouldEqual, "entertainment")
			So(params["id"], ShouldEqual, 10)
		})

		Convey("It should accept and match human-readable route-definitions", func() {
			route, params := router.Dispatch("GET", "/articles/52ae7a391db36bc0ff000001")
			So(route.Name, ShouldEqual, "articles_mongo")
			So(params["id"], ShouldEqual, "52ae7a391db36bc0ff000001")
		})

		Convey("It should fail when the route doesn't match", func() {
			route, _ := router.Dispatch("GET", "/articles")
			So(route, ShouldBeNil)
		})

		Convey("It should not match group routes missing the group prefix", func() {
			route, _ := router.Dispatch("GET", "/52ae7a391db36bc0ff000001")
			So(route, ShouldBeNil)
		})

		Convey("It should generate route URL", func() {
			So(router.URL("articles_section", "section", "technology", "id", 20), ShouldEqual, "/articles/technology/20")
		})

		Convey("It should only match routes that match the request method", func() {
			route, _ := router.Dispatch("POST", "/articles/10")
			So(route, ShouldBeNil)
		})
	})
}
