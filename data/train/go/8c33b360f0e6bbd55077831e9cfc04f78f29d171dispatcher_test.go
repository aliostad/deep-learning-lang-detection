package dispatch

import (
	"bytes"
	"testing"
	"time"

	"github.com/aarondl/ultimateq/irc"
	"gopkg.in/inconshreveable/log15.v2"
)

//===========================================================
// Set up a type that can be used to mock irc.Writer
//===========================================================
type testPoint struct {
	irc.Helper
}

//===========================================================
// Set up a type that can be used to mock a callback for raw.
//===========================================================
type testCallback func(w irc.Writer, ev *irc.Event)

type testHandler struct {
	callback testCallback
}

func (handler testHandler) HandleRaw(w irc.Writer, ev *irc.Event) {
	if handler.callback != nil {
		handler.callback(w, ev)
	}
}

//===========================================================
// Tests
//===========================================================
func TestDispatcher(t *testing.T) {
	t.Parallel()
	d := NewDispatcher(NewDispatchCore(nil))
	if d == nil || d.events == nil {
		t.Error("Initialization failed.")
	}
}

func TestDispatcher_Registration(t *testing.T) {
	t.Parallel()
	d := NewDispatcher(NewDispatchCore(nil))
	handler := testHandler{}

	id := d.Register("", "", irc.PRIVMSG, handler)
	if id == 0 {
		t.Error("It should have given back an id.")
	}
	id2 := d.Register("", "", irc.PRIVMSG, handler)
	if id == id2 {
		t.Error("It should not produce duplicate ids.")
	}
	if !d.Unregister(id) {
		t.Error("It should unregister via it's id regardless of string case")
	}
	if d.Unregister(id) {
		t.Error("It should not unregister the same event multiple times.")
	}
}

func TestDispatcher_JoinHandlerUsesChannels(t *testing.T) {
	t.Parallel()
	var msg1 *irc.Event
	var s1 irc.Writer
	h1 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg1 = ev
		s1 = w
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	send := testPoint{irc.Helper{}}

	d.Register("gamesurge", "#zamn", irc.JOIN, h1)

	var netInfo = irc.NewNetworkInfo()

	join := &irc.Event{NetworkID: "gamesurge", Name: irc.JOIN, Sender: "zamn!~Adam@zamN.x.gamesurge", Args: []string{"#zamN"}, Time: time.Now(), NetworkInfo: netInfo}

	d.Dispatch(send, join)
	d.WaitForHandlers()

	if msg1 == nil {
		t.Fatal("Failed to dispatch to h1.")
	}
}

func TestDispatcher_RegistrationBadHandler(t *testing.T) {
	t.Parallel()

	defer func() {
		if rec := recover(); rec == nil {
			t.Error("Expected a panic when bad handler is registered.")
		}
	}()

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.PRIVMSG, 5)
}

func TestDispatcher_Dispatching(t *testing.T) {
	t.Parallel()
	var msg1, msg2, msg3 *irc.Event
	var s1, s2 irc.Writer
	h1 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg1 = ev
		s1 = w
	}}
	h2 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg2 = ev
		s2 = w
	}}
	h3 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg3 = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	send := testPoint{irc.Helper{}}

	d.Register("", "", irc.PRIVMSG, h1)
	d.Register("", "", irc.PRIVMSG, h2)
	d.Register("", "", irc.QUIT, h3)

	privmsg := &irc.Event{NetworkID: "net", Name: irc.PRIVMSG}
	quitmsg := &irc.Event{NetworkID: "net", Name: irc.QUIT}
	d.Dispatch(send, privmsg)
	d.WaitForHandlers()

	if msg1 == nil {
		t.Error("Failed to dispatch to h1.")
	}
	if msg1.Name != irc.PRIVMSG {
		t.Error("Got the wrong ev name:", msg1.Name)
	}
	if msg1 != msg2 {
		t.Error("Failed to dispatch to msg2, or the ev data is not shared.")
	}
	if s1 == nil {
		t.Error("The endpoint should never be nil.")
	}
	if s1 != s2 {
		t.Error("The endpoint should be shared.")
	}
	if msg3 != nil {
		t.Error("Erroneously dispatched to h3.")
	}

	d.Dispatch(send, quitmsg)
	d.WaitForHandlers()
	if msg3.Name != irc.QUIT {
		t.Error("Failed to dispatch to h3.")
	}
}

