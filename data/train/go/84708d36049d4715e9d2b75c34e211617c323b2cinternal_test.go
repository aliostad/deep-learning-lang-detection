package events

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestDispatchSenderPresent(t *testing.T) {
	Verbosity = 3

	io := make(chan Event)
	c := listener{".", io}
	e := Event{".", nil}
	go func() {
		ret := dispatch(c, e)
		require.True(t, ret, "dispatch should indicate present listener is present")
	}()
	require.Equal(t, e, <-io, "dispatch should send dispatched event")
}

func TestDispatchSenderLeft(t *testing.T) {
	Verbosity = 3

	io := make(chan Event)
	c := listener{".", io}
	e := Event{".", nil}

	close(io)

	var ret bool
	require.NotPanics(t, func() {
		ret = dispatch(c, e)
	}, "dispatch should not panic when listener has left")
	require.False(t, ret, "dispatch should indicate that listener has left")
}

func TestDispatchNoMatch(t *testing.T) {
	Verbosity = 3

	io := make(chan Event)
	c := listener{"nomatch", io}
	e := Event{".", nil}
	ret := dispatch(c, e)
	// The above would block indefinitely if the listener was notified,
	// since we're not listening on the channel. Thus, getting here means
	// no notification was sent.
	require.True(t, ret)

	// This can probably not happen.
	require.Empty(t, io, "dispatch should not dispatch event to non-matching listener")
}

func TestEventString(t *testing.T) {
	// This is *only* here for test coverage of String()
	e := Event{"example.hello.world", nil}
	require.Contains(t, e.String(), "example.hello.world", "tag should appear in Event.String()")
}
