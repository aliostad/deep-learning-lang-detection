package dispatch_test

import (
	"testing"

	"github.com/influx6/gu/dispatch"
	"github.com/influx6/gu/tests"
)

func TestResolver(t *testing.T) {
	rx := dispatch.NewResolver("/:id")
	params, _, state := rx.Test("12")

	if !state {
		tests.Failed(t, "Should have matched giving path")
	}
	tests.Passed(t, "Should have matched giving path")

	val, ok := params["id"]
	if !ok {
		tests.Failed(t, "Should have retrieve parameter :id => %s", val)
	}
	tests.Passed(t, "Should have retrieve parameter :id => %s", val)

	rx.ResolvedPassed(func(px dispatch.Path) {
		tests.Passed(t, "Should have notified with Path %#v", px)
	})

	rx.ResolvedFailed(func(px dispatch.Path) {
		tests.Failed(t, "Should have notified with Path %#v", px)
	})

	rx.Resolve(dispatch.UseLocation("/12"))
}

func TestResolverLevels(t *testing.T) {
	home := dispatch.NewResolver("/home/*")
	rx := dispatch.NewResolver("/:id")

	home.Register(rx)

	rx.ResolvedPassed(func(px dispatch.Path) {
		tests.Passed(t, "Should have notified with Path %#v", px)
	})

	rx.ResolvedFailed(func(px dispatch.Path) {
		tests.Failed(t, "Should have notified with Path %#v", px)
	})

	home.Resolve(dispatch.UseLocation("home/12"))
}

func TestResolverFailed(t *testing.T) {
	rx := dispatch.NewResolver("/:id")
	rx.ResolvedPassed(func(px dispatch.Path) {
		tests.Failed(t, "Should have notified with failed Path %#v", px)
	})

	rx.ResolvedFailed(func(px dispatch.Path) {
		tests.Passed(t, "Should have notified with failed Path %#v", px)
	})

	rx.Resolve(dispatch.UseLocation("/home/12"))
}
