package erc

import (
	"testing"

	"github.com/cirbo-lang/cirbo/cbo"
)

func TestNetQueue(t *testing.T) {
	q := newNetQueue(3)

	if got, want := q.Len(), 0; got != want {
		t.Errorf("wrong initial length %d; want %d", got, want)
	}

	netA := &cbo.Net{}
	netB := &cbo.Net{}
	netC := &cbo.Net{}
	netD := &cbo.Net{}
	netNames := map[*cbo.Net]string{
		netA: "A",
		netB: "B",
		netC: "C",
		netD: "D",
	}

	q.Append(netA)
	q.Append(netA)

	if got, want := q.Len(), 1; got != want {
		t.Errorf("wrong length after appending A twice %d; want %d", got, want)
	}

	if got, want := q.Peek(), netA; got != want {
		t.Errorf("wrong net peeked %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), netA; got != want {
		t.Errorf("wrong net taken %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), (*cbo.Net)(nil); got != want {
		t.Errorf("wrong net taken %q after emptied; want %q", netNames[got], netNames[want])
	}

	q.Append(netA)
	if got, want := q.Len(), 1; got != want {
		t.Errorf("wrong length after re-appending A %d; want %d", got, want)
	}

	q.Append(netB)
	q.Append(netC) // wraps list tail around to the start of the buffer
	q.Append(netD) // extends queue beyond initial capacity

	if got, want := q.Len(), 4; got != want {
		t.Errorf("wrong length after appending all nets %d; want %d", got, want)
	}

	if got, want := q.Take(), netA; got != want {
		t.Errorf("wrong net taken on first step %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), netB; got != want {
		t.Errorf("wrong net taken on second step %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), netC; got != want {
		t.Errorf("wrong net taken on third step %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), netD; got != want {
		t.Errorf("wrong net taken on forth step %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Take(), (*cbo.Net)(nil); got != want {
		t.Errorf("wrong net taken %q after emptied; want %q", netNames[got], netNames[want])
	}

	if got, want := q.Peek(), (*cbo.Net)(nil); got != want {
		t.Errorf("wrong net peeked %q after emptied; want %q", netNames[got], netNames[want])
	}

	// Append one more time to make sure our start location wrapped around properly as we
	// emptied the queue.
	q.Append(netA)
	if got, want := q.Take(), netA; got != want {
		t.Errorf("wrong net taken on final push %q; want %q", netNames[got], netNames[want])
	}
	if got, want := q.Peek(), (*cbo.Net)(nil); got != want {
		t.Errorf("wrong net peeked %q after emptied; want %q", netNames[got], netNames[want])
	}
}
