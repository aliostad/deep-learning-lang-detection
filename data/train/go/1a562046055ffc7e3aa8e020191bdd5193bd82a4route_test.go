package routes

import (
	"testing"

	"github.com/influx6/gu"
	"github.com/influx6/gu/dispatch"
	"github.com/influx6/gu/tests"
)

func TestRoute(t *testing.T) {
	rm := gu.NewRouteManager()

	home := rm.L("/home/*")
	if _, _, pass := home.Test("/home/models/12"); !pass {
		tests.Failed(t, "Should have validated path /home/models/12")
	}
	tests.Passed(t, "Should have validated path /home/models/12")

	index := rm.L("/index/*")
	if _, _, pass := index.Test("/index"); !pass {
		tests.Failed(t, "Should have validated path /index")
	}
	tests.Passed(t, "Should have validated path /index")

	getModel := home.N("/models/*")
	if _, _, pass := getModel.Test("/models"); !pass {
		tests.Failed(t, "Should have validated path /models")
	}
	tests.Passed(t, "Should have validated path /models")

	if _, _, pass := getModel.Test("/models/12"); !pass {
		tests.Failed(t, "Should have validated path /models/12")
	}
	tests.Passed(t, "Should have validated path /models/12")

	id := getModel.N("/:id")
	param, _, pass := id.Test("/12")
	if !pass {
		tests.Failed(t, "Should have validated path /12")
	}
	tests.Passed(t, "Should have validated path /12: %#v", param)

	home.ResolvedPassed(func(px dispatch.Path) {
		tests.Passed(t, "Should have validated path /home/models/12:  /home")
	}).ResolvedFailed(func(px dispatch.Path) {
		tests.Failed(t, "Should have validated path /home/models/12:  /home")
	})

	getModel.ResolvedPassed(func(px dispatch.Path) {
		tests.Passed(t, "Should have validated path /home/models/12:  /models")
	}).ResolvedFailed(func(px dispatch.Path) {
		tests.Failed(t, "Should have validated path /home/models/12:  /models")
	})

	id.ResolvedPassed(func(px dispatch.Path) {
		tests.Passed(t, "Should have validated path /home/models/12:  /id")
	}).ResolvedFailed(func(px dispatch.Path) {
		tests.Failed(t, "Should have validated path /home/models/12:  /id")
	})

	home.Resolve(dispatch.UseLocation("/home/models/12"))
	home.Resolve(dispatch.UseLocationHash("http://thunderhouse.com/#home/models/12"))
}
