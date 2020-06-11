package main

import (
	"strings"
	. "github.com/ziemerz/gogobotv2/gogotypes"
)

type Dispatcher struct {
	incoming chan *Message
	outgoing chan *Message
	bot *Bot
}

func RunDispatcher(inc, out chan *Message, bot *Bot) {
	disp := new(Dispatcher)
	disp.outgoing = out
	disp.incoming = inc
	disp.bot = bot
	go disp.dispatch()
}

func (disp *Dispatcher) dispatch(){
	for msg := range disp.incoming {

		// Get the command of the message.
		cmd := strings.Split(msg.Content, " ")[1]

		// Dispatch to the correct command and let it handle the rest
		// Done in a goroutine to prevent blocking
		go disp.bot.commands[cmd].Fire(msg, disp.outgoing)
	}
}