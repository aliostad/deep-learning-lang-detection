package dispatch

import (
	"fmt"
	"testing"

	"github.com/aarondl/ultimateq/irc"
)

func checkArrays(expected []string, actual []string) error {
	if len(expected) != len(actual) {
		return fmt.Errorf("length expected: %v got: %v",
			len(expected), len(actual))
	}
	for i, v := range expected {
		if v != actual[i] {
			return fmt.Errorf("expected: %v got: %v", v, actual[i])
		}
	}
	return nil
}

var netInfo = irc.NewNetworkInfo()

func TestDispatchCore(t *testing.T) {
	t.Parallel()
	d := NewDispatchCore(nil)
	if d == nil {
		t.Error("Create should create things.")
	}
}

func TestDispatchCore_Synchronization(t *testing.T) {
	t.Parallel()
	d := NewDispatchCore(nil)
	d.HandlerStarted()
	d.HandlerStarted()
	d.HandlerFinished()
	d.HandlerFinished()
	d.WaitForHandlers()
}

func TestDispatchCore_AddRemoveChannels(t *testing.T) {
	t.Parallel()
	chans := []string{"#chan1", "#chan2", "#chan3"}
	d := NewDispatchCore(nil, chans...)

	if err := checkArrays(chans, d.chans); err != nil {
		t.Error(err)
	}

	d.RemoveChannels(chans...)
	if d.chans != nil {
		t.Error("Removing everything should remove everything.")
	}
	d.RemoveChannels(chans...)
	if d.chans != nil {
		t.Error("Removing everything should remove everything.")
	}
	d.RemoveChannels()
	if d.chans != nil {
		t.Error("Removing nothing should add test coverage.")
	}

	d.SetChannels(chans)
	d.RemoveChannels(chans[1:]...)
	if err := checkArrays(chans[:1], d.chans); err != nil {
		t.Error(err)
	}
	d.AddChannels(chans[1:]...)
	if err := checkArrays(chans, d.chans); err != nil {
		t.Error(err)
	}
	d.AddChannels(chans[0])
	d.AddChannels()
	if err := checkArrays(chans, d.chans); err != nil {
		t.Error(err)
	}
	d.RemoveChannels(chans...)
	d.AddChannels(chans...)
	if err := checkArrays(chans, d.chans); err != nil {
		t.Error(err)
	}
}

func TestDispatchCore_Channels(t *testing.T) {
	t.Parallel()
	d := NewDispatchCore(nil)

	if d.Channels() != nil {
		t.Error("Should start uninitialized.")
	}
	chans := []string{"#chan1", "#chan2"}
	d.SetChannels(chans)
	if err := checkArrays(d.chans, d.Channels()); err != nil {
		t.Error(err)
	}

	first := d.Channels()
	first[0] = "#chan3"
	if err := checkArrays(d.chans, d.Channels()); err != nil {
		t.Error(err)
		t.Error("The array should be copied so data changes do not affect it.")
	}
}

func TestDispatchCore_UpdateChannels(t *testing.T) {
	t.Parallel()
	d := NewDispatchCore(nil)
	chans := []string{"#chan1", "#chan2"}
	d.SetChannels(chans)
	if err := checkArrays(chans, d.chans); err != nil {
		t.Error("SetChannels were not set correctly.")
	}
	d.SetChannels([]string{})
	if d.chans != nil {
		t.Error("It should be nil after an empty set.")
	}
	d.SetChannels(chans)
	if err := checkArrays(chans, d.chans); err != nil {
		t.Error("Channels were not set correctly.")
	}
	d.SetChannels(nil)
	if d.chans != nil {
		t.Error("It should be nil after an empty set.")
	}
}

func TestDispatchCore_CheckTarget(t *testing.T) {
	t.Parallel()

	ni1, ni2 := irc.NewNetworkInfo(), irc.NewNetworkInfo()
	ni1.ParseISupport(&irc.Event{Args: []string{"nick", "CHANTYPES=#"}})
	ni2.ParseISupport(&irc.Event{Args: []string{"nick", "CHANTYPES=&"}})

	ev1 := irc.NewEvent("", ni1, irc.PRIVMSG, "", "#chan", "msg")
	ev2 := irc.NewEvent("", ni1, irc.PRIVMSG, "", "&chan", "msg")

	d := NewDispatchCore(nil)
	if isChan, _ := d.CheckTarget(ev1); !isChan {
		t.Error("Expected it to be a channel.")
	}
	if isChan, _ := d.CheckTarget(ev2); isChan {
		t.Error("Expected it to not be a channel.")
	}

	ev1 = irc.NewEvent("", ni2, irc.PRIVMSG, "", "#chan", "msg")
	ev2 = irc.NewEvent("", ni2, irc.PRIVMSG, "", "&chan", "msg")

	if isChan, _ := d.CheckTarget(ev1); isChan {
		t.Error("Expected it to not be a channel.")
	}
	if isChan, _ := d.CheckTarget(ev2); !isChan {
		t.Error("Expected it to be a channel.")
	}
}

func TestDispatchCore_filterChannelDispatch(t *testing.T) {
	t.Parallel()
	d := NewDispatchCore(nil, []string{"#CHAN"}...)
	if d.chans == nil {
		t.Error("Initialization failed.")
	}

	if has := d.hasChannel("#chan"); !has {
		t.Error("It should have this channel.")
	}
	if has := d.hasChannel("#chan2"); has {
		t.Error("It should not have this channel.")
	}
}