func TestDispatcher_Filtering(t *testing.T) {
	t.Parallel()

	d := NewDispatcher(NewDispatchCore(nil))

	var called bool
	h := testHandler{func(w irc.Writer, ev *irc.Event) {
		called = true
	}}

	var tests = []struct {
		netID, channel, msg string
		should              bool
	}{
		{"", "", "", true},

		// Varying filters
		{"net", "", "", true},
		{"diff", "", "", false},
		{"", "#chan", "", true},
		{"", "#diff", "", false},
		{"", "", irc.NOTICE, true},
		{"", "", irc.PRIVMSG, false},

		// Net constant
		{"net", "#chan", "", true},
		{"net", "#diff", "", false},
		{"net", "", irc.NOTICE, true},
		{"net", "", irc.PRIVMSG, false},

		// Chan constant
		{"", "#chan", irc.NOTICE, true},
		{"", "#chan", irc.PRIVMSG, false},
		{"net", "#chan", "", true},
		{"diff", "#chan", "", false},

		// Msg constant
		{"net", "", irc.NOTICE, true},
		{"diff", "", irc.NOTICE, false},
		{"", "#chan", irc.NOTICE, true},
		{"", "#diff", irc.NOTICE, false},

		// Net & Chan Constant
		{"net", "#chan", irc.NOTICE, true},
		{"net", "#chan", irc.PRIVMSG, false},

		// Chan & Msg Constant
		{"net", "#chan", irc.NOTICE, true},
		{"diff", "#chan", irc.NOTICE, false},

		// Net & Msg Constant
		{"net", "#chan", irc.NOTICE, true},
		{"net", "#diff", irc.NOTICE, false},
	}

	notice := &irc.Event{
		NetworkID:   "net",
		NetworkInfo: netInfo,
		Name:        irc.NOTICE,
		Args:        []string{"#chan", "msg"},
	}

	for _, test := range tests {
		id := d.Register(test.netID, test.channel, test.msg, h)

		called = false

		d.Dispatch(nil, notice)
		d.WaitForHandlers()

		if called != test.should {
			t.Error("Expected called to be:", test.should)
			t.Errorf("net: %q, ch: %q, msg: %q",
				test.netID, test.channel, test.msg)
		}

		if !d.Unregister(id) {
			t.Fatal("Could not unregister id:", id)
		}
	}
}

