package wrapper

import (
	. "launchpad.net/gocheck"
)

type dispatcherSuite struct{}

var _ = Suite(&dispatcherSuite{})

func (s *dispatcherSuite) TestDispatch(c *C) {
	r := makeRack(
		Dispatch(
			Map(
				MatchQuery{"name", "peter"}, webwrite("peter"),
				MatchQuery{"name", "paul"}, webwrite("paul"),
			),
		),
	)
	rw, req := newTestRequest("GET", "/?name=peter")
	r.ServeHTTP(rw, req)
	assertResponse(c, rw, "peter", 200)

	rw, req = newTestRequest("GET", "/?name=paul")
	r.ServeHTTP(rw, req)
	assertResponse(c, rw, "paul", 200)
}
