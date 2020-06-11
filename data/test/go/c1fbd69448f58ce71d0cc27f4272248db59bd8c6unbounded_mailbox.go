package dispatch

import (
	"github.com/go-akka/akka"
	"github.com/go-akka/akka/pkg/class_loader"
	"github.com/go-akka/configuration"
)

func init() {
	class_loader.Default.Register((*UnboundedMailbox)(nil), "akka.dispatch.unbounded-mailbox")
}

type UnboundedMailbox struct {
}

func NewUnboundedMailbox() akka.MailboxType {
	return &UnboundedMailbox{}
}

func (p *UnboundedMailbox) Init(settings *akka.Settings, config *configuration.Config) (err error) {
	return
}

func (p *UnboundedMailbox) Create(owner akka.ActorRef, system akka.ActorSystem) akka.MessageQueue {
	return NewUnboundedMessageQueue()
}