func TestDispatcher_RawDispatch(t *testing.T) {
	t.Parallel()
	var msg1, msg2 *irc.Event
	h1 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg1 = ev
	}}
	h2 := testHandler{func(w irc.Writer, ev *irc.Event) {
		msg2 = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	send := testPoint{irc.Helper{}}
	d.Register("", "", irc.PRIVMSG, h1)
	d.Register("", "", "", h2)

	privmsg := &irc.Event{NetworkID: "net", Name: irc.PRIVMSG}
	d.Dispatch(send, privmsg)
	d.WaitForHandlers()
	if msg1 != privmsg {
		t.Error("Failed to dispatch to privmsg handler.")
	}
	if msg1 != msg2 {
		t.Error("Failed to dispatch to raw.")
	}
}

// ================================
// Testing types
// ================================
type testCallbackMsg func(irc.Writer, *irc.Event)
type testCTCPCallbackMsg func(irc.Writer, *irc.Event, string, string)

type testPrivmsgHandler struct {
	callback testCallbackMsg
}
type testPrivmsgUserHandler struct {
	callback testCallbackMsg
}
type testPrivmsgChannelHandler struct {
	callback testCallbackMsg
}
type testPrivmsgAllHandler struct {
	testCallbackNormal, testCallbackUser, testCallbackChannel testCallbackMsg
}
type testNoticeHandler struct {
	callback testCallbackMsg
}
type testNoticeUserHandler struct {
	callback testCallbackMsg
}
type testNoticeChannelHandler struct {
	callback testCallbackMsg
}
type testNoticeAllHandler struct {
	testCallbackNormal, testCallbackUser, testCallbackChannel testCallbackMsg
}
type testCTCPHandler struct {
	callback testCTCPCallbackMsg
}
type testCTCPChannelHandler struct {
	callback testCTCPCallbackMsg
}
type testCTCPAllHandler struct {
	testCallbackNormal, testCallbackChannel testCTCPCallbackMsg
}
type testCTCPReplyHandler struct {
	callback testCTCPCallbackMsg
}

// ================================
// Testing Callbacks
// ================================
func (t testPrivmsgHandler) Privmsg(w irc.Writer, ev *irc.Event) {
	t.callback(w, ev)
}
func (t testPrivmsgUserHandler) PrivmsgUser(
	w irc.Writer, ev *irc.Event) {

	t.callback(w, ev)
}
func (t testPrivmsgChannelHandler) PrivmsgChannel(
	w irc.Writer, ev *irc.Event) {

	t.callback(w, ev)
}
func (t testPrivmsgAllHandler) Privmsg(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackNormal(w, ev)
}
func (t testPrivmsgAllHandler) PrivmsgUser(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackUser(w, ev)
}
func (t testPrivmsgAllHandler) PrivmsgChannel(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackChannel(w, ev)
}
func (t testNoticeHandler) Notice(w irc.Writer, ev *irc.Event) {
	t.callback(w, ev)
}
func (t testNoticeUserHandler) NoticeUser(
	w irc.Writer, ev *irc.Event) {

	t.callback(w, ev)
}
func (t testNoticeChannelHandler) NoticeChannel(
	w irc.Writer, ev *irc.Event) {

	t.callback(w, ev)
}
func (t testNoticeAllHandler) Notice(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackNormal(w, ev)
}
func (t testNoticeAllHandler) NoticeUser(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackUser(w, ev)
}
func (t testNoticeAllHandler) NoticeChannel(
	w irc.Writer, ev *irc.Event) {

	t.testCallbackChannel(w, ev)
}
func (t testCTCPHandler) CTCP(w irc.Writer, ev *irc.Event, a, b string) {
	t.callback(w, ev, a, b)
}
func (t testCTCPChannelHandler) CTCPChannel(
	w irc.Writer, ev *irc.Event, a, b string) {

	t.callback(w, ev, a, b)
}
func (t testCTCPAllHandler) CTCP(
	w irc.Writer, ev *irc.Event, a, b string) {

	t.testCallbackNormal(w, ev, a, b)
}
func (t testCTCPAllHandler) CTCPChannel(
	w irc.Writer, ev *irc.Event, a, b string) {

	t.testCallbackChannel(w, ev, a, b)
}
func (t testCTCPReplyHandler) CTCPReply(
	w irc.Writer, ev *irc.Event, a, b string) {

	t.callback(w, ev, a, b)
}

var privChanmsg = &irc.Event{
	Name:        irc.PRIVMSG,
	Args:        []string{"#chan", "ev"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}
var privUsermsg = &irc.Event{
	Name:        irc.PRIVMSG,
	Args:        []string{"user", "ev"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}

func TestDispatcher_Privmsg(t *testing.T) {
	t.Parallel()
	var p, pu, pc *irc.Event
	ph := testPrivmsgHandler{func(w irc.Writer, ev *irc.Event) {
		p = ev
	}}
	puh := testPrivmsgUserHandler{func(w irc.Writer, ev *irc.Event) {
		pu = ev
	}}
	pch := testPrivmsgChannelHandler{func(w irc.Writer, ev *irc.Event) {
		pc = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.PRIVMSG, ph)
	d.Register("", "", irc.PRIVMSG, puh)
	d.Register("", "", irc.PRIVMSG, pch)

	d.Dispatch(nil, privUsermsg)
	d.WaitForHandlers()
	if p == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if pu != p {
		t.Error("Failed to dispatch to user handler.")
	}
	if pc != nil {
		t.Error("Erroneously to dispatched to channel handler.")
	}

	p, pu, pc = nil, nil, nil
	d.Dispatch(nil, privChanmsg)
	d.WaitForHandlers()
	if p == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if pu != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
	if pc != p {
		t.Error("Failed to dispatch to channel handler.")
	}
}

func TestDispatcher_PrivmsgMultiple(t *testing.T) {
	t.Parallel()
	var p, pu, pc *irc.Event
	pall := testPrivmsgAllHandler{
		func(w irc.Writer, ev *irc.Event) {
			p = ev
		},
		func(w irc.Writer, ev *irc.Event) {
			pu = ev
		},
		func(w irc.Writer, ev *irc.Event) {
			pc = ev
		},
	}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.PRIVMSG, pall)

	p, pu, pc = nil, nil, nil
	d.Dispatch(nil, privChanmsg)
	d.WaitForHandlers()
	if p != nil {
		t.Error("Erroneously dispatched to handler.")
	}
	if pu != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
	if pc == nil {
		t.Error("Failed to dispatch to channel handler.")
	}

	p, pu, pc = nil, nil, nil
	d.Dispatch(nil, privUsermsg)
	d.WaitForHandlers()
	if p != nil {
		t.Error("Erroneously dispatched to handler.")
	}
	if pu == nil {
		t.Error("Failed to dispatch to user handler.")
	}
	if pc != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
}

var noticeChanmsg = &irc.Event{
	Name:        irc.NOTICE,
	Args:        []string{"#chan", "ev"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}
var noticeUsermsg = &irc.Event{
	Name:        irc.NOTICE,
	Args:        []string{"user", "ev"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}

func TestDispatcher_Notice(t *testing.T) {
	t.Parallel()
	var n, nu, nc *irc.Event
	nh := testNoticeHandler{func(w irc.Writer, ev *irc.Event) {
		n = ev
	}}
	nuh := testNoticeUserHandler{func(w irc.Writer, ev *irc.Event) {
		nu = ev
	}}
	nch := testNoticeChannelHandler{func(w irc.Writer, ev *irc.Event) {
		nc = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.NOTICE, nh)
	d.Register("", "", irc.NOTICE, nuh)
	d.Register("", "", irc.NOTICE, nch)

	d.Dispatch(nil, noticeUsermsg)
	d.WaitForHandlers()
	if n == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if nu != n {
		t.Error("Failed to dispatch to user handler.")
	}
	if nc != nil {
		t.Error("Erroneously dispatched to channel handler.")
	}

	n, nu, nc = nil, nil, nil
	d.Dispatch(nil, noticeChanmsg)
	d.WaitForHandlers()
	if n == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if nu != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
	if nc != n {
		t.Error("Failed to dispatch to channel handler.")
	}
}

func TestDispatcher_NoticeMultiple(t *testing.T) {
	t.Parallel()
	var n, nu, nc *irc.Event
	nall := testNoticeAllHandler{
		func(w irc.Writer, ev *irc.Event) {
			n = ev
		},
		func(w irc.Writer, ev *irc.Event) {
			nu = ev
		},
		func(w irc.Writer, ev *irc.Event) {
			nc = ev
		},
	}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.NOTICE, nall)

	n, nu, nc = nil, nil, nil
	d.Dispatch(nil, noticeChanmsg)
	d.WaitForHandlers()
	if n != nil {
		t.Error("Erroneously dispatched to handler.")
	}
	if nu != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
	if nc == nil {
		t.Error("Failed to dispatch to channel handler.")
	}

	n, nu, nc = nil, nil, nil
	d.Dispatch(nil, noticeUsermsg)
	d.WaitForHandlers()
	if n != nil {
		t.Error("Erroneously dispatched to handler.")
	}
	if nu == nil {
		t.Error("Failed to dispatch to user handler.")
	}
	if nc != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
}

var ctcpChanmsg = &irc.Event{
	Name:        irc.CTCP,
	Args:        []string{"#chan", "\x01msg args\x01"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}
var ctcpMsg = &irc.Event{
	Name:        irc.CTCP,
	Args:        []string{"user", "\x01msg args\x01"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}

func TestDispatcher_CTCP(t *testing.T) {
	t.Parallel()
	var c, cc *irc.Event
	ch := testCTCPHandler{func(_ irc.Writer, ev *irc.Event, tag, data string) {
		c = ev
	}}
	cch := testCTCPChannelHandler{func(_ irc.Writer, ev *irc.Event, tag,
		data string) {

		cc = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.CTCP, ch)
	d.Register("", "", irc.CTCP, cch)

	d.Dispatch(nil, ctcpMsg)
	d.WaitForHandlers()
	if c == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if cc != nil {
		t.Error("Erroneously dispatched to channel handler.")
	}

	c, cc = nil, nil
	d.Dispatch(nil, ctcpChanmsg)
	d.WaitForHandlers()
	if c == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if cc == nil {
		t.Error("Failed to dispatch to channel handler.")
	}
}

func TestDispatcher_CTCPMultiple(t *testing.T) {
	t.Parallel()
	var c, cc *irc.Event
	call := testCTCPAllHandler{
		func(_ irc.Writer, ev *irc.Event, a, b string) {
			c = ev
		},
		func(_ irc.Writer, ev *irc.Event, a, b string) {
			cc = ev
		},
	}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.CTCP, call)

	c, cc = nil, nil
	d.Dispatch(nil, ctcpChanmsg)
	d.WaitForHandlers()
	if c != nil {
		t.Error("Erroneously dispatched to handler.")
	}
	if cc == nil {
		t.Error("Failed to dispatch to channel handler.")
	}

	c, cc = nil, nil
	d.Dispatch(nil, ctcpMsg)
	d.WaitForHandlers()
	if c == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if cc != nil {
		t.Error("Erroneously dispatched to user handler.")
	}
}

var ctcpReplyMsg = &irc.Event{
	Name:        irc.CTCPReply,
	Args:        []string{"user", "\x01msg args\x01"},
	Sender:      "nick!user@host.com",
	NetworkInfo: netInfo,
	NetworkID:   "net",
}

func TestDispatcher_CTCPReply(t *testing.T) {
	t.Parallel()
	var c *irc.Event
	ch := testCTCPReplyHandler{func(_ irc.Writer, ev *irc.Event, tag,
		data string) {

		c = ev
	}}

	d := NewDispatcher(NewDispatchCore(nil))
	d.Register("", "", irc.CTCPReply, ch)

	d.Dispatch(nil, ctcpReplyMsg)
	d.WaitForHandlers()
	if c == nil {
		t.Error("Failed to dispatch to handler.")
	}
}
func TestDispatcher_FilterPrivmsgChannels(t *testing.T) {
	t.Parallel()
	chanmsg2 := &irc.Event{
		Name:        irc.PRIVMSG,
		Args:        []string{"#chan2", "ev"},
		Sender:      "nick!user@host.com",
		NetworkInfo: netInfo,
		NetworkID:   "net",
	}

	var p, pc *irc.Event
	ph := testPrivmsgHandler{func(w irc.Writer, ev *irc.Event) {
		p = ev
	}}
	pch := testPrivmsgChannelHandler{func(w irc.Writer, ev *irc.Event) {
		pc = ev
	}}

	dcore := NewDispatchCore(nil, "#CHAN")
	d := NewDispatcher(dcore)
	d.Register("", "", irc.PRIVMSG, ph)
	d.Register("", "", irc.PRIVMSG, pch)

	d.Dispatch(nil, privChanmsg)
	d.WaitForHandlers()
	if p == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if pc != p {
		t.Error("Failed to dispatch to channel handler.")
	}

	p, pc = nil, nil
	d.Dispatch(nil, chanmsg2)
	d.WaitForHandlers()
	if p == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if pc != nil {
		t.Error("Erronously dispatched to channel handler.")
	}
}

func TestDispatcher_FilterNoticeChannels(t *testing.T) {
	t.Parallel()
	chanmsg2 := &irc.Event{
		Name:        irc.NOTICE,
		Args:        []string{"#chan2", "ev"},
		Sender:      "nick!user@host.com",
		NetworkInfo: netInfo,
		NetworkID:   "network",
	}

	var u, uc *irc.Event
	uh := testNoticeHandler{func(w irc.Writer, ev *irc.Event) {
		u = ev
	}}
	uch := testNoticeChannelHandler{func(w irc.Writer, ev *irc.Event) {
		uc = ev
	}}

	dcore := NewDispatchCore(nil, "#CHAN")
	d := NewDispatcher(dcore)
	d.Register("", "", irc.NOTICE, uh)
	d.Register("", "", irc.NOTICE, uch)

	d.Dispatch(nil, noticeChanmsg)
	d.WaitForHandlers()
	if u == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if uc != u {
		t.Error("Failed to dispatch to channel handler.")
	}

	u, uc = nil, nil
	d.Dispatch(nil, chanmsg2)
	d.WaitForHandlers()
	if u == nil {
		t.Error("Failed to dispatch to handler.")
	}
	if uc != nil {
		t.Error("Erronously dispatched to channel handler.")
	}
}

func TestDispatchCore_ShouldDispatch(t *testing.T) {
	t.Parallel()
	d := NewDispatcher(NewDispatchCore(nil))

	var tests = []struct {
		IsChan bool
		Target string
		Expect bool
	}{
		{true, "#chan", true},
		{false, "#chan2", false},
		{true, "user", false},
		{false, "user", true},
	}

	for _, test := range tests {
		ev := irc.NewEvent("", netInfo, irc.PRIVMSG, "", test.Target)
		should := d.shouldDispatch(test.IsChan, ev)
		if should != test.Expect {
			t.Error("Fail:", test)
			t.Error("Expected:", test.Expect, "got:", should)
		}
	}
}

func TestDispatch_Panic(t *testing.T) {
	buf := &bytes.Buffer{}
	logger := log15.New()
	logger.SetHandler(log15.StreamHandler(buf, log15.LogfmtFormat()))

	logCore := NewDispatchCore(logger)
	d := NewDispatcher(logCore)

	panicMsg := "dispatch panic"
	handler := testHandler{
		func(w irc.Writer, ev *irc.Event) {
			panic(panicMsg)
		},
	}

	d.Register("", "", "", handler)
	ev := irc.NewEvent("network", netInfo, "dispatcher", irc.PRIVMSG, "panic test")
	d.Dispatch(testPoint{irc.Helper{}}, ev)
	d.WaitForHandlers()

	logStr := buf.String()

	if logStr == "" {
		t.Error("Expected not empty log.")
	}

	logBytes := buf.Bytes()
	if !bytes.Contains(logBytes, []byte(panicMsg)) {
		t.Errorf("Log does not contain: %s\n%s", panicMsg, logBytes)
	}

	if !bytes.Contains(logBytes, []byte("dispatcher_test.go")) {
		t.Error("Does not contain a reference to file that panic'd")
	}
}
