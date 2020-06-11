package akka

import (
	"time"
)

type MessageDispatcher interface {
	Attach(actor ActorCell)
	Detach(actor ActorCell)
	EventStream() EventStream
	Execute(runnable Runnable)
	Mailboxes()
	RegisterForExecution(mailbox Mailbox, hasMessageHint bool, hasSystemMessageHint bool) bool

	CreateMailbox(actor Cell, mailboxType MailboxType) Mailbox

	Throughput() int
	ThroughputTimeout() time.Duration

	Dispatch(receiver ActorCell, invocation Envelope) error
	SystemDispatch(receiver ActorCell, invocation SystemMessage) error
}
