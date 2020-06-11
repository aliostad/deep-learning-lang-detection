package flow

import (
	"github.com/golang/glog"
)

func init() {
	Registry["Dispatcher"] = func() Circuitry {
		c := NewCircuit()
		c.AddCircuitry("head", &dispatchHead{})
		c.AddCircuitry("tail", &dispatchTail{})
		c.Connect("head.Feeds:", "tail.In", 0)  // keeps tail alive
		c.Connect("tail.Back", "head.Reply", 1) // must have room for reply
		c.Label("In", "head.In")
		c.Label("Prefix", "head.Prefix")
		c.Label("Rej", "head.Rej")
		c.Label("Out", "tail.Out")
		return c
	}
}

// A dispatcher sends messages to newly created gadgets, based on dispatch tags.
// These gadgets must have an In and an Out pin. Their output is merged into
// a single Out pin, the rest is sent to Rej. Registers as "Dispatcher".
type Dispatcher Circuit

// The implementation uses a circuit with dispatchHead and dispatchTail gadgets.
// Newly created gadgets are inserted "between" them, using Feeds as fanout.
// Switching needs special care to drain the preceding gadget output first.

type dispatchHead struct {
	Gadget
	In     Input
	Prefix Input
	Reply  Input
	Feeds  map[string]Output
	Rej    Output
}

func (g *dispatchHead) Run() {
	prefix := ""
	if p, ok := <-g.Prefix; ok {
		prefix = p.(string)
	}
	gadget := ""
	for m := range g.In {
		if tag, ok := m.(Tag); ok && tag.Tag == "<dispatch>" {
			if tag.Msg == gadget {
				continue
			}

			// send (unique!) marker and act on it once it comes back on Reply
			g.Feeds[gadget].Send(Tag{"<marker>", g.owner})
			<-g.Reply // TODO: add a timeout?

			// perform the switch, now that previous output has drained
			gadget = tag.Msg.(string)
			if g.Feeds[gadget] == nil {
				if Registry[prefix+gadget] == nil {
					glog.Warningln("cannot dispatch:", prefix+gadget)
					g.Rej.Send(tag) // report that no such gadget was found
					gadget = ""
				} else { // create, hook up, and launch the new gadget
					glog.Infoln("dispatching to:", prefix+gadget)
					c := g.owner
					c.Add(gadget, prefix+gadget)
					c.Connect("head.Feeds:"+gadget, gadget+".In", 0)
					c.Connect(gadget+".Out", "tail.In", 0)
					c.gadgets[gadget].launch()
				}
			}

			// pass through a "consumed" dispatch tag
			g.Feeds[""].Send(Tag{"<dispatched>", gadget})
			continue
		}

		feed := g.Feeds[gadget]
		if feed == nil {
			feed = g.Rej
		}
		feed.Send(m)
	}
}

type dispatchTail struct {
	Gadget
	In   Input
	Back Output
	Out  Output
}

func (g *dispatchTail) Run() {
	for m := range g.In {
		if tag, ok := m.(Tag); ok && tag.Tag == "<marker>" && tag.Msg == g.owner {
			g.Back.Send(m)
		} else {
			g.Out.Send(m)
		}
	}
}
